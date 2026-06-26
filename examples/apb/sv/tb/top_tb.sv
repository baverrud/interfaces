`timescale 1ns/1ps
// =====================================================================
// top_tb.sv - APB testbench
// =====================================================================
// Generates clock and reset, instantiates the DUT, and waits for the
// producer to complete its write-then-read sequence.  Verifies that
// the read-back data matches the written pattern (0xA5).
// =====================================================================
module top_tb;
  parameter int DATA_W = 32;              // match DUT data width

  logic               pclk;               // APB clock
  logic               prstn;              // APB reset (active low)
  logic [DATA_W-1:0]  rd_data;            // read data from DUT
  logic               rd_valid;           // strobe: rd_data valid
  logic               done;               // completion flag from DUT

  // Instantiate the DUT with auto-connected ports (.*)
  top #(.DATA_W(DATA_W)) dut (.*);

  // Generate a 10 ns clock (5 ns half-cycle)
  always #5 pclk = !pclk;

  initial begin
    // ---- Reset sequence ----------------------------------------------
    pclk  <= 0;
    prstn <= 0;                            // assert reset (active low)
    repeat (4) @(posedge pclk);            // hold reset for 4 cycles
    prstn <= 1;                            // de-assert reset

    // ---- Wait for done with a generous timeout -----------------------
    fork
      begin: timeout
        repeat (200) @(posedge pclk);     // 200 clock cycle timeout
        $fatal("APB: timeout — done never asserted");
      end
      begin: wait_done
        @(posedge done);                  // wait for completion
        disable timeout;
      end
    join

    // ---- Verify the read-back data -----------------------------------
    assert (rd_data === 32'hA5)
      else $fatal("APB: data mismatch — got %h expected A5", rd_data);

    $display("=== APB PASSED ===");
    $stop;
  end
endmodule

