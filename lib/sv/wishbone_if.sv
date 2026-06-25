`timescale 1ns/1ps
// =====================================================================
// wishbone_if.sv - Wishbone B4 interface (classic mode)
// =====================================================================
// Parameters:
//   DATA_W = 32   — data bus width
//   ADDR_W = 32   — address bus width
// =====================================================================
interface wishbone_if #(
  parameter int DATA_W = 32,
  parameter int ADDR_W = 32
);
  logic [ADDR_W-1:0]        adr;
  logic [DATA_W-1:0]        dat_o;     // master -> slave
  logic [DATA_W-1:0]        dat_i;     // slave -> master
  logic                     we;        // 1 = write
  logic [DATA_W/8-1:0]      sel;       // byte select
  logic                     stb;       // strobe
  logic                     ack;       // acknowledge
  logic                     cyc;       // cycle
  logic                     err;       // error (optional but included)

  modport master (
    output adr, dat_o, we, sel, stb, cyc,
    input  dat_i, ack, err
  );
  modport slave (
    input  adr, dat_o, we, sel, stb, cyc,
    output dat_i, ack, err
  );
endinterface
