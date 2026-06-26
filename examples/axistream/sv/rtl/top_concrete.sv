`timescale 1ns/1ps
// =====================================================================
// top_concrete.sv - concrete 32-bit AXI-Stream interface demo
// =====================================================================
// Demonstrates `axis_32b_if` — a non-parameterized interface with all
// widths fixed.  No #() parameter list needed at instantiation.
// Producer and consumer logic is inline to focus on the interface type.
//
// Compare:
//   axis_32b_if str(...);           // this file (no #())
//   axis_if #(.PAYLOAD_T(...)) ...; // top.sv (parameterized)
// =====================================================================
module top_concrete #(
  parameter int N_BEATS = 16
) (
  input  logic aclk,
  input  logic aresetn,
  output logic done
);
  axis_32b_if str (.aclk, .aresetn);

  logic [31:0] nbeat = '0;
  logic        done_r = '0;

  // ---- Producer: drive a counter as tdata ---------------------------
  assign str.tvalid = (nbeat < N_BEATS);
  assign str.tdata  = nbeat;
  assign str.tlast  = (nbeat == N_BEATS - 1);
  assign str.tuser  = '0;
  assign str.tid    = '0;
  assign str.tdest  = '0;
  assign str.tkeep  = '0;
  assign str.tstrb  = '0;

  // ---- Consumer: always ready ---------------------------------------
  assign str.tready = 1'b1;

  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      nbeat <= '0;
      done_r <= '0;
    end else if (str.tvalid && str.tready) begin
      if (nbeat == N_BEATS - 1)
        done_r <= 1'b1;
      else
        nbeat <= nbeat + 1'b1;
    end
  end

  assign done = done_r;
endmodule
