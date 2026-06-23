`timescale 1ns/1ps
// =====================================================================
// qspi_if.sv - QSPI interface with configurable IO width + CS
// =====================================================================
// Parameters:
//   CS_COUNT   = 1 — number of chip-select lines
//   DATA_LINES = 4 — data lines (1=single, 2=dual, 4=quad, 8=octal)
// =====================================================================
interface qspi_if #(
    parameter int CS_COUNT   = 1,
    parameter int DATA_LINES = 4
);
    logic                     sclk;          // clock (master -> slave)
    logic [DATA_LINES-1:0]    io_o;          // data output (master -> slave)
    logic [DATA_LINES-1:0]    io_i;          // data input  (slave -> master)
    logic [DATA_LINES-1:0]    io_oe;         // 1 = master drives, 0 = hi-z
    logic [CS_COUNT-1:0]      cs;            // chip-select (active low)

    modport master (
        output sclk, io_o, io_oe, cs,
        input  io_i
    );
    modport slave (
        input  sclk, io_o, io_oe, cs,
        output io_i
    );
endinterface
