`timescale 1ns/1ps

// =====================================================================
// top_tb.sv - I2C testbench
// =====================================================================
// Adds pull-up resistors to the I2C bus (SCL, SDA) and instantiates
// the DUT.  Without pull-ups the open-drain lines would float.
// =====================================================================
module top_tb;

  logic clk, rstn, done;

  top #(.DEV_ADDR(7'h50)) dut (.*);

  // ---- I2C bus pull-up resistors --------------------------------
  // The inout wires need weak pull-ups to keep the lines high when
  // no driver is actively pulling them low (open-drain protocol).
  pullup (dut.bus.scl);
  pullup (dut.bus.sda);

  // ---- clock: 50% duty cycle, 10 ns period ---------------------
  always #5 clk = !clk;

  // ---- stimulus ------------------------------------------------
  initial begin
    clk  <= 0;
    rstn <= 0;
    repeat (4) @(posedge clk);
    rstn <= 1;

    for (int i = 0; i < 2000; i++) begin
      @(posedge clk);
      if (done) break;
    end
    assert (done) else $fatal("I2C: timeout");

    $display("=== I2C PASSED ===");
    $stop;
  end

endmodule
