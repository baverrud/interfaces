// =====================================================================
// uart_tx.sv - UART transmitter (TX)
// =====================================================================
// Transmits byte 0xA5 via UART (start bit + 8 LSB-first data bits +
// stop bit), then switches to RX mode to capture the receiver's echo.
// Asserts done after receiving a full echo frame.
// =====================================================================
module uart_tx #(
  parameter int BAUD_DIV = 8          // system clocks per bit period
) (
  input  logic       clk,             // system clock
  input  logic       rstn,            // active-low reset
  uart_if.master     m,               // UART master modport (tx=out, rx=in)
  output logic       done             // high when TX+RX cycle completes
);

  // ---------------------------------------------------------------
  //  State machine
  // ---------------------------------------------------------------
  typedef enum {
    IDLE,                              // load test byte
    TX_START,                          // drive start bit (TX = 0)
    TX_DATA,                           // shift out 8 data bits, LSB first
    TX_STOP,                           // drive stop bit (TX = 1)
    RX_WAIT,                           // wait for receiver's start bit on RX
    RX_DATA,                           // sample 8 data bits from RX
    RX_STOP,                           // wait for stop bit on RX
    DONE_S                             // transaction complete
  } state_t;
  state_t state = IDLE;

  logic [3:0]  bit_idx;                // bit index (0..7)
  logic [7:0]  tx_byte;                // byte being transmitted
  logic [7:0]  rx_shift;               // receive shift register
  logic [31:0] baud_cnt;               // baud rate counter
  logic        rx_prev;                // previous RX for edge detection

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      state    <= IDLE;
      m.tx     <= 1;                   // idle: TX high
      done     <= 0;
      baud_cnt <= 0;
      bit_idx  <= 0;
      rx_prev  <= 1;
    end else case (state)

      // ---- IDLE: load test byte, start transmission ---------------
      IDLE: begin
        tx_byte  <= 8'hA5;             // test pattern: 1010_0101
        bit_idx  <= 0;
        baud_cnt <= 0;
        state    <= TX_START;
      end

      // ---- TX_START: drive start bit (0) for one bit period ------
      TX_START: begin
        m.tx <= 0;
        if (baud_cnt == BAUD_DIV - 1) begin
          baud_cnt <= 0;
          bit_idx  <= 0;
          state    <= TX_DATA;
        end else baud_cnt <= baud_cnt + 1;
      end

      // ---- TX_DATA: shift out 8 bits, LSB first ------------------
      TX_DATA: begin
        m.tx <= tx_byte[0];             // drive current LSB
        if (baud_cnt == BAUD_DIV - 1) begin
          baud_cnt <= 0;
          tx_byte  <= {1'b0, tx_byte[7:1]};  // shift right
          if (bit_idx == 7) state <= TX_STOP;
          else              bit_idx <= bit_idx + 1;
        end else baud_cnt <= baud_cnt + 1;
      end

      // ---- TX_STOP: drive stop bit (1) for one bit period --------
      TX_STOP: begin
        m.tx <= 1;
        if (baud_cnt == BAUD_DIV - 1) begin
          baud_cnt <= 0;
          bit_idx  <= 0;
          rx_shift <= 0;
          state    <= RX_WAIT;
        end else baud_cnt <= baud_cnt + 1;
      end

      // ---- RX_WAIT: wait for falling edge on RX (receiver's start)
      RX_WAIT: begin
        rx_prev <= m.rx;
        if (rx_prev && !m.rx) begin     // falling edge = start bit
          baud_cnt <= 0;
          bit_idx  <= 0;
          state    <= RX_DATA;
        end
      end

      // ---- RX_DATA: sample 8 bits at midpoint of each bit -------
      RX_DATA: begin
        if (baud_cnt == BAUD_DIV / 2) begin
          // Midpoint: shift in the received bit (LSB first)
          // After 8 samples: rx_shift = {D7,D6,D5,D4,D3,D2,D1,D0}
          rx_shift <= {m.rx, rx_shift[7:1]};
        end
        if (baud_cnt == BAUD_DIV - 1) begin
          baud_cnt <= 0;
          if (bit_idx == 7) state <= RX_STOP;
          else              bit_idx <= bit_idx + 1;
        end else baud_cnt <= baud_cnt + 1;
      end

      // ---- RX_STOP: verify stop bit (should be 1) ----------------
      RX_STOP: begin
        if (baud_cnt == BAUD_DIV - 1) begin
          state <= DONE_S;
        end else baud_cnt <= baud_cnt + 1;
      end

      // ---- DONE: sequence complete -------------------------------
      DONE_S: begin
        done <= 1;
      end

    endcase
  end
endmodule
