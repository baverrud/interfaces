`timescale 1ns/1ps
// =====================================================================
// top_array_tb.sv - testbench for the array-of-interfaces demo
// =====================================================================
// Checks that both pixel lanes produce data and done asserts.
// =====================================================================
module top_array_tb;
  parameter int TCLK = 10;
  parameter int N_LANES = 2;
  parameter int LINE    = 8;

  logic        aclk    = 0;
  logic        aresetn = 0;
  logic [15:0] beats;
  logic        done;

  top_array #(.N_LANES(N_LANES), .FIFO_DEPTH(16), .LINE(LINE)) dut (.*);

  always #(TCLK/2) aclk = !aclk;

  initial begin
    aresetn <= 0;
    repeat (4) @(posedge aclk);
    aresetn <= 1;

    // Wait for done with generous timeout
    repeat (500) @(posedge aclk);
    assert (done) else $fatal("ARRAY: done never asserted");
    assert (beats >= N_LANES * LINE)
      else $fatal("ARRAY: too few beats (%0d < %0d)", beats, N_LANES * LINE);

    $display("INFO: total beats = %0d", beats);
    $display("=== ARRAY OF INTERFACES (SV interface array) PASSED ===");
    $stop;
  end
endmodule
