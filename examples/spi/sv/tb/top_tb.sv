`timescale 1ns/1ps

// =====================================================================
// top_tb.sv - SPI testbench
// =====================================================================
// Clock generator and reset sequence.  Asserts done at end of test.
// =====================================================================
module top_tb;

  // ---- signals -----------------------------------------------------
  logic clk;                       // 100 MHz clock (10 ns period)
  logic rstn;                      // active-low reset
  logic done;                      // test-complete flag

  // ---- instantiate design under test -------------------------------
  top dut (.*);

  // ---- clock: 50% duty cycle, 10 ns period ------------------------
  always #5 clk = !clk;

  // ---- stimulus: release reset, wait for done or timeout ----------
  initial begin
    clk  <= 0;
    rstn <= 0;                     // assert reset
    repeat (4) @(posedge clk);     // hold for 4 cycles
    rstn <= 1;                     // release reset

    // Wait up to 500 clock cycles for done
    for (int i = 0; i < 500; i++) begin
      @(posedge clk);
      if (done) break;
    end
    assert (done) else $fatal("SPI: timeout");

    $display("=== SPI PASSED ===");
    $stop;
  end

endmodule
