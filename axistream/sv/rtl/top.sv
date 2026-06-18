// =====================================================================
// top.sv - synthesizable top: producer -> stream_fifo -> consumer
// =====================================================================
// Two parameterized interface instances carry pixel_t; the same
// stream_fifo/sync_fifo would serve any other type (see the IQ stream
// exercised in the testbench).
// =====================================================================
module top #(
    parameter int FIFO_DEPTH = 16,
    parameter int LINE       = 8
) (
    input  logic        clk,
    input  logic        rst,
    output logic [7:0]  last_r,
    output logic [7:0]  last_g,
    output logic [7:0]  last_b,
    output logic        last_sof,
    output logic [15:0] beats
);
    import stream_pkg::*;

    axis_if #(.T(pixel_t)) src ();
    axis_if #(.T(pixel_t)) sink ();

    pixel_producer #(.LINE(LINE)) u_prod (
        .clk, .rst, .m(src.tx)
    );

    stream_fifo #(.T(pixel_t), .DEPTH(FIFO_DEPTH)) u_fifo (
        .clk, .rst, .s(src.rx), .m(sink.tx)
    );

    pixel_consumer u_cons (
        .clk, .rst, .s(sink.rx),
        .last_r, .last_g, .last_b, .last_sof, .beats
    );
endmodule
