`timescale 1ns/1ps
// =====================================================================
// axilite_if.sv - parameterized AXI4-Lite interface with sub-channel
//                 modports
// =====================================================================
// AXI4-Lite: single-beat writes/reads only, no burst signals.  All
// transactions are 1 beat.  AWADDR/WDATA/WSTRB/BREADY/BVALID/BRESP for
// writes; ARADDR/RDATA/RVALID/RREADY/RRESP for reads.
//
// Modport hierarchy:
//   master / slave          — all 5 channels together (traditional)
//   aw_src / aw_sink        — Write Address sub-channel
//   w_src  / w_sink         — Write Data sub-channel
//   b_src  / b_sink         — Write Response sub-channel
//   ar_src / ar_sink        — Read Address sub-channel
//   r_src  / r_sink         — Read Data sub-channel
//
// Naming convention: _src = signal source (Tx), _sink = signal sink (Rx).
// =====================================================================
interface axilite_if #(
  parameter int DATA_W  = 32,
  parameter int ADDR_W  = 32,
  parameter int USER_W  = 0
) (
  input logic aclk,
  input logic aresetn
);
  localparam int U_W    = (USER_W > 0) ? USER_W : 1;
  localparam int STRB_W = DATA_W / 8;

  // ===================================================================
  //  Write Address channel (AW) — address + protection + user sideband
  // ===================================================================
  logic [ADDR_W-1:0]   awaddr;    // register address
  logic [2:0]          awprot;    // protection: privilege/security/instruction
  logic [U_W-1:0]      awuser;    // user-defined sideband (per-transaction)
  logic                awvalid;   // master: address+control valid
  logic                awready;   // slave: address accepted

  // ===================================================================
  //  Write Data channel (W) — data + byte strobes + user sideband
  // ===================================================================
  logic [DATA_W-1:0]   wdata;     // write data (one beat, single-beat only)
  logic [STRB_W-1:0]   wstrb;     // byte enables: wstrb[i] qualifies byte lane i
  logic [U_W-1:0]      wuser;     // user-defined sideband (per-beat)
  logic                wvalid;    // master: data+strobe valid
  logic                wready;    // slave: data accepted

  // ===================================================================
  //  Write Response channel (B) — response + user sideband
  // ===================================================================
  logic [1:0]          bresp;     // slave: response OKAY/SLVERR/DECERR
  logic [U_W-1:0]      buser;     // user-defined sideband (per-response)
  logic                bvalid;    // slave: response valid
  logic                bready;    // master: response accepted

  // ===================================================================
  //  Read Address channel (AR) — address + protection + user sideband
  // ===================================================================
  logic [ADDR_W-1:0]   araddr;    // register address
  logic [2:0]          arprot;    // protection: privilege/security/instruction
  logic [U_W-1:0]      aruser;    // user-defined sideband (per-transaction)
  logic                arvalid;   // master: address+control valid
  logic                arready;   // slave: address accepted

  // ===================================================================
  //  Read Data channel (R) — data + response + user sideband
  // ===================================================================
  logic [DATA_W-1:0]   rdata;     // slave: read data (one beat)
  logic [1:0]          rresp;     // slave: response OKAY/SLVERR/DECERR
  logic [U_W-1:0]      ruser;     // user-defined sideband (per-beat)
  logic                rvalid;    // slave: data+response valid
  logic                rready;    // master: data accepted

  // ===================================================================
  //  Full modports: all 5 channels (convenient for monolithic modules)
  // ===================================================================

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

  // ===================================================================
  //  Sub-channel modports: connect only the channels you need
  // ===================================================================

  // ---- Write Address source (Tx) / sink (Rx) ------------------------
  // aw_src: master side (drives address) | aw_sink: slave side (receives)
  modport aw_src (
    input  aclk, aresetn,
    output awaddr, awprot, awuser, awvalid, input  awready
  );
  modport aw_sink (
    input  aclk, aresetn,
    input  awaddr, awprot, awuser, awvalid, output awready
  );

  // ---- Write Data source (Tx) / sink (Rx) ---------------------------
  // w_src: master side (drives data) | w_sink: slave side (receives)
  modport w_src (
    input  aclk, aresetn,
    output wdata, wstrb, wuser, wvalid, input  wready
  );
  modport w_sink (
    input  aclk, aresetn,
    input  wdata, wstrb, wuser, wvalid, output wready
  );

  // ---- Write Response source (Tx) / sink (Rx) -----------------------
  // b_src: slave side (drives response) | b_sink: master side (receives)
  modport b_src (
    input  aclk, aresetn,
    output bresp, buser, bvalid, input  bready
  );
  modport b_sink (
    input  aclk, aresetn,
    input  bresp, buser, bvalid, output bready
  );

  // ---- Read Address source (Tx) / sink (Rx) -------------------------
  // ar_src: master side (drives address) | ar_sink: slave side (receives)
  modport ar_src (
    input  aclk, aresetn,
    output araddr, arprot, aruser, arvalid, input  arready
  );
  modport ar_sink (
    input  aclk, aresetn,
    input  araddr, arprot, aruser, arvalid, output arready
  );

  // ---- Read Data source (Tx) / sink (Rx) ----------------------------
  // r_src: slave side (drives data) | r_sink: master side (receives)
  modport r_src (
    input  aclk, aresetn,
    output rdata, rresp, ruser, rvalid, input  rready
  );
  modport r_sink (
    input  aclk, aresetn,
    input  rdata, rresp, ruser, rvalid, output rready
  );
endinterface
