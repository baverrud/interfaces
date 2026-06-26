`timescale 1ns/1ps
// =====================================================================
// top_array.sv - N parallel pixel lanes via interface arrays
// =====================================================================
// Demonstrates SV interface arrays: `axis_if buses[N]` creates N
// independent interface instances.  A `generate for` loop instantiates
// identical producer → FIFO → consumer lanes.  Each element of the
// array IS an axis_if, so the existing pixel_producer, stream_fifo,
// and pixel_consumer modules connect directly — no wrappers needed.
// =====================================================================
module top_array #(
  parameter int N_LANES    = 2,
  parameter int FIFO_DEPTH = 16,
  parameter int LINE       = 8
) (
  input  logic        aclk,
  input  logic        aresetn,
  output logic [15:0] beats,
  output logic        done
);
  import payload_pkg::*;

  // Interface arrays: N independent stream instances per side
  axis_if #(.PAYLOAD_T(pixel_t), .HAS_TLAST(1)) src [N_LANES] (.aclk, .aresetn);
  axis_if #(.PAYLOAD_T(pixel_t), .HAS_TLAST(1)) sink[N_LANES] (.aclk, .aresetn);

  // Per-lane beat counters
  logic [15:0] lane_beats[N_LANES];
  logic [15:0] total_beats;

  // One pixel pipeline per lane
  genvar i;
  generate
    for (i = 0; i < N_LANES; i++) begin : lane
      pixel_producer #(.LINE(LINE)) u_prod (
        .m(src[i].master)
      );

      stream_fifo #(.PAYLOAD_T(pixel_t), .DEPTH(FIFO_DEPTH), .HAS_TLAST(1))
        u_fifo (
          .s(src[i].slave),
          .m(sink[i].master)
        );

      pixel_consumer u_cons (
        .s      (sink[i].slave),
        .last_r (),
        .last_g (),
        .last_b (),
        .last_sof(),
        .beats  (lane_beats[i])
      );
    end
  endgenerate

  // Sum all lane beat counts (variable avoids combinational loop)
  always_comb begin
    logic [15:0] sum;
    sum = '0;
    for (int j = 0; j < N_LANES; j++)
      sum = sum + lane_beats[j];
    total_beats = sum;
  end

  assign beats = total_beats;
  assign done  = (total_beats >= N_LANES * LINE);

endmodule
