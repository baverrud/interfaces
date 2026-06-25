`timescale 1ns/1ps
// =====================================================================
// top_sub_tb.sv - AXI3 sub-channel demo self-checking testbench
// =====================================================================
module top_sub_tb;
  localparam int DATA_W    = 32;
  localparam int ADDR_W    = 32;
  localparam int ID_W      = 4;
  localparam int BURST_LEN = 4;
  localparam int DEPTH     = 256;
  localparam time TCLK     = 10ns;

  logic aclk    = 0;
  logic aresetn = 0;
  logic [DATA_W-1:0] rd_data;
  logic rd_valid;
  logic done;

  top_sub #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W),
        .BURST_LEN(BURST_LEN), .DEPTH(DEPTH)) dut (.*);

  always #(TCLK/2) aclk = ~aclk;

  initial begin
    logic [DATA_W-1:0] expected;
    int beat_count, errors;
    errors = 0; beat_count = 0;

    $display("=== AXI3 Sub-Channel Demo (%0d-beat bursts) ===", BURST_LEN);

    aresetn = 0;
    repeat (8) @(posedge aclk);
    aresetn = 1;
    @(posedge aclk);

    for (int i = 0; i < 20 * BURST_LEN * 10; i++) begin
      @(posedge aclk);
      if (rd_valid) begin
        expected = {8'(8'hB0 + beat_count), 24'(beat_count + 1)};
        if (rd_data !== expected) begin
          $error("Beat %0d mismatch: expected %h, got %h", beat_count, expected, rd_data);
          errors++;
        end else $display("  Beat %0d: %h  (OK)", beat_count, rd_data);
        beat_count++;
      end
      if (done) break;
    end
    if (!done) $fatal(1, "TIMEOUT");

    if (errors == 0 && beat_count == BURST_LEN)
      $display("PASSED: All %0d beats matched expected pattern", beat_count);
    else if (beat_count != BURST_LEN)
      $fatal(1, "Expected %0d beats, got %0d", BURST_LEN, beat_count);
    else
      $fatal(1, "FAILED: %0d/%0d beats mismatched", errors, beat_count);

    $display("=== AXI3 Sub-Channel Demo PASSED ===");
    $stop;
  end
endmodule
