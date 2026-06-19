`timescale 1ns/1ps
// =====================================================================
// spi_if.sv - Classic SPI interface (MOSI/MISO)
// =====================================================================
// Parameters:
//   CS_COUNT = 1 — number of chip-select lines
// =====================================================================
interface spi_if #(
    parameter int CS_COUNT = 1
);
    logic                sclk;          // clock (master -> slave)
    logic                mosi;          // master-out, slave-in
    logic                miso;          // master-in,  slave-out
    logic [CS_COUNT-1:0] cs;            // chip-select (active low)

    modport master (
        output sclk, mosi, cs,
        input  miso
    );
    modport slave (
        input  sclk, mosi, cs,
        output miso
    );
endinterface
