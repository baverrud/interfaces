`timescale 1ns/1ps
// =====================================================================
// uart_if.sv - UART interface with TX/RX and optional flow control
// =====================================================================
// Parameters:
//   HAS_RTS_CTS = 0 — basic 2-wire (TX/RX only)
//   HAS_RTS_CTS = 1 — add RTS/CTS hardware flow control
// =====================================================================
interface uart_if #(
  parameter bit HAS_RTS_CTS = 0
);
  // Data
  logic tx;     // transmit (master -> peer)
  logic rx;     // receive  (peer -> master)

  // Flow control (optional)
  logic rts;    // ready-to-send (master -> peer, asserted when ok to receive)
  logic cts;    // clear-to-send (peer -> master, asserted when peer ok to receive)

  modport master (
    output tx,
    input  rx,
    output rts,
    input  cts
  );
  modport slave (
    input  tx,
    output rx,
    input  rts,
    output cts
  );
endinterface
