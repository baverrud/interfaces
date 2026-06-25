`timescale 1ns/1ps
// =====================================================================
// pixel_consumer.sv - receives a stream, unpacks pixels, exposes them
// =====================================================================
// 'px = s.tdata' IS the "unpack" - assigning the bus to a packed struct
// splits the fields automatically.  Clock/reset come from the interface
// (s.aclk / s.aresetn, active-low async).
// =====================================================================
module pixel_consumer (
  axis_if.slave       s,        // s.tdata is pixel_t (from the instance)
  output logic [7:0]  last_r,
  output logic [7:0]  last_g,
  output logic [7:0]  last_b,
  output logic        last_sof,
  output logic [15:0] beats
);
  import payload_pkg::*;

  pixel_t      px;
  logic [15:0] nbeat = '0;

  assign s.tready = 1'b1;        // always ready
  assign px       = s.tdata;     // bus -> packed struct, automatically

  always_ff @(posedge s.aclk or negedge s.aresetn) begin
    if (!s.aresetn) begin
      nbeat    <= '0;
      last_r   <= '0;
      last_g   <= '0;
      last_b   <= '0;
      last_sof <= '0;
    end else if (s.tvalid && s.tready) begin   // accepted beat
      last_r   <= px.r;
      last_g   <= px.g;
      last_b   <= px.b;
      last_sof <= px.sof;
      nbeat    <= nbeat + 16'd1;
    end
  end

  assign beats = nbeat;
endmodule
