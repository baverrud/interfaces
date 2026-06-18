`timescale 1ns/1ps
// =====================================================================
// stream_fifo.sv - bundles payload + all sidebands into one FIFO word
// =====================================================================
// Sideband parameters MUST match the connected axis_if instances.
// Disabled sidebands are 1-bit safe-width stubs driven by constant 0 at
// the source; synthesis constant-propagates them OUT of the FIFO RAM, so
// they cost no storage (verified: struct packs tighter than hand-sliced
// exact-width words at LUTRAM depths).
// Clock/reset are taken from the interface (s.aclk / s.aresetn).
// =====================================================================
module stream_fifo #(
    parameter type PAYLOAD_T   = logic [31:0],
    parameter int  DEPTH       = 16,
    parameter bit  HAS_TLAST   = 0,
    parameter int  TUSER_WIDTH = 0,
    parameter int  TID_WIDTH   = 0,
    parameter int  TDEST_WIDTH = 0,
    parameter int  TKEEP_WIDTH = 0,
    parameter int  TSTRB_WIDTH = 0
) (
    axis_if.slave  s,        // receiver side: data flows IN
    axis_if.master m         // transmitter side: data flows OUT
);
    localparam int USER_W = (TUSER_WIDTH > 0) ? TUSER_WIDTH : 1;
    localparam int ID_W   = (TID_WIDTH   > 0) ? TID_WIDTH   : 1;
    localparam int DEST_W = (TDEST_WIDTH > 0) ? TDEST_WIDTH : 1;
    localparam int KEEP_W = (TKEEP_WIDTH > 0) ? TKEEP_WIDTH : 1;
    localparam int STRB_W = (TSTRB_WIDTH > 0) ? TSTRB_WIDTH : 1;

    typedef struct packed {
        logic              tlast;
        logic [USER_W-1:0] tuser;
        logic [ID_W-1:0]   tid;
        logic [DEST_W-1:0] tdest;
        logic [KEEP_W-1:0] tkeep;
        logic [STRB_W-1:0] tstrb;
        PAYLOAD_T          data;
    } word_t;

    word_t din, dout;
    logic  full, empty;

    // write side: bundle payload + all sidebands
    assign din.tlast = s.tlast;
    assign din.tuser = s.tuser;
    assign din.tid   = s.tid;
    assign din.tdest = s.tdest;
    assign din.tkeep = s.tkeep;
    assign din.tstrb = s.tstrb;
    assign din.data  = s.tdata;
    assign s.tready  = !full;

    // read side: unbundle payload + all sidebands
    assign m.tdata  = dout.data;
    assign m.tlast  = dout.tlast;
    assign m.tuser  = dout.tuser;
    assign m.tid    = dout.tid;
    assign m.tdest  = dout.tdest;
    assign m.tkeep  = dout.tkeep;
    assign m.tstrb  = dout.tstrb;
    assign m.tvalid = !empty;

    sync_fifo #(.T(word_t), .DEPTH(DEPTH)) u_fifo (
        .clk   (s.aclk),
        .rst   (!s.aresetn),     // async-low -> sync-high for sync_fifo
        .wr_en (s.tvalid), .din, .full,
        .rd_en (m.tready), .dout, .empty
    );
endmodule
