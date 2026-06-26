`timescale 1ns/1ps
// =====================================================================
// top_concrete_tb.sv - testbench for the concrete 32-bit interface demo
// =====================================================================
// Sends 16 beats through axis_32b_if, then checks done asserts.
// =====================================================================
module top_concrete_tb;
  parameter int N_BEATS = 16;
  parameter int TCLK    = 10;

  logic aclk    = 0;
  logic aresetn = 0;
  logic done;

  top_concrete #(.N_BEATS(N_BEATS)) dut (.*);

  always #(TCLK/2) aclk = !aclk;

  initial begin
    aresetn <= 0;
    repeat (4) @(posedge aclk);
    aresetn <= 1;

    // Wait for done with timeout
    repeat (N_BEATS * 10) @(posedge aclk);
    assert (done) else $fatal("CONCRETE: done never asserted");
    $display("=== CONCRETE INTERFACE (axis_32b_if) PASSED ===");
    $stop;
  end
endmodule
