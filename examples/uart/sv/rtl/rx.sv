// =====================================================================
// uart_rx.sv - UART receiver (RX)
// =====================================================================
// Waits for a start bit on TX (the transmitter's TX line), samples 8
// data bits at the baud rate, then re-transmits the received byte
// back on RX.  This implements a full UART frame echo.
// =====================================================================
module uart_rx #(
  parameter int BAUD_DIV = 8          // system clocks per bit period
) (
  input  logic       clk,             // system clock
  input  logic       rstn,            // active-low reset
  uart_if.slave      s                // UART slave modport (tx=input, rx=output)
);

  // ---------------------------------------------------------------
  //  State machine
  // ---------------------------------------------------------------
  typedef enum {
    IDLE,                              // wait for start bit on s.tx
    RX_START,                          // wait for start bit to complete
    RX_DATA,                           // sample 8 data bits at midpoint
    RX_STOP,                           // wait for stop bit
    TX_START,                          // drive start bit on s.rx
    TX_DATA,                           // shift out received byte
    TX_STOP                            // drive stop bit, return to IDLE
  } state_t;
  state_t state = IDLE;

  logic [3:0]  bit_idx;                // bit index (0..7)
  logic [7:0]  rx_byte;                // received byte (to echo back)
  logic [7:0]  tx_shift;               // transmit shift register
  logic [31:0] baud_cnt;               // baud rate counter
  logic        rx_prev;                // previous s.tx for edge detect

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      state    <= IDLE;
      s.rx     <= 1;                   // idle: RX high
      baud_cnt <= 0;
      bit_idx  <= 0;
      rx_prev  <= 1;
    end else case (state)

      // ---- IDLE: wait for falling edge on s.tx (transmitter's TX)
      IDLE: begin
        rx_prev <= s.tx;               // s.tx = transmitter's TX line
        if (rx_prev && !s.tx) begin     // falling edge = start bit
          baud_cnt <= 0;
          bit_idx  <= 0;
          rx_byte  <= 0;
          state    <= RX_START;
        end
      end

      // ---- RX_START: wait for start bit to finish ---------------
      RX_START: begin
        if (baud_cnt == BAUD_DIV - 1) begin
          baud_cnt <= 0;
          state    <= RX_DATA;
        end else baud_cnt <= baud_cnt + 1;
      end

      // ---- RX_DATA: sample 8 data bits at midpoint --------------
      RX_DATA: begin
        if (baud_cnt == BAUD_DIV / 2) begin
          // Midpoint sample: shift in received bit (LSB first)
          // After 8 samples: rx_byte = {D7,D6,D5,D4,D3,D2,D1,D0}
          rx_byte <= {s.tx, rx_byte[7:1]};
        end
        if (baud_cnt == BAUD_DIV - 1) begin
          baud_cnt <= 0;
          if (bit_idx == 7) begin
            bit_idx <= 0;
            state   <= RX_STOP;
          end else bit_idx <= bit_idx + 1;
        end else baud_cnt <= baud_cnt + 1;
      end

      // ---- RX_STOP: wait for stop bit, prepare to echo ----------
      RX_STOP: begin
        if (baud_cnt == BAUD_DIV - 1) begin
          tx_shift <= rx_byte;          // load echoed byte
          bit_idx  <= 0;
          baud_cnt <= 0;
          state    <= TX_START;
        end else baud_cnt <= baud_cnt + 1;
      end

      // ---- TX_START: drive start bit on s.rx --------------------
      TX_START: begin
        s.rx <= 0;                      // start bit
        if (baud_cnt == BAUD_DIV - 1) begin
          baud_cnt <= 0;
          state    <= TX_DATA;
        end else baud_cnt <= baud_cnt + 1;
      end

      // ---- TX_DATA: shift out received byte, LSB first ----------
      TX_DATA: begin
        s.rx <= tx_shift[0];            // LSB first
        if (baud_cnt == BAUD_DIV - 1) begin
          baud_cnt <= 0;
          tx_shift <= {1'b0, tx_shift[7:1]};
          if (bit_idx == 7) state <= TX_STOP;
          else              bit_idx <= bit_idx + 1;
        end else baud_cnt <= baud_cnt + 1;
      end

      // ---- TX_STOP: drive stop bit, return to IDLE --------------
      TX_STOP: begin
        s.rx <= 1;                      // stop bit
        if (baud_cnt == BAUD_DIV - 1) begin
          state <= IDLE;                // ready for next transaction
        end else baud_cnt <= baud_cnt + 1;
      end

    endcase
  end
endmodule
