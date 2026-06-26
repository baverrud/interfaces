`timescale 1ns/1ps

// =====================================================================
// top_tb.sv - UART testbench
// =====================================================================
// Clock generator and reset sequence.  The UART test uses BAUD_DIV=8
// for fast simulation (each bit period = 8 clock cycles).
// With 8 data bits + start + stop = 10 bits, a full TX+RX cycle
// takes roughly 160 clock cycles; timeout set to 500 for safety.
// =====================================================================
module top_tb;

  // ---- parameters ------------------------------------------------
  localparam int BAUD_DIV = 8;         // must match the DUT

  // ---- signals ---------------------------------------------------
  logic clk;                           // 100 MHz clock (10 ns period)
  logic rstn;                          // active-low reset
  logic done;                          // test-complete flag

  // ---- instantiate design under test -----------------------------
  top #(.BAUD_DIV(BAUD_DIV)) dut (.*);

  // ---- clock: 50% duty cycle, 10 ns period -----------------------
  always #5 clk = !clk;

  // ---- stimulus --------------------------------------------------
  initial begin
    clk  <= 0;
    rstn <= 0;                         // assert reset
    repeat (4) @(posedge clk);         // hold for 4 cycles
    rstn <= 1;                         // release reset

    // Wait for done or timeout (500 cycles max)
    for (int i = 0; i < 500; i++) begin
      @(posedge clk);
      if (done) break;
    end
    assert (done) else $fatal("UART: timeout");

    $display("=== UART PASSED ===");
    $stop;
  end

endmodule
