`timescale 1ns/1ps
// =====================================================================
// jtag_if.sv - JTAG (IEEE 1149.1) interface
// =====================================================================
// Parameters:
//   HAS_TRST = 0 — include TRST (test reset) signal
// =====================================================================
interface jtag_if #(
  parameter bit HAS_TRST = 0
);
  logic tck;                   // test clock
  logic tms;                   // test mode select
  logic tdi;                   // test data in
  logic tdo;                   // test data out
  logic trst;                  // test reset (optional, active low)

  modport tap (
    input  tck, tms, tdi, trst,
    output tdo
  );
endinterface
