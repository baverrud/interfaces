// =====================================================================
// top.sv - UART demo: transmitter -> receiver
// =====================================================================
// Clean top level: instantiates the UART interface, a transmitter
// (TX sequencer + RX capture), and a receiver (RX capture + TX echo).
// =====================================================================
module top #(
  parameter int BAUD_DIV = 8          // system clocks per UART bit
) (
  input  logic clk,                   // system clock
  input  logic rstn,                  // active-low reset
  output logic done                   // high when TX+RX cycle completes
);

  // ---- UART interface instance -----------------------------------
  uart_if #() bus ();

  // ---- transmitter: sends 0xA5, then listens for echo ------------
  uart_tx #(.BAUD_DIV(BAUD_DIV)) u_tx (
    .clk, .rstn,
    .m    (bus.master),
    .done (done)
  );

  // ---- receiver: captures byte, echoes it back -------------------
  uart_rx #(.BAUD_DIV(BAUD_DIV)) u_rx (
    .clk, .rstn,
    .s    (bus.slave)
  );
endmodule
