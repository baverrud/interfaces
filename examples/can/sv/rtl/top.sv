// =====================================================================
// top.sv - CAN demo: controller -> transceiver
// =====================================================================
// Clean top level: instantiates the CAN interface, a controller
// (frame sequencer), and a transceiver (physical-layer loopback).
// =====================================================================
module top (
  input  logic clk,                   // system clock
  input  logic rstn,                  // active-low reset
  output logic done                   // high when test completes
);

  // ---- CAN interface instance ------------------------------------
  can_if bus ();

  // ---- controller: drives TX with frame simulation ---------------
  can_master u_mast (
    .clk, .rstn,
    .m    (bus.controller),
    .done (done)
  );

  // ---- transceiver: echoes TX to RX -----------------------------
  can_slave u_slav (
    .clk, .rstn,
    .s    (bus.transceiver)
  );
endmodule
