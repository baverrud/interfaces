`timescale 1ns/1ps
// =====================================================================
// sbi_if.sv - UVVM Simple Bus Interface
// =====================================================================
// Lightweight register-access protocol.  Can be synthesized directly
// (e.g., a simple register file) or bridged to AXI4-Lite / Wishbone /
// APB via a bus functional model for UVVM-style verification.
//
// Parameters:
//   ADDR_W = 8   — address width (register count)
//   DATA_W = 32  — data width
// =====================================================================
interface sbi_if #(
  parameter int ADDR_W = 8,
  parameter int DATA_W = 32
);
  logic                  cs;       // chip select
  logic [ADDR_W-1:0]     addr;     // register address
  logic                  wr;       // write strobe
  logic                  rd;       // read strobe
  logic [DATA_W-1:0]     wdata;    // write data
  logic [DATA_W-1:0]     rdata;    // read data
  logic                  ready;    // ready / wait

  modport initiator (
    output cs, addr, wr, rd, wdata,
    input  rdata, ready
  );
  modport target (
    input  cs, addr, wr, rd, wdata,
    output rdata, ready
  );
endinterface
