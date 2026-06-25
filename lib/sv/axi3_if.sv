`timescale 1ns/1ps
// =====================================================================
// axi3_if.sv - parameterized AXI3 interface (write interleaving)
// =====================================================================
// AXI3 differs from AXI4: burst length up to 16, write interleaving
// supported (WID signal).  Otherwise identical to AXI4.
// =====================================================================
interface axi3_if #(
  parameter int DATA_W  = 32,
  parameter int ADDR_W  = 32,
  parameter int ID_W    = 4,
  parameter int USER_W  = 0
) (
  input logic aclk,
  input logic aresetn
);
  localparam int U_W = (USER_W > 0) ? USER_W : 1;

  // Write Address Channel
  logic [ID_W-1:0]     awid;
  logic [ADDR_W-1:0]   awaddr;
  logic [3:0]          awlen;      // AXI3: 4-bit burst length (1-16)
  logic [2:0]          awsize;
  logic [1:0]          awburst;
  logic [1:0]          awlock;     // AXI3: 2-bit lock
  logic [3:0]          awcache;
  logic [2:0]          awprot;
  logic [3:0]          awqos;
  logic [U_W-1:0]      awuser;
  logic                awvalid, awready;

  // Write Data Channel (AXI3 includes WID for interleaving)
  logic [ID_W-1:0]     wid;
  logic [DATA_W-1:0]   wdata;
  logic [DATA_W/8-1:0] wstrb;
  logic                wlast;
  logic [U_W-1:0]      wuser;
  logic                wvalid, wready;

  // Write Response Channel
  logic [ID_W-1:0]     bid;
  logic [1:0]          bresp;
  logic [U_W-1:0]      buser;
  logic                bvalid, bready;

  // Read Address Channel
  logic [ID_W-1:0]     arid;
  logic [ADDR_W-1:0]   araddr;
  logic [3:0]          arlen;
  logic [2:0]          arsize;
  logic [1:0]          arburst;
  logic [1:0]          arlock;
  logic [3:0]          arcache;
  logic [2:0]          arprot;
  logic [3:0]          arqos;
  logic [U_W-1:0]      aruser;
  logic                arvalid, arready;

  // Read Data Channel
  logic [ID_W-1:0]     rid;
  logic [DATA_W-1:0]   rdata;
  logic [1:0]          rresp;
  logic                rlast;
  logic [U_W-1:0]      ruser;
  logic                rvalid, rready;

  modport master (
    input  aclk, aresetn,
    output awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot,
         awqos, awuser, awvalid, input awready,
    output wid, wdata, wstrb, wlast, wuser, wvalid, input wready,
    input  bid, bresp, buser, bvalid, output bready,
    output arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot,
         arqos, aruser, arvalid, input arready,
    input  rid, rdata, rresp, rlast, ruser, rvalid, output rready
  );

  modport slave (
    input  aclk, aresetn,
    input  awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot,
         awqos, awuser, awvalid, output awready,
    input  wid, wdata, wstrb, wlast, wuser, wvalid, output wready,
    output bid, bresp, buser, bvalid, input bready,
    input  arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot,
         arqos, aruser, arvalid, output arready,
    output rid, rdata, rresp, rlast, ruser, rvalid, input rready
  );
endinterface
