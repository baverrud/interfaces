// =====================================================================
// top.sv - QSPI demo: register write, then read back
// =====================================================================
// Clean top level: instantiates the QSPI interface, a master
// (register write/read sequencer), and a slave (shadow register).
// =====================================================================
module top #(
  parameter logic [7:0] WR_DATA = 8'hA5   // test data
) (
  input  logic clk,                   // system clock
  input  logic rstn,                  // active-low reset
  output logic done                   // high when test passes
);

  // ---- QSPI interface instance (1 CS, 4 data lines) -------------
  qspi_if #(.CS_COUNT(1), .DATA_LINES(4)) bus ();

  // ---- master: writes WR_DATA (2 nibbles), reads it back --------
  qspi_master #(.WR_DATA(WR_DATA)) u_mast (
    .clk, .rstn,
    .m    (bus.master),
    .done (done)
  );

  // ---- slave: shadow register (captures io_o, echoes on io_i) ---
  qspi_slave u_slav (
    .clk, .rstn,
    .s    (bus.slave)
  );
endmodule
