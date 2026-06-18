// =====================================================================
// top_tb.sv - self-checking testbench (SystemVerilog)
// =====================================================================
// Self-checking testbench:
//   1) pack/unpack via bit-cast for BOTH packed structs (pixel_t, iq_t);
//   2) an iq_t sequence pushed through a generic stream_fifo at 32-bit
//      width and checked for value/order/tlast;
//   3) the synthesizable pixel pipeline actually moves data.
// Note how 'pack/unpack' here is just assignment - no helper functions.
// =====================================================================
`timescale 1ns/1ps
module top_tb;
    import stream_pkg::*;

    localparam time TCLK = 10ns;
    localparam int  NIQ  = 8;

    logic clk = 0;
    logic rst = 1;

    // pixel pipeline outputs
    logic [7:0]  last_r, last_g, last_b;
    logic        last_sof;
    logic [15:0] beats;

    // second stream: IQ through a generic stream_fifo (32-bit)
    logic sof_seen = 0;

    // -------- DUT 1: full pixel pipeline -----------------------------
    top #(.FIFO_DEPTH(16), .LINE(8)) dut_pix (
        .clk, .rst, .last_r, .last_g, .last_b, .last_sof, .beats
    );

    // -------- DUT 2: a second generic FIFO at the IQ width ------------
    axis_if #(.T(iq_t)) iq_src ();
    axis_if #(.T(iq_t)) iq_sink ();
    stream_fifo #(.T(iq_t), .DEPTH(16)) dut_iq (
        .clk, .rst, .s(iq_src.rx), .m(iq_sink.tx)
    );

    // clock
    always #(TCLK/2) clk = ~clk;

    // observe a start-of-frame leaving the pixel pipeline
    always @(posedge clk) if (last_sof) sof_seen <= 1;

    initial begin
        iq_t    seq [NIQ];
        iq_t    got;
        pixel_t p, rp;
        logic [$bits(pixel_t)-1:0] pv;

        // ---- 0) reset ----------------------------------------------
        iq_src.tvalid  = 0;
        iq_src.tlast   = 0;
        iq_src.tdata   = '0;
        iq_sink.tready = 0;
        rst = 1;
        repeat (4) @(posedge clk);
        @(posedge clk);
        rst = 0;

        // ---- 1) pack/unpack (bit-cast) round-trips -----------------
        assert ($bits(pixel_t) == 25) else $fatal(1, "PIXEL width != 25");
        assert ($bits(iq_t)    == 32) else $fatal(1, "IQ width != 32");

        for (int k = 0; k < 5; k++) begin
            p.r   = 8'(10*k + 1);
            p.g   = 8'(10*k + 2);
            p.b   = 8'(10*k + 3);
            p.sof = (k % 2 == 0);
            pv = p;                       // pack  (struct -> bus)
            rp = pv;                      // unpack (bus -> struct)
            assert (rp == p) else $fatal(1, "pixel round-trip mismatch k=%0d", k);
        end

        for (int k = 0; k < NIQ; k++) begin
            seq[k].i =  16'sd100 + k;
            seq[k].q = -16'sd50  - k;
            got = iq_t'(seq[k]);          // trivially round-trips
            assert (got == seq[k]) else $fatal(1, "iq round-trip mismatch k=%0d", k);
        end
        $display("INFO: pack/unpack (bit-cast) round-trips OK (pixel_t, iq_t)");

        // ---- 2) push the IQ sequence THROUGH the generic FIFO ------
        // write phase (FIFO has room: NIQ <= DEPTH)
        iq_sink.tready = 0;
        for (int k = 0; k < NIQ; k++) begin
            iq_src.tdata  = seq[k];
            iq_src.tlast  = (k == NIQ-1);
            iq_src.tvalid = 1;
            do @(posedge clk); while (!iq_src.tready);
        end
        iq_src.tvalid = 0;

        // read phase: inspect head (tready=0), then pulse tready to pop
        for (int k = 0; k < NIQ; k++) begin
            do @(posedge clk); while (!iq_sink.tvalid);
            got = iq_sink.tdata;
            assert (got == seq[k])
                else $fatal(1, "IQ FIFO data/order mismatch k=%0d", k);
            if (k == NIQ-1)
                assert (iq_sink.tlast) else $fatal(1, "IQ FIFO lost tlast");
            iq_sink.tready = 1;
            @(posedge clk);
            iq_sink.tready = 0;
        end
        $display("INFO: IQ stream passed through generic FIFO (32-bit) OK");

        // ---- 3) confirm the pixel pipeline is moving data ----------
        repeat (40) @(posedge clk);
        assert (beats > 0)  else $fatal(1, "pixel pipeline produced no beats");
        assert (sof_seen)   else $fatal(1, "no start-of-frame observed");
        $display("INFO: pixel pipeline beats = %0d", beats);

        $display("=== PIPELINE (generic FIFO / packed structs) PASSED ===");
        $stop;     // pause (no GUI close prompt); batch .do then quits
    end
endmodule
