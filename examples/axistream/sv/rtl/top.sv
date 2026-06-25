`timescale 1ns/1ps
// =====================================================================
// top.sv - synthesizable top: producer -> stream_fifo -> consumer
// =====================================================================
// Two parameterized interface instances carry pixel_t; the same
// stream_fifo/sync_fifo would serve any other payload (see the IQ stream
// exercised in the testbench).  Clock/reset live in the interfaces.
// =====================================================================
module top #(
  parameter int FIFO_DEPTH = 16,
  parameter int LINE       = 8
) (
  input  logic        aclk,
  input  logic        aresetn,
  output logic [7:0]  last_r,
  output logic [7:0]  last_g,
  output logic [7:0]  last_b,
  output logic        last_sof,
  output logic [15:0] beats
);
  import stream_pkg::*;

  axis_if #(.PAYLOAD_T(pixel_t), .HAS_TLAST(1)) src  (.aclk, .aresetn);
  axis_if #(.PAYLOAD_T(pixel_t), .HAS_TLAST(1)) sink (.aclk, .aresetn);

  pixel_producer #(.LINE(LINE)) u_prod (
    .m(src.master)
  );

  stream_fifo #(.PAYLOAD_T(pixel_t), .DEPTH(FIFO_DEPTH), .HAS_TLAST(1)) u_fifo (
    .s(src.slave), .m(sink.master)
  );

  pixel_consumer u_cons (
    .s(sink.slave),
    .last_r, .last_g, .last_b, .last_sof, .beats
  );
endmodule
