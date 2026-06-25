`timescale 1ns/1ps
// =====================================================================
// top_sub_tb.sv - AXI4-Lite self-checking TB (split masters)
// =====================================================================
// Tests top_sub: separate write and read masters with a single full
// slave.  The write master writes 0xB0B0B0B0; the read master reads
// it back.  Verifies the read-back matches.
// =====================================================================
module top_sub_tb;
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

  top_sub #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .USER_W(USER_W), .DEPTH(DEPTH))
    dut (.*);

  always #(TCLK/2) aclk = ~aclk;

  initial begin
    aresetn = 0;
    repeat (4) @(posedge aclk);
    aresetn = 1;

    repeat (40) @(posedge aclk);
    wait (done);

    if (rd_data !== 32'hB0B0B0B0) begin
      $error("FAILED: readback = %h (expected B0B0B0B0)", rd_data);
    end else begin
      $display("PASSED: readback = %h", rd_data);
    end
    $stop;
  end
endmodule
