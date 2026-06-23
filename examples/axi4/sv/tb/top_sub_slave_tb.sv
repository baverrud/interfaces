`timescale 1ns/1ps
// =====================================================================
// top_sub_slave_tb.sv - AXI4 full sub-channel demo self-checking TB
// =====================================================================
// Tests the full sub-channel architecture: write master writes
// BURST_LEN words to the write-only slave, then read master reads
// BURST_LEN words from the read-only slave.  The write and read
// slaves are independent modules sharing the same axi4_if bus.
//
// Modports exercised:
//   Master side:  aw_src, w_src, b_sink, ar_src, r_sink
//   Slave side:   aw_sink, w_sink, b_src, ar_sink, r_src
// =====================================================================
module top_sub_slave_tb;
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

    top_sub_slave #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W),
                    .BURST_LEN(BURST_LEN), .DEPTH(DEPTH))
        dut (.*);

    // ---- Clock ---------------------------------------------------------
    always #(TCLK/2) aclk = ~aclk;

    // ---- Test sequence -------------------------------------------------
    initial begin
        int beat_count;
        int errors;
        logic [DATA_W-1:0] expected;

        errors     = 0;
        beat_count = 0;

        $display("=== AXI4 Full Sub-Channel Demo (%0d-beat bursts) ===", BURST_LEN);
        $display("  Write master: aw_src + w_src + b_sink");
        $display("  Read master:  ar_src + r_sink");
        $display("  Write slave:  aw_sink + w_sink + b_src");
        $display("  Read slave:   ar_sink + r_src");

        // ---- Reset -----------------------------------------------------
        aresetn = 0;
        repeat (8) @(posedge aclk);
        aresetn = 1;
        @(posedge aclk);

        // ---- Wait for done + capture read-data beats ------------------
        for (int i = 0; i < 20 * BURST_LEN * 10; i++) begin
            @(posedge aclk);
            if (rd_valid) begin
                // Read slave generates: {8'hC0 + addr, 24'(addr + 1)}
                // The read master reads from address 0 (default in axi4_read_master)
                expected = {8'(8'hC0 + beat_count), 24'(beat_count + 1)};
                if (rd_data !== expected) begin
                    $error("Beat %0d mismatch: expected %h, got %h",
                           beat_count, expected, rd_data);
                    errors++;
                end else begin
                    $display("  Beat %0d: %h  (OK)", beat_count, rd_data);
                end
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
        else if (beat_count != BURST_LEN)
            $fatal(1, "Expected %0d beats, got %0d", BURST_LEN, beat_count);
        else
            $fatal(1, "FAILED: %0d/%0d beats mismatched", errors, beat_count);

        $display("=== AXI4 Full Sub-Channel Demo PASSED ===");
        $stop;
    end
endmodule
