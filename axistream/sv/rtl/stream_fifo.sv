// =====================================================================
// stream_fifo.sv - interface wrapper around the type-generic FIFO
// =====================================================================
// Bundles {tlast, payload} into one packed struct and stores it in the
// type-generic sync_fifo. Works for ANY payload via the 'type T' param;
// no manual bit slicing - the packed struct does the concatenation.
// =====================================================================
module stream_fifo #(
    parameter type T     = logic,
    parameter int  DEPTH = 16
) (
    input logic clk,
    input logic rst,
    axis_if.rx  s,        // receiver side: data flows IN
    axis_if.tx  m         // transmitter side: data flows OUT
);
    typedef struct packed {
        logic tlast;
        T     data;
    } word_t;

    word_t din, dout;
    logic  wr_en, rd_en, full, empty;

    // write side
    assign din.tlast = s.tlast;
    assign din.data  = s.tdata;
    assign wr_en     = s.tvalid;
    assign s.tready  = !full;

    // read side
    assign m.tdata   = dout.data;
    assign m.tlast   = dout.tlast;
    assign m.tvalid  = !empty;
    assign rd_en     = m.tready;

    sync_fifo #(.T(word_t), .DEPTH(DEPTH)) u_fifo (
        .clk, .rst,
        .wr_en, .din, .full,
        .rd_en, .dout, .empty
    );
endmodule
