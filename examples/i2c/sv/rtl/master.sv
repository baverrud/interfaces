// =====================================================================
// i2c_master.sv - I2C master (write then read test)
// =====================================================================
// Bit-banged I2C master:
//   1. START, send addr 0x50+W, get ACK, send data 0xA5, get ACK
//   2. Repeated START, send addr 0x50+R, get ACK, read byte, NACK
//   3. STOP, verify received byte
//
// SCL/SDA use open-drain drive ('0' = assert, 'Z' = release).
// External pull-ups in the testbench keep lines high when released.
// =====================================================================
module i2c_master #(
  parameter logic [6:0] DEV_ADDR = 7'h50
) (
  input  logic       clk,
  input  logic       rstn,
  i2c_if.master      m,
  output logic       done
);

  // ---- open-drain tristate drivers -----------------------------
  logic scl_drv;          // 1 = pull SCL low, 0 = release
  logic sda_drv;          // 1 = pull SDA low, 0 = release
  assign m.scl = scl_drv ? 1'b0 : 1'bz;
  assign m.sda = sda_drv ? 1'b0 : 1'bz;

  // ---- sampled bus values -------------------------------------
  logic scl_val, sda_val;
  assign scl_val = m.scl;
  assign sda_val = m.sda;

  // ---- FSM ----------------------------------------------------
  typedef enum {
    IDLE, START, SEND_BIT, SEND_HIGH, SEND_LOW,
    GET_ACK_HIGH, GET_ACK_LOW,
    READ_HIGH, READ_LOW,
    SEND_NACK_HIGH, SEND_NACK_LOW,
    STOP1, DONE_S
  } state_t;
  state_t state = IDLE;

  logic [3:0]  bit_cnt;
  logic [7:0]  tx_byte;
  logic [7:0]  rx_byte;
  logic        rw;                     // 0=write, 1=read

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      state   <= IDLE;
      scl_drv <= 0;
      sda_drv <= 0;
      done    <= 0;
      bit_cnt <= 0;
      rw      <= 0;
    end else case (state)

      IDLE: begin
        scl_drv <= 0;                   // release both (bus idle = high)
        sda_drv <= 0;
        rw      <= 0;                   // start with write
        bit_cnt <= 0;
        state   <= START;
      end

      // START: SDA falls while SCL high
      START: begin
        sda_drv <= 1;                   // pull SDA low
        state   <= SEND_BIT;
      end

      // SEND_BIT: drive SDA, release SCL
      SEND_BIT: begin
        tx_byte <= rw ? {DEV_ADDR, 1'b1} : {DEV_ADDR, 1'b0};
        sda_drv <= ~tx_byte[7];         // SDA = 0 if bit=0, release if bit=1
        scl_drv <= 0;                   // release SCL (rises via pull-up)
        state   <= SEND_HIGH;
      end

      // SEND_HIGH: SCL high (slave samples)
      SEND_HIGH: begin
        scl_drv <= 0;                   // keep high
        state   <= SEND_LOW;
      end

      // SEND_LOW: pull SCL low, advance
      SEND_LOW: begin
        scl_drv <= 1;                   // pull SCL low
        tx_byte <= {tx_byte[6:0], 1'b0};
        if (bit_cnt == 7) begin
          bit_cnt <= 0;
          state   <= GET_ACK_HIGH;
        end else begin
          bit_cnt <= bit_cnt + 1;
          state   <= SEND_BIT;
        end
      end

      // GET_ACK: release SDA, pulse SCL, check ACK
      GET_ACK_HIGH: begin
        sda_drv <= 0;                   // release SDA (slave pulls low for ACK)
        scl_drv <= 0;                   // release SCL
        state   <= GET_ACK_LOW;
      end

      GET_ACK_LOW: begin
        scl_drv <= 1;                   // pull SCL low
        if (!sda_val) begin             // ACK received (SDA low)
          if (!rw) begin
            // Write phase: send data byte
            tx_byte <= 8'hA5;
            bit_cnt <= 0;
            state   <= SEND_BIT;
          end else begin
            // Read phase: receive byte
            bit_cnt <= 0;
            rx_byte <= 0;
            state   <= READ_HIGH;
          end
        end else begin
          state <= STOP1;               // NACK: abort
        end
      end

      // READ: sample SDA while SCL high
      READ_HIGH: begin
        scl_drv <= 0;                   // release SCL
        rx_byte <= {rx_byte[6:0], sda_val};
        state   <= READ_LOW;
      end

      READ_LOW: begin
        scl_drv <= 1;                   // pull SCL low
        if (bit_cnt == 7) begin
          state <= SEND_NACK_HIGH;
        end else begin
          bit_cnt <= bit_cnt + 1;
          state   <= READ_HIGH;
        end
      end

      // NACK: master pulls SDA low, pulse SCL
      SEND_NACK_HIGH: begin
        sda_drv <= 1;                   // pull SDA low = NACK
        scl_drv <= 0;
        state   <= SEND_NACK_LOW;
      end

      SEND_NACK_LOW: begin
        scl_drv <= 1;                   // pull SCL low
        state   <= STOP1;
      end

      // STOP: release SDA (rises) while SCL high
      STOP1: begin
        sda_drv <= 0;                   // release SDA (rises via pull-up)
        scl_drv <= 0;                   // release SCL
        done    <= 1;
        state   <= DONE_S;
      end

      DONE_S: ;

    endcase
  end

endmodule
