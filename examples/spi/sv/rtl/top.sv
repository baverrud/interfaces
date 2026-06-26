// =====================================================================
// top.sv - SPI demo: register write, then read back
// =====================================================================
// Clean top level: instantiates the SPI interface, a master (register
// write/read sequencer), and a slave (shadow register).
// =====================================================================
module top #(
  parameter logic [7:0] WR_DATA = 8'hA5   // test data
) (
  input  logic clk,                   // system clock
  input  logic rstn,                  // active-low reset
  output logic done                   // high when test passes
);

  // ---- SPI interface instance (1 chip-select line) ---------------
  spi_if #(.CS_COUNT(1)) bus ();

  // ---- master: writes WR_DATA, reads it back, verifies ----------
  spi_master #(.WR_DATA(WR_DATA)) u_mast (
    .clk, .rstn,
    .m    (bus.master),
    .done (done)
  );

  // ---- slave: shadow register (captures MOSI, echoes on MISO) ---
  spi_slave u_slav (
    .clk, .rstn,
    .s    (bus.slave)
  );
endmodule
