`timescale 1ns/1ps
// =====================================================================
// top_sub_slave_tb.sv - AXI4-Lite self-checking TB (full split)
// =====================================================================
// Tests top_sub_slave: fully split master and slave sides.  The write
// master writes 0xB0B0B0B0; the read master reads from the read slave
// which is pre-initialized with 0xC0C0C0C0.  Since this design has
// separate write/read address spaces, the read-back should be 0xC0C0C0C0.
// =====================================================================
module top_sub_slave_tb;
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

  top_sub_slave #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .USER_W(USER_W), .DEPTH(DEPTH))
    dut (.*);

  always #(TCLK/2) aclk = ~aclk;

  initial begin
    aresetn = 0;
    repeat (4) @(posedge aclk);
    aresetn = 1;

    repeat (40) @(posedge aclk);
    wait (done);

    if (rd_data !== 32'hC0C0C0C0) begin
      $error("FAILED: readback = %h (expected C0C0C0C0)", rd_data);
    end else begin
      $display("PASSED: readback = %h", rd_data);
    end
    $stop;
  end
endmodule
