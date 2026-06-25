`timescale 1ns/1ps
// =====================================================================
// top_tb.sv - AXI4 demo self-checking testbench
// =====================================================================
// Generates clock + reset, waits for the FSM to complete the write-
// read cycle, then asserts every read-back beat matches the expected
// pattern.  Burst length is parameterized to match the DUT; the
// check loop scales automatically.
// =====================================================================
module top_tb;
  localparam int DATA_W    = 32;
  localparam int ADDR_W    = 32;
  localparam int ID_W      = 4;
  localparam int BURST_LEN = 4;      // must match top's BURST_LEN
  localparam int DEPTH     = 256;
  localparam time TCLK     = 10ns;

  logic aclk    = 0;
  logic aresetn = 0;
  logic [DATA_W-1:0] rd_data;
  logic rd_valid;
  logic done;

  top #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W),
      .BURST_LEN(BURST_LEN), .DEPTH(DEPTH))
    dut (.*);

  // ---- Clock ---------------------------------------------------------
  always #(TCLK/2) aclk = ~aclk;



  // ---- Test sequence -------------------------------------------------
  initial begin
    logic [DATA_W-1:0] expected;
    logic [DATA_W-1:0] got;
    int                 beat_count;
    int                 errors;

    errors     = 0;
    beat_count = 0;

    $display("=== AXI4 Burst Write/Read Demo (%0d-beat bursts) ===", BURST_LEN);

    // ---- Reset -----------------------------------------------------
    aresetn = 0;
    repeat (8) @(posedge aclk);
    aresetn = 1;
    @(posedge aclk);

    // ---- Wait for done + capture read-data beats ------------------
    // Collect rd_valid pulses as they occur during the read phase.
    for (int i = 0; i < 20 * BURST_LEN * 10; i++) begin
      @(posedge aclk);
      if (rd_valid) begin
        got = rd_data;
        // Expected: {8'hA0 + beat, 24'(beat + 1)}
        expected = {8'(8'hA0 + beat_count), 24'(beat_count + 1)};
        if (got !== expected) begin
          $error("Beat %0d mismatch: expected %h, got %h",
               beat_count, expected, got);
          errors++;
        end else
          $display("  Beat %0d: %h  (OK)", beat_count, got);
        beat_count++;
      end
      if (done) break;
    end
    if (!done)
      $fatal(1, "TIMEOUT: demo did not complete within %0d cycles",
           20 * BURST_LEN * 10);

    // ---- Report results --------------------------------------------
    if (errors == 0 && beat_count == BURST_LEN)
      $display("PASSED: All %0d beats matched expected pattern", beat_count);
    else begin
      if (beat_count != BURST_LEN)
        $fatal(1, "Expected %0d beats, got %0d", BURST_LEN, beat_count);
      else
        $fatal(1, "FAILED: %0d/%0d beats mismatched", errors, beat_count);
    end

    $display("=== AXI4 Burst Demo PASSED ===");
    $stop;
  end
endmodule
