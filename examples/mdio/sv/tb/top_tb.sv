`timescale 1ns/1ps

// =====================================================================
// top_tb.sv - MDIO testbench
// =====================================================================
module top_tb;

  logic clk, rstn, done;

  top #(.WR_DATA(16'hA5A5)) dut (.*);

  // ---- I2C-style pull-up on MDIO --------------------------------
  pullup (dut.bus.mdio);

  always #5 clk = !clk;

  initial begin
    clk  <= 0;
    rstn <= 0;
    repeat (4) @(posedge clk);
    rstn <= 1;

    for (int i = 0; i < 3000; i++) begin
      @(posedge clk);
      if (done) break;
    end
    assert (done) else $fatal("MDIO: timeout");

    $display("=== MDIO PASSED ===");
    $stop;
  end

endmodule
