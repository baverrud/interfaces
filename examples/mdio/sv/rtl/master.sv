// =====================================================================
// mdio_manager.sv - MDIO manager (write then read test)
// =====================================================================
// Implements IEEE 802.3 Clause 22 MDIO:
//   1. Generate MDC (clk/2)
//   2. Write: PREAMBLE(32×1) + ST(01) + OP(01) + PHYAD + REGAD +
//      TA(10) + DATA(16 bits = 0xA5A5)
//   3. Read:  PREAMBLE + ST(01) + OP(10) + PHYAD + REGAD +
//      TA(Z0) + receive DATA, verify
// MDIO is open-drain: drive '0' for low, 'Z' for release
// =====================================================================
module mdio_manager #(
  parameter logic [4:0] PHY_ADDR = 5'h01,
  parameter logic [4:0] REG_ADDR = 5'h01,
  parameter logic [15:0] WR_DATA = 16'hA5A5
) (
  input  logic       clk,
  input  logic       rstn,
  mdio_if.manager    m,
  output logic       done
);

  // ---- MDC generation (clk/2) ----------------------------------
  logic mdc_reg;
  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) mdc_reg <= 0;
    else       mdc_reg <= ~mdc_reg;
  end
  assign m.mdc = mdc_reg;

  // ---- MDC edge detection --------------------------------------
  logic mdc_prev;
  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) mdc_prev <= 0;
    else       mdc_prev <= mdc_reg;
  end
  wire mdc_rise =  mdc_reg && !mdc_prev;  // sample
  wire mdc_fall = !mdc_reg &&  mdc_prev;  // drive

  // ---- MDIO open-drain driver ----------------------------------
  logic mdio_drv;     // 1 = pull low, 0 = release
  assign m.mdio = mdio_drv ? 1'b0 : 1'bz;

  // ---- sampled MDIO value --------------------------------------
  logic mdio_val;
  assign mdio_val = m.mdio;

  // ---- FSM -----------------------------------------------------
  typedef enum {
    IDLE,
    PRE_W, ST_W, OP_W, PHYAD_W, REGAD_W, TA_W, DATA_W,
    PRE_R, ST_R, OP_R, PHYAD_R, REGAD_R, TA_R, DATA_R,
    DONE_S
  } state_t;
  state_t state = IDLE;

  logic [5:0] bit_cnt;     // up to 32 for preamble
  logic [15:0] rx_data;    // received data

  // For each state, drive or sample one bit on each MDC falling edge
  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      state    <= IDLE;
      mdio_drv <= 0;
      done     <= 0;
    end else begin

      case (state)

        IDLE: begin
          bit_cnt  <= 0;
          state    <= PRE_W;
        end

        // ---- WRITE FRAME ---------------------------------------

        // PREAMBLE: 32 × '1' on MDIO
        PRE_W: begin
          if (mdc_fall) begin
            mdio_drv <= 0;               // release MDIO (high via pull-up = 1)
            if (bit_cnt == 31) begin
              bit_cnt <= 0;
              state   <= ST_W;
            end else begin
              bit_cnt <= bit_cnt + 1;
            end
          end
        end

        // ST: start of frame = 01
        ST_W: begin
          if (mdc_fall) begin
            if (bit_cnt == 0) mdio_drv <= 1;  // bit 0 = 0 (pull low)
            else             mdio_drv <= 0;   // bit 1 = 1 (release)
            if (bit_cnt == 1) begin
              bit_cnt <= 0;
              state   <= OP_W;
            end else begin
              bit_cnt <= bit_cnt + 1;
            end
          end
        end

        // OP: operation = 01 (write)
        OP_W: begin
          if (mdc_fall) begin
            if (bit_cnt == 0) mdio_drv <= 1;  // 0
            else             mdio_drv <= 0;   // 1
            if (bit_cnt == 1) begin
              bit_cnt <= 0;
              state   <= PHYAD_W;
            end else begin
              bit_cnt <= bit_cnt + 1;
            end
          end
        end

        // PHYAD: 5-bit PHY address (MSB first)
        PHYAD_W: begin
          if (mdc_fall) begin
            mdio_drv <= ~PHY_ADDR[4 - bit_cnt];
            if (bit_cnt == 4) begin
              bit_cnt <= 0;
              state   <= REGAD_W;
            end else begin
              bit_cnt <= bit_cnt + 1;
            end
          end
        end

        // REGAD: 5-bit register address (MSB first)
        REGAD_W: begin
          if (mdc_fall) begin
            mdio_drv <= ~REG_ADDR[4 - bit_cnt];
            if (bit_cnt == 4) begin
              bit_cnt <= 0;
              state   <= TA_W;
            end else begin
              bit_cnt <= bit_cnt + 1;
            end
          end
        end

        // TA: turnaround = 10 (manager drives both)
        TA_W: begin
          if (mdc_fall) begin
            mdio_drv <= 0;                // bit 0 = 1 (release)
            if (bit_cnt == 0) begin
              // First TA bit = 1 (Z)
              mdio_drv <= 0;
              bit_cnt <= 1;
            end else begin
              // Second TA bit = 0
              mdio_drv <= 1;
              bit_cnt <= 0;
              state   <= DATA_W;
            end
          end
        end

        // DATA: 16-bit write data (MSB first)
        DATA_W: begin
          if (mdc_fall) begin
            mdio_drv <= ~WR_DATA[15 - bit_cnt];
            if (bit_cnt == 15) begin
              bit_cnt <= 0;
              state   <= PRE_R;
            end else begin
              bit_cnt <= bit_cnt + 1;
            end
          end
        end

        // ---- READ FRAME ----------------------------------------

        PRE_R: begin
          if (mdc_fall) begin
            mdio_drv <= 0;               // release (1)
            if (bit_cnt == 31) begin
              bit_cnt <= 0;
              state   <= ST_R;
            end else begin
              bit_cnt <= bit_cnt + 1;
            end
          end
        end

        ST_R: begin
          if (mdc_fall) begin
            mdio_drv <= (bit_cnt == 0) ? 1 : 0;  // 0 then 1
            if (bit_cnt == 1) begin
              bit_cnt <= 0;
              state   <= OP_R;
            end else begin
              bit_cnt <= bit_cnt + 1;
            end
          end
        end

        OP_R: begin
          if (mdc_fall) begin
            mdio_drv <= (bit_cnt == 0) ? 0 : 1;  // 1 then 0 (OP=10 for read)
            if (bit_cnt == 1) begin
              bit_cnt <= 0;
              state   <= PHYAD_R;
            end else begin
              bit_cnt <= bit_cnt + 1;
            end
          end
        end

        PHYAD_R: begin
          if (mdc_fall) begin
            mdio_drv <= ~PHY_ADDR[4 - bit_cnt];
            if (bit_cnt == 4) begin
              bit_cnt <= 0;
              state   <= REGAD_R;
            end else begin
              bit_cnt <= bit_cnt + 1;
            end
          end
        end

        REGAD_R: begin
          if (mdc_fall) begin
            mdio_drv <= ~REG_ADDR[4 - bit_cnt];
            if (bit_cnt == 4) begin
              bit_cnt <= 0;
              state   <= TA_R;
            end else begin
              bit_cnt <= bit_cnt + 1;
            end
          end
        end

        // TA: turnaround = Z0 (manager releases, PHY drives)
        TA_R: begin
          if (mdc_fall) begin
            if (bit_cnt == 0) begin
              mdio_drv <= 0;              // release MDIO (Z)
              bit_cnt <= 1;
            end else begin
              // PHY drives 0 (but manager doesn't drive)
              bit_cnt <= 0;
              state   <= DATA_R;
            end
          end
        end

        // DATA_R: sample 16 bits on MDC rising edge
        DATA_R: begin
          if (mdc_rise) begin
            rx_data <= {rx_data[14:0], mdio_val};
            if (bit_cnt == 15) begin
              state <= DONE_S;
            end else begin
              bit_cnt <= bit_cnt + 1;
            end
          end
        end

        DONE_S: begin
          done <= 1;
        end

      endcase
    end
  end

endmodule
