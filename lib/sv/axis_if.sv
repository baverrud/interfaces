`timescale 1ns/1ps
// =====================================================================
// axis_if.sv - parameterized AXI-Stream interface (clock/reset in IF)
// =====================================================================
// PAYLOAD_T sets tdata's type.  Each sideband width: 0 = absent (sized to
// a 1-bit stub via the safe-width localparams so no [-1:0] ranges form).
// 'master' = Transmitter (drives payload); 'slave' = Receiver.
// aclk/aresetn live in the interface so concurrent protocol assertions
// can be written here (active-low, asynchronous).
// =====================================================================
interface axis_if #(
  parameter type PAYLOAD_T   = logic [31:0],
  parameter bit  HAS_TLAST   = 0,
  parameter int  TUSER_WIDTH = 0,
  parameter int  TID_WIDTH   = 0,
  parameter int  TDEST_WIDTH = 0,
  parameter int  TKEEP_WIDTH = 0,
  parameter int  TSTRB_WIDTH = 0
) (
  input logic aclk,
  input logic aresetn               // active-low, asynchronous
);
  // safe widths: never collapse a packed range to [-1:0]
  localparam int USER_W = (TUSER_WIDTH > 0) ? TUSER_WIDTH : 1;
  localparam int ID_W   = (TID_WIDTH   > 0) ? TID_WIDTH   : 1;
  localparam int DEST_W = (TDEST_WIDTH > 0) ? TDEST_WIDTH : 1;
  localparam int KEEP_W = (TKEEP_WIDTH > 0) ? TKEEP_WIDTH : 1;
  localparam int STRB_W = (TSTRB_WIDTH > 0) ? TSTRB_WIDTH : 1;

  // handshake (always present)
  logic tvalid, tready;
  // payload
  PAYLOAD_T tdata;
  // sidebands (stub-sized when their *_WIDTH is 0)
  logic              tlast;
  logic [USER_W-1:0] tuser;
  logic [ID_W-1:0]   tid;
  logic [DEST_W-1:0] tdest;
  logic [KEEP_W-1:0] tkeep;
  logic [STRB_W-1:0] tstrb;

  // master = Tx (drives payload + framing), slave = Rx (converse)
  modport master (
    input  aclk, aresetn, tready,
    output tvalid, tdata, tlast, tuser, tid, tdest, tkeep, tstrb
  );
  modport slave (
    input  aclk, aresetn, tvalid, tdata, tlast, tuser, tid, tdest, tkeep, tstrb,
    output tready
  );

  // ---- verification support (sim-only) ---------------------------
`ifndef SYNTHESIS
  // payload + tlast must hold steady while stalled (tvalid && !tready)
  property p_payload_stable;
    @(posedge aclk) disable iff (!aresetn)
    (tvalid && !tready) |=>
      (tvalid && $stable(tdata) && (!HAS_TLAST || $stable(tlast)));
  endproperty
  assert property (p_payload_stable)
    else $error("axis_if: payload changed during stall");

  // tvalid must remain asserted until the handshake completes
  property p_tvalid_stable;
    @(posedge aclk) disable iff (!aresetn)
    (tvalid && !tready) |=> tvalid;
  endproperty
  assert property (p_tvalid_stable)
    else $error("axis_if: tvalid deasserted while waiting for tready");
`endif
endinterface
