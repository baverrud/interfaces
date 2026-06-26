`timescale 1ns/1ps
// =====================================================================
// axis_32b_if.sv - concrete 32-bit AXI-Stream interface (no parameters)
// =====================================================================
// All signal widths are fixed at declaration time — no PAYLOAD_T
// parameter, no sideband-width generics.  Trade-off: one interface per
// width combo, but signal declarations are minimal.
//
// Compare:
//   axis_32b_if str (.aclk, .aresetn);          // this file (no #())
//   axis_if #(.PAYLOAD_T(logic[31:0])) str ...; // axis_if (parameterized)
// =====================================================================
interface axis_32b_if (
  input logic aclk,
  input logic aresetn               // active-low, asynchronous
);
  // handshake (always present)
  logic        tvalid, tready;
  // payload — fixed to 32 bits
  logic [31:0] tdata;
  // sidebands — all 1-bit safe-width stubs
  logic        tlast;
  logic [0:0]  tuser;
  logic [0:0]  tid;
  logic [0:0]  tdest;
  logic [0:0]  tkeep;
  logic [0:0]  tstrb;

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
  property p_payload_stable;
    @(posedge aclk) disable iff (!aresetn)
    (tvalid && !tready) |=> (tvalid && $stable(tdata) && $stable(tlast));
  endproperty
  assert property (p_payload_stable)
    else $error("axis_32b_if: payload changed during stall");

  property p_tvalid_stable;
    @(posedge aclk) disable iff (!aresetn)
    (tvalid && !tready) |=> tvalid;
  endproperty
  assert property (p_tvalid_stable)
    else $error("axis_32b_if: tvalid deasserted while waiting for tready");
`endif
endinterface
