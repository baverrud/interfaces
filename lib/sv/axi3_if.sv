`timescale 1ns/1ps
// =====================================================================
// axi3_if.sv - parameterized AXI3 interface (write interleaving)
// =====================================================================
// AXI3 differs from AXI4: burst length up to 16, write interleaving
// supported (WID signal), 2-bit lock.  Otherwise identical to AXI4.
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

  // ==================================================================
  //  Write Address Channel (master -> slave)
  // ==================================================================
  logic [ID_W-1:0]     awid;         // transaction ID (tags write tx for out-of-order)
  logic [ADDR_W-1:0]   awaddr;       // address of first transfer in burst
  logic [3:0]          awlen;        // burst length: beats = awlen + 1 (0 = 1 beat, max 15 = 16)
  logic [2:0]          awsize;       // bytes per beat: 2^awsize (e.g. 010 = 4 bytes)
  logic [1:0]          awburst;      // burst type: 00=FIXED, 01=INCR, 10=WRAP
  logic [1:0]          awlock;       // locking: 00=normal, 01=exclusive, 10=locked (AXI3: 2-bit)
  logic [3:0]          awcache;      // memory type: bufferable/cacheable/modifiable/alloc hints
  logic [2:0]          awprot;       // protection: privilege, security, instruction vs data
  logic [3:0]          awqos;        // quality-of-service (QoS) identifier
  logic [U_W-1:0]      awuser;       // user-defined sideband (per-transaction)
  logic                awvalid;      // master: address+control valid
  logic                awready;      // slave: address accepted

  // ==================================================================
  //  Write Data Channel (AXI3: wid present for write interleaving)
  // ==================================================================
  logic [ID_W-1:0]     wid;          // write interleaving ID (AXI3 only — absent in AXI4)
  logic [DATA_W-1:0]   wdata;        // write data (one beat)
  logic [DATA_W/8-1:0] wstrb;        // byte enables: wstrb[i] qualifies wdata[i*8 +: 8]
  logic                wlast;        // final beat indicator for burst
  logic [U_W-1:0]      wuser;        // user-defined sideband (per-beat)
  logic                wvalid;       // master: data+strobe valid
  logic                wready;       // slave: data accepted

  // ==================================================================
  //  Write Response Channel (slave -> master)
  // ==================================================================
  logic [ID_W-1:0]     bid;          // transaction ID (echoed from awid)
  logic [1:0]          bresp;        // response: 00=OKAY, 01=EXOKAY, 10=SLVERR, 11=DECERR
  logic [U_W-1:0]      buser;        // user-defined sideband (per-response)
  logic                bvalid;       // slave: response valid
  logic                bready;       // master: response accepted

  // ==================================================================
  //  Read Address Channel (master -> slave)
  // ==================================================================
  logic [ID_W-1:0]     arid;         // transaction ID (tags read tx for out-of-order)
  logic [ADDR_W-1:0]   araddr;       // address of first transfer in burst
  logic [3:0]          arlen;        // burst length: beats = arlen + 1 (0 = 1 beat, max 15 = 16)
  logic [2:0]          arsize;       // bytes per beat: 2^arsize (e.g. 010 = 4 bytes)
  logic [1:0]          arburst;      // burst type: 00=FIXED, 01=INCR, 10=WRAP
  logic [1:0]          arlock;       // locking: 00=normal, 01=exclusive, 10=locked (AXI3: 2-bit)
  logic [3:0]          arcache;      // memory type: bufferable/cacheable/modifiable/alloc hints
  logic [2:0]          arprot;       // protection: privilege, security, instruction vs data
  logic [3:0]          arqos;        // quality-of-service (QoS) identifier
  logic [U_W-1:0]      aruser;       // user-defined sideband (per-transaction)
  logic                arvalid;      // master: address+control valid
  logic                arready;      // slave: address accepted

  // ==================================================================
  //  Read Data Channel (slave -> master)
  // ==================================================================
  logic [ID_W-1:0]     rid;          // transaction ID (echoed from arid)
  logic [DATA_W-1:0]   rdata;        // read data (one beat)
  logic [1:0]          rresp;        // response: 00=OKAY, 01=EXOKAY, 10=SLVERR, 11=DECERR
  logic                rlast;        // final beat indicator for burst
  logic [U_W-1:0]      ruser;        // user-defined sideband (per-beat)
  logic                rvalid;       // slave: data+response valid
  logic                rready;       // master: data accepted

  // ==================================================================
  //  Modports
  // ==================================================================

  // ------------------------------------------------------------------
  //  master  — full-channel Manager (drives all Tx, receives all Rx)
  // ------------------------------------------------------------------
  // Use this modport for a module that drives both write and read
  // transactions (e.g. a CPU, DMA engine, or test sequencer).
  // ------------------------------------------------------------------
  modport master (
    input  aclk, aresetn,
    // write address (Tx)
    output awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot,
    output awqos, awuser, awvalid, input awready,
    // write data (Tx) — AXI3: wid present for write interleaving
    output wid, wdata, wstrb, wlast, wuser, wvalid, input wready,
    // write response (Rx)
    input  bid, bresp, buser, bvalid, output bready,
    // read address (Tx)
    output arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot,
    output arqos, aruser, arvalid, input arready,
    // read data (Rx)
    input  rid, rdata, rresp, rlast, ruser, rvalid, output rready
  );

  // ------------------------------------------------------------------
  //  slave  — full-channel Subordinate (receives all Tx, drives all Rx)
  // ------------------------------------------------------------------
  // Use this modport for a module that responds to both write and read
  // transactions (e.g. a memory slave, peripheral register file).
  // ------------------------------------------------------------------
  modport slave (
    input  aclk, aresetn,
    // write address (Rx)
    input  awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot,
    input  awqos, awuser, awvalid, output awready,
    // write data (Rx) — AXI3: wid present
    input  wid, wdata, wstrb, wlast, wuser, wvalid, output wready,
    // write response (Tx)
    output bid, bresp, buser, bvalid, input bready,
    // read address (Rx)
    input  arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot,
    input  arqos, aruser, arvalid, output arready,
    // read data (Tx)
    output rid, rdata, rresp, rlast, ruser, rvalid, input rready
  );

  // ------------------------------------------------------------------
  //  aw_src  — Write Address channel source (Tx sub-modport)
  // ------------------------------------------------------------------
  // Use for a module that drives the write address channel
  // (e.g. a write-address generator).  Pairs with aw_sink on the
  // slave side to form a routed write-address path.
  // ------------------------------------------------------------------
  modport aw_src (
    input  aclk, aresetn,
    output awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot,
    output awqos, awuser, awvalid,
    input  awready
  );

  // ------------------------------------------------------------------
  //  aw_sink — Write Address channel sink (Rx sub-modport)
  // ------------------------------------------------------------------
  // Use for a module that receives write address requests
  // (e.g. an address decoder, a write arbiter).  Pairs with aw_src.
  // All signals are inputs except awready (driven by sink).
  // ------------------------------------------------------------------
  modport aw_sink (
    input  aclk, aresetn,
    input  awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot,
    input  awqos, awuser, awvalid,
    output awready
  );

  // ------------------------------------------------------------------
  //  w_src   — Write Data channel source (Tx sub-modport)
  // ------------------------------------------------------------------
  // Use for a module that drives write data beats
  // (e.g. a data mover).  Pairs with w_sink on the slave side.
  // AXI3: wid is present for write interleaving.
  // ------------------------------------------------------------------
  modport w_src (
    input  aclk, aresetn,
    output wid, wdata, wstrb, wlast, wuser, wvalid,
    input  wready
  );

  // ------------------------------------------------------------------
  //  w_sink  — Write Data channel sink (Rx sub-modport)
  // ------------------------------------------------------------------
  // Use for a module that receives write data beats
  // (e.g. a data buffer, a write-data pipeline stage).
  // All signals are inputs except wready (driven by sink).
  // ------------------------------------------------------------------
  modport w_sink (
    input  aclk, aresetn,
    input  wid, wdata, wstrb, wlast, wuser, wvalid,
    output wready
  );

  // ------------------------------------------------------------------
  //  b_src   — Write Response channel source (Tx sub-modport)
  // ------------------------------------------------------------------
  // Use for a module that drives write responses
  // (e.g. a response generator in a slave that only handles writes).
  // Pairs with b_sink on the master side.
  // ------------------------------------------------------------------
  modport b_src (
    input  aclk, aresetn,
    output bid, bresp, buser, bvalid,
    input  bready
  );

  // ------------------------------------------------------------------
  //  b_sink  — Write Response channel sink (Rx sub-modport)
  // ------------------------------------------------------------------
  // Use for a module that receives write responses
  // (e.g. a write-completion handler).  Pairs with b_src.
  // ------------------------------------------------------------------
  modport b_sink (
    input  aclk, aresetn,
    input  bid, bresp, buser, bvalid,
    output bready
  );

  // ------------------------------------------------------------------
  //  ar_src  — Read Address channel source (Tx sub-modport)
  // ------------------------------------------------------------------
  // Use for a module that drives the read address channel
  // (e.g. a read-address generator).  Pairs with ar_sink.
  // ------------------------------------------------------------------
  modport ar_src (
    input  aclk, aresetn,
    output arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot,
    output arqos, aruser, arvalid,
    input  arready
  );

  // ------------------------------------------------------------------
  //  ar_sink — Read Address channel sink (Rx sub-modport)
  // ------------------------------------------------------------------
  // Use for a module that receives read address requests
  // (e.g. a read arbiter).  Pairs with ar_src.
  // All signals are inputs except arready (driven by sink).
  // ------------------------------------------------------------------
  modport ar_sink (
    input  aclk, aresetn,
    input  arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot,
    input  arqos, aruser, arvalid,
    output arready
  );

  // ------------------------------------------------------------------
  //  r_src   — Read Data channel source (Tx sub-modport)
  // ------------------------------------------------------------------
  // Use for a module that drives read data
  // (e.g. a read-data stage in a slave that only handles reads).
  // Pairs with r_sink on the master side.
  // ------------------------------------------------------------------
  modport r_src (
    input  aclk, aresetn,
    output rid, rdata, rresp, rlast, ruser, rvalid,
    input  rready
  );

  // ------------------------------------------------------------------
  //  r_sink  — Read Data channel sink (Rx sub-modport)
  // ------------------------------------------------------------------
  // Use for a module that consumes read data
  // (e.g. a read-completion buffer).  Pairs with r_src.
  // ------------------------------------------------------------------
  modport r_sink (
    input  aclk, aresetn,
    input  rid, rdata, rresp, rlast, ruser, rvalid,
    output rready
  );
endinterface
