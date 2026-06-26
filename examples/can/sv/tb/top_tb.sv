`timescale 1ns/1ps

// =====================================================================
// top_tb.sv - CAN testbench
// =====================================================================
module top_tb;

  logic clk, rstn, done;

  top dut (.*);

  always #5 clk = !clk;

  initial begin
    clk  <= 0;
    rstn <= 0;
    repeat (4) @(posedge clk);
    rstn <= 1;

    for (int i = 0; i < 500; i++) begin
      @(posedge clk);
      if (done) break;
    end
    assert (done) else $fatal("CAN: timeout");

    $display("=== CAN PASSED ===");
    $stop;
  end

endmodule
