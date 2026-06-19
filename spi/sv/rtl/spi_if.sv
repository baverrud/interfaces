`timescale 1ns/1ps
// =====================================================================
// spi_if.sv - SPI / QSPI interface with configurable data lines + CS
// =====================================================================
// Parameters:
//   CS_COUNT    = 1  — number of chip-select lines
//   DATA_LINES  = 1  — 1=classic SPI, 2=dual, 4=quad
// =====================================================================
interface spi_if #(
    parameter int CS_COUNT   = 1,
    parameter int DATA_LINES = 1
);
    logic                     sclk;          // clock (master -> slave)
    logic [DATA_LINES-1:0]    io_o;          // data output (master -> slave)
    logic [DATA_LINES-1:0]    io_i;          // data input  (slave -> master)
    logic [DATA_LINES-1:0]    io_oe;         // 1 = master drives, 0 = hi-z
    logic [CS_COUNT-1:0]      cs;            // chip-select (active low)

    // Classic SPI aliases (DATA_LINES=1)
    wire mosi = io_o[0];
    wire miso = io_i[0];

    modport master (
        output sclk, io_o, io_oe, cs,
        input  io_i
    );
    modport slave (
        input  sclk, io_o, io_oe, cs,
        output io_i
    );
endinterface
