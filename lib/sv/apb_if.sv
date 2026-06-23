`timescale 1ns/1ps
// =====================================================================
// apb_if.sv - AMBA APB4 interface (parameterized address/data widths)
// =====================================================================
// Parameters:
//   DATA_W = 32  — data bus width
//   ADDR_W = 32  — address bus width
//   HAS_PPROT = 0 — protection signals
//   HAS_PSTRB = 0 — byte strobes (APB4)
// =====================================================================
interface apb_if #(
    parameter int DATA_W    = 32,
    parameter int ADDR_W    = 32,
    parameter bit HAS_PPROT = 0,
    parameter bit HAS_PSTRB = 0
);
    logic [ADDR_W-1:0]   paddr;
    logic [DATA_W-1:0]   pwdata;
    logic [DATA_W-1:0]   prdata;
    logic                pwrite;
    logic                psel;
    logic                penable;
    logic                pready;
    logic                pslverr;
    logic [2:0]          pprot;         // optional
    logic [DATA_W/8-1:0] pstrb;         // optional (APB4)

    modport master (
        output paddr, pwdata, pwrite, psel, penable, pprot, pstrb,
        input  prdata, pready, pslverr
    );
    modport slave (
        input  paddr, pwdata, pwrite, psel, penable, pprot, pstrb,
        output prdata, pready, pslverr
    );
endinterface
