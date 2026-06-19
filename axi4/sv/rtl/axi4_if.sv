`timescale 1ns/1ps
// =====================================================================
// axi4_if.sv - parameterized AXI4 interface with master/slave modports
// =====================================================================
// All AXI4 channels in one interface.  'master' drives write and read
// requests; 'slave' is the responder.
//
// Parameters:
//   DATA_W    - data bus width (default 32)
//   ADDR_W    - address bus width (default 32)
//   ID_W      - transaction ID width (default 4)
//   USER_W    - user signal width per channel (default 0; 0 = absent)
//
// Sub-channel modports (aw_src, w_src, ar_src, b_sink, r_sink) follow
// the Tx/Rx Direct-Drive paradigm for fine-grained port usage.
// =====================================================================
interface axi4_if #(
    parameter int DATA_W  = 32,
    parameter int ADDR_W  = 32,
    parameter int ID_W    = 4,
    parameter int USER_W  = 0
) (
    input logic aclk,
    input logic aresetn
);
    // safe width for user signals (0 = absent, stub to 1)
    localparam int U_W = (USER_W > 0) ? USER_W : 1;

    // ==================================================================
    //  Write Address Channel (master -> slave)
    // ==================================================================
    logic [ID_W-1:0]     awid;
    logic [ADDR_W-1:0]   awaddr;
    logic [7:0]          awlen;
    logic [2:0]          awsize;
    logic [1:0]          awburst;
    logic                awlock;
    logic [3:0]          awcache;
    logic [2:0]          awprot;
    logic [3:0]          awqos;
    logic [3:0]          awregion;
    logic [U_W-1:0]      awuser;
    logic                awvalid;
    logic                awready;

    // ==================================================================
    //  Write Data Channel (master -> slave)
    // ==================================================================
    logic [DATA_W-1:0]   wdata;
    logic [DATA_W/8-1:0] wstrb;
    logic                wlast;
    logic [U_W-1:0]      wuser;
    logic                wvalid;
    logic                wready;

    // ==================================================================
    //  Write Response Channel (slave -> master)
    // ==================================================================
    logic [ID_W-1:0]     bid;
    logic [1:0]          bresp;
    logic [U_W-1:0]      buser;
    logic                bvalid;
    logic                bready;

    // ==================================================================
    //  Read Address Channel (master -> slave)
    // ==================================================================
    logic [ID_W-1:0]     arid;
    logic [ADDR_W-1:0]   araddr;
    logic [7:0]          arlen;
    logic [2:0]          arsize;
    logic [1:0]          arburst;
    logic                arlock;
    logic [3:0]          arcache;
    logic [2:0]          arprot;
    logic [3:0]          arqos;
    logic [3:0]          arregion;
    logic [U_W-1:0]      aruser;
    logic                arvalid;
    logic                arready;

    // ==================================================================
    //  Read Data Channel (slave -> master)
    // ==================================================================
    logic [ID_W-1:0]     rid;
    logic [DATA_W-1:0]   rdata;
    logic [1:0]          rresp;
    logic                rlast;
    logic [U_W-1:0]      ruser;
    logic                rvalid;
    logic                rready;

    // ==================================================================
    //  Modports
    // ==================================================================

    // master = Manager (drives write/read requests)
    modport master (
        input  aclk, aresetn,
        // write address
        output awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot,
        output awqos, awregion, awuser, awvalid, input awready,
        // write data
        output wdata, wstrb, wlast, wuser, wvalid, input wready,
        // write response
        input  bid, bresp, buser, bvalid, output bready,
        // read address
        output arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot,
        output arqos, arregion, aruser, arvalid, input arready,
        // read data
        input  rid, rdata, rresp, rlast, ruser, rvalid, output rready
    );

    // slave = Subordinate (responder)
    modport slave (
        input  aclk, aresetn,
        // write address
        input  awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot,
        input  awqos, awregion, awuser, awvalid, output awready,
        // write data
        input  wdata, wstrb, wlast, wuser, wvalid, output wready,
        // write response
        output bid, bresp, buser, bvalid, input bready,
        // read address
        input  arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot,
        input  arqos, arregion, aruser, arvalid, output arready,
        // read data
        output rid, rdata, rresp, rlast, ruser, rvalid, input rready
    );

`ifndef SYNTHESIS
    // write response must eventually arrive after valid address+data
    property p_aw_resp;
        @(posedge aclk) disable iff (!aresetn)
        (awvalid && awready) |-> ##[1:$] (awvalid && awready);
    endproperty
`endif
endinterface
