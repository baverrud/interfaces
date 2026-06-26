// =====================================================================
// mdio_phy.sv - MDIO PHY (register at address 0x01)
// =====================================================================
// Implements a simple MDIO PHY with one shadow register.
// Write: captures 16 data bits from MDIO
// Read:  drives shadow register onto MDIO after TA
// =====================================================================
module mdio_phy (
  input  logic    clk,
  input  logic    rstn,
  mdio_if.phy     s
);

  // ---- MDIO open-drain driver -----------------------------------
  logic mdio_drv;
  assign s.mdio = mdio_drv ? 1'b0 : 1'bz;

  // ---- MDC edge detection --------------------------------------
  logic mdc_prev;
  wire mdc_rise, mdc_fall;
  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) mdc_prev <= 0;
    else       mdc_prev <= s.mdc;
  end
  assign mdc_rise =  s.mdc && !mdc_prev;
  assign mdc_fall = !s.mdc &&  mdc_prev;

  // ---- sampled MDIO value --------------------------------------
  logic mdio_val;
  assign mdio_val = s.mdio;

  // ---- FSM -----------------------------------------------------
  typedef enum {
    IDLE,
    PRE, ST, OP, PHYAD, REGAD, TA,
    DATA_CAP,          // write: capture data
    TA_READY,          // read: prepare to drive
    DATA_SEND          // read: drive data
  } state_t;
  state_t state = IDLE;

  logic [5:0] bit_cnt;
  logic [15:0] shadow = 16'hA5A5;       // internal register
  logic        is_write;                 // 0=read, 1=write
  logic        addr_match;               // PHYAD matches

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      state      <= IDLE;
      mdio_drv   <= 0;
      bit_cnt    <= 0;
      addr_match <= 0;
    end else begin
      case (state)

        // IDLE: wait for ST=01 (start of frame)
        IDLE: begin
          mdio_drv <= 0;
          bit_cnt  <= 0;
          if (mdc_rise && mdio_val) begin
            // MDIO high on rising edge = possible start
            state <= PRE;
          end
        end

        // PRE: count preamble bits (32×1), detect ST=01
        PRE: begin
          if (mdc_rise) begin
            if (bit_cnt < 32) begin
              bit_cnt <= bit_cnt + 1;
            end else begin
              // Preamble done, expect ST
              bit_cnt <= 0;
              state   <= ST;
            end
            // If MDIO goes low, this might be ST starting
            if (!mdio_val && bit_cnt >= 2) begin
              bit_cnt <= 1;  // already got ST bit 0
              state   <= ST;
            end
          end
        end

        // ST: capture start-of-frame (2 bits = 01)
        ST: begin
          if (mdc_rise) begin
            if (bit_cnt == 0) begin
              // bit 0 should be 0
              bit_cnt <= 1;
            end else begin
              // bit 1 should be 1
              bit_cnt <= 0;
              state   <= OP;
            end
          end
        end

        // OP: capture operation code (2 bits)
        OP: begin
          if (mdc_rise) begin
            if (bit_cnt == 0) begin
              is_write <= mdio_val;      // OP[0]
              bit_cnt <= 1;
            end else begin
              // OP[1]: 01=write, 10=read
              is_write <= ~mdio_val;     // OP[1] determines write/read
              bit_cnt  <= 0;
              state    <= PHYAD;
            end
          end
        end

        // PHYAD: capture PHY address (5 bits)
        PHYAD: begin
          if (mdc_rise) begin
            if (bit_cnt < 5) begin
              // compare with expected address
              bit_cnt <= bit_cnt + 1;
            end else begin
              addr_match <= 1;  // simplified: always match
              bit_cnt <= 0;
              state   <= REGAD;
            end
          end
        end

        // REGAD: capture register address (5 bits)
        REGAD: begin
          if (mdc_rise) begin
            if (bit_cnt < 5) begin
              bit_cnt <= bit_cnt + 1;
            end else begin
              bit_cnt <= 0;
              state   <= TA;
            end
          end
        end

        // TA: turnaround (2 bits)
        TA: begin
          if (mdc_rise) begin
            if (bit_cnt == 0) begin
              bit_cnt <= 1;
            end else begin
              bit_cnt <= 0;
              if (is_write) begin
                state <= DATA_CAP;
              end else begin
                state <= TA_READY;
              end
            end
          end
        end

        // DATA_CAP: capture 16 data bits (write)
        DATA_CAP: begin
          if (mdc_rise) begin
            shadow <= {shadow[14:0], mdio_val};
            if (bit_cnt == 15) begin
              state <= IDLE;
            end else begin
              bit_cnt <= bit_cnt + 1;
            end
          end
        end

        // TA_READY: prepare to drive MDIO for read
        TA_READY: begin
          // Drive on MDC falling edge after TA
          if (mdc_fall) begin
            bit_cnt <= 0;
            state   <= DATA_SEND;
          end
        end

        // DATA_SEND: drive 16 data bits on MDC falling edges
        DATA_SEND: begin
          if (mdc_fall) begin
            mdio_drv <= ~shadow[15 - bit_cnt];
            if (bit_cnt == 15) begin
              state <= IDLE;
            end else begin
              bit_cnt <= bit_cnt + 1;
            end
          end
        end

      endcase
    end
  end

endmodule
