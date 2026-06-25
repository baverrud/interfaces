`timescale 1ns/1ps
// =====================================================================
// top_tb.sv - AXI4-Lite self-checking testbench
// =====================================================================
module top_tb;
  localparam int DATA_W = 32;
  localparam int ADDR_W = 32;
  localparam time TCLK  = 10ns;

  logic aclk    = 0;
  logic aresetn = 0;
  logic [DATA_W-1:0] reg_readout;

  top #(.DATA_W(DATA_W), .ADDR_W(ADDR_W)) dut (.*);

  always #(TCLK/2) aclk = ~aclk;

  initial begin
    aresetn = 0;
    repeat (4) @(posedge aclk);
    aresetn = 1;

    // Wait for the write-read cycle to complete (state 5)
    repeat (40) @(posedge aclk);
    assert (reg_readout == 32'hDEADBEEF)
      else $fatal("Register readback mismatch: expected DEADBEEF, got %h", reg_readout);
    $display("PASSED: register readback = %h", reg_readout);
    $stop;
  end
endmodule
