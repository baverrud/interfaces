`timescale 1ns/1ps
// =====================================================================
// axilite_if.sv - parameterized AXI4-Lite interface
// =====================================================================
// AXI4-Lite: single-beat writes/reads only, no burst signals.  All
// transactions are 1 beat.  AWADDR/WDATA/WSTRB/BREADY/BVALID/BRESP for
// writes; ARADDR/RDATA/RVALID/RREADY/RRESP for reads.
// =====================================================================
interface axilite_if #(
    parameter int DATA_W  = 32,
    parameter int ADDR_W  = 32,
    parameter int USER_W  = 0
) (
    input logic aclk,
    input logic aresetn
);
    localparam int U_W   = (USER_W > 0) ? USER_W : 1;
    localparam int STRB_W = DATA_W / 8;

    // Write Address
    logic [ADDR_W-1:0]   awaddr;
    logic [2:0]          awprot;
    logic [U_W-1:0]      awuser;
    logic                awvalid;
    logic                awready;

    // Write Data
    logic [DATA_W-1:0]   wdata;
    logic [STRB_W-1:0]   wstrb;
    logic [U_W-1:0]      wuser;
    logic                wvalid;
    logic                wready;

    // Write Response
    logic [1:0]          bresp;
    logic [U_W-1:0]      buser;
    logic                bvalid;
    logic                bready;

    // Read Address
    logic [ADDR_W-1:0]   araddr;
    logic [2:0]          arprot;
    logic [U_W-1:0]      aruser;
    logic                arvalid;
    logic                arready;

    // Read Data
    logic [DATA_W-1:0]   rdata;
    logic [1:0]          rresp;
    logic [U_W-1:0]      ruser;
    logic                rvalid;
    logic                rready;

    modport master (
        input  aclk, aresetn,
        output awaddr, awprot, awuser, awvalid, input  awready,
        output wdata, wstrb, wuser, wvalid, input  wready,
        input  bresp, buser, bvalid, output bready,
        output araddr, arprot, aruser, arvalid, input  arready,
        input  rdata, rresp, ruser, rvalid, output rready
    );

    modport slave (
        input  aclk, aresetn,
        input  awaddr, awprot, awuser, awvalid, output awready,
        input  wdata, wstrb, wuser, wvalid, output wready,
        output bresp, buser, bvalid, input  bready,
        input  araddr, arprot, aruser, arvalid, output arready,
        output rdata, rresp, ruser, rvalid, input  rready
    );
endinterface
