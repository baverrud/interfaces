`timescale 1ns/1ps
module top_tb;
  parameter DATA_W=32;
  logic clk,rstn;
  logic [DATA_W-1:0] rd_data;
  logic rd_valid, done;
  top #(.DATA_W(DATA_W)) dut (.*);
  always #5 clk = !clk;
  initial begin
    clk <= 0; rstn <= 0;
    repeat (4) @(posedge clk);
    rstn <= 1;
    repeat (200) @(posedge clk);
    assert (done) else $fatal("WISHBONE: timeout");
    assert (rd_data === 32'hA5) else $fatal("WISHBONE: mismatch");
    $display("=== WISHBONE PASSED ==="); $stop;
  end
endmodule
