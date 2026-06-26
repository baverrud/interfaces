// =====================================================================
// i2c_slave.sv - I2C slave at address 0x50
// =====================================================================
// Responds to I2C transactions:
//   Write: stores received byte into shadow register
//   Read:  sends shadow register value back
// Uses SCL rising-edge detection for all state transitions.
// =====================================================================
module i2c_slave (
  input  logic    clk,
  input  logic    rstn,
  i2c_if.slave    s
);

  // ---- SDA open-drain driver ------------------------------------
  logic sda_drv;          // 1 = pull SDA low (ACK/data0), 0 = release
  assign s.sda = sda_drv ? 1'b0 : 1'bz;

  // ---- bus sampling --------------------------------------------
  logic scl_val, sda_val;
  assign scl_val = s.scl;
  assign sda_val = s.sda;

  // ---- edge/condition detection ---------------------------------
  logic scl_prev, sda_prev;
  logic start, stop;

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      scl_prev <= 1;
      sda_prev <= 1;
      start    <= 0;
      stop     <= 0;
    end else begin
      scl_prev <= scl_val;
      sda_prev <= sda_val;
      start    <= (scl_val &&  sda_prev && !sda_val);  // SDA↓ while SCL↑
      stop     <= (scl_val && !sda_prev &&  sda_val);  // SDA↑ while SCL↑
    end
  end

  // ---- FSM ------------------------------------------------------
  typedef enum {
    IDLE,                              // wait for START
    GET_BYTE,                          // capture 8 data bits on SCL rising edges
    DO_ACK,                            // drive SDA low for ACK
    SEND_BYTE                          // drive data bits on SCL rising edges
  } state_t;
  state_t state = IDLE;

  logic [3:0]  bit_cnt;
  logic [7:0]  shift;                  // receive/transmit shift register
  logic [7:0]  shadow = 8'hA5;         // internal register (pre-loaded)
  logic        addr_ok;                // address matched this transaction
  logic        rw;                     // 0=write, 1=read

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      state    <= IDLE;
      sda_drv  <= 0;
      shadow   <= 8'hA5;
      bit_cnt  <= 0;
      addr_ok  <= 0;
      rw       <= 0;
    end else begin
      case (state)

        // ---- IDLE: wait for START condition --------------------
        IDLE: begin
          sda_drv <= 0;
          if (start) begin
            bit_cnt <= 0;
            shift   <= 0;
            addr_ok <= 0;
            state   <= GET_BYTE;
          end
        end

        // ---- GET_BYTE: capture 8 bits on SCL rising edges -----
        // After 8 bits, the 9th SCL edge completes the address+ACK
        // cycle. Then we check if the address matches.
        GET_BYTE: begin
          if (scl_val && !scl_prev) begin     // SCL rising edge
            if (bit_cnt < 8) begin
              shift <= {shift[6:0], sda_val};  // capture bit
              bit_cnt <= bit_cnt + 1;
            end else begin
              // 9th SCL edge: address+ACK phase done
              if (!addr_ok) begin
                // First byte: check device address
                addr_ok <= (shift[7:1] == 7'h50);
                rw      <= shift[0];
              end else if (!rw) begin
                // Data byte received (write)
                shadow <= shift;
              end
              if (addr_ok || shift[7:1] == 7'h50) begin
                bit_cnt <= 0;
                state   <= DO_ACK;
              end else begin
                state <= IDLE;                // not our address
              end
              bit_cnt <= 0;
            end
          end
          if (stop) state <= IDLE;
        end

        // ---- DO_ACK: pull SDA low, monitor SCL to release -----
        DO_ACK: begin
          if (scl_val && !scl_prev) begin     // SCL rising edge
            sda_drv <= 1;                     // drive ACK
          end
          if (!scl_val && scl_prev) begin     // SCL falling edge
            sda_drv <= 0;                     // release SDA
            if (!rw) begin
              state <= GET_BYTE;              // write: receive more
            end else begin
              shift   <= shadow;              // read: load data
              bit_cnt <= 0;
              state   <= SEND_BYTE;
            end
          end
          if (stop) begin
            sda_drv <= 0;
            state <= IDLE;
          end
        end

        // ---- SEND_BYTE: drive data on SCL, 1 bit per cycle ----
        SEND_BYTE: begin
          if (!scl_val && scl_prev) begin     // SCL falling edge
            // Drive next bit (setup before SCL rising)
            sda_drv <= ~shift[7];             // pull low if bit=0
            shift   <= {shift[6:0], 1'b0};
            bit_cnt <= bit_cnt + 1;
          end
          if (stop || (scl_val && !scl_prev && bit_cnt > 8)) begin
            sda_drv <= 0;
            state <= IDLE;
          end
        end

      endcase
    end
  end

endmodule
