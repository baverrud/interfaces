`timescale 1ns/1ps
// =====================================================================
// top_tb.sv - AXI4-Lite self-checking testbench (full master+slave)
// =====================================================================
// Generates clock + reset for the top (axilite_master + axilite_slave)
// design, waits for the write-read sequence to complete, and verifies
// that the read-back data matches the expected 0xA5A5A5A5 pattern.
// =====================================================================
module top_tb;
  localparam int DATA_W = 32;
  localparam int ADDR_W = 32;
  localparam int USER_W = 0;
  localparam int DEPTH  = 256;
  localparam time TCLK  = 10ns;

  logic aclk             = 0;
  logic aresetn          = 0;
  logic [DATA_W-1:0] rd_data;
  logic              rd_valid;
  logic              done;

  top #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .USER_W(USER_W), .DEPTH(DEPTH))
    dut (.*);

  always #(TCLK/2) aclk = ~aclk;

  initial begin
    aresetn = 0;
    repeat (4) @(posedge aclk);
    aresetn = 1;

    repeat (40) @(posedge aclk);
    wait (done);

    if (rd_data !== 32'hA5A5A5A5) begin
      $error("FAILED: readback = %h (expected A5A5A5A5)", rd_data);
    end else begin
      $display("PASSED: readback = %h", rd_data);
    end

    $stop;
  end
endmodule
