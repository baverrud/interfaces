`timescale 1ns/1ps
// =====================================================================
// top_sub.sv - AXI4 sub-channel demo top level
// =====================================================================
// Demonstrates the sub-channel modport paradigm: the write master and
// read master are physically separate modules, each connected only to
// the channels they need.  They share a single axi4_if bus instance
// along with the register-file slave.
//
// Block diagram:
//
//   axi4_write_master ── aw_src ─┐
//                       ── w_src ─┤
//                       ── b_sink─┤
//                                 ├── axi4_if bus ── slave ── axi4_slave
//   axi4_read_master  ── ar_src ─┤
//                       ── r_sink─┘
//
// The write master writes BURST_LEN words, then the read master reads
// them back.  Observability outputs expose the read data for the
// testbench.
// =====================================================================
module top_sub #(
    parameter int DATA_W    = 32,
    parameter int ADDR_W    = 32,
    parameter int ID_W      = 4,
    parameter int BURST_LEN = 4,
    parameter int DEPTH     = 256
) (
    input  logic                aclk,
    input  logic                aresetn,
    output logic [DATA_W-1:0]   rd_data,    // read data from read master
    output logic                rd_valid,   // strobe: rd_data captured
    output logic                done        // asserted when full seq completes
);
    // One interface instance carries all AXI4 signals
    axi4_if #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W)) bus (.aclk, .aresetn);

    // ---- Sequencing logic (declared before use) ------------------------
    // After reset, pulse the write master's start, then wait for it to
    // finish before starting the read master.  The read master's done
    // signal propagates to the top-level done output.
    logic       init_done;       // reset delay complete
    logic       wr_done;         // write master finished
    logic       rd_done;         // read master finished
    logic       wr_done_r;       // registered start for write master

    // Write master — only connects to write-side sub-channels.
    // It has no visibility into read-channel signals (AR, R).
    axi4_write_master #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W),
                        .BURST_LEN(BURST_LEN))
        u_wr_master (
            .aw    (bus.aw_src),     // Write Address source (Tx)
            .w     (bus.w_src),      // Write Data source    (Tx)
            .b     (bus.b_sink),     // Write Response sink  (Rx)
            .start (wr_done_r),      // kick off after reset
            .done  (wr_done)
        );

    // Read master — only connects to read-side sub-channels.
    // It has no visibility into write-channel signals (AW, W, B).
    axi4_read_master #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W),
                       .BURST_LEN(BURST_LEN))
        u_rd_master (
            .ar      (bus.ar_src),   // Read Address source  (Tx)
            .r       (bus.r_sink),   // Read Data sink       (Rx)
            .start   (wr_done),      // start read after write completes
            .done    (rd_done),
            .rd_data,
            .rd_valid
        );

    // AXI4 slave — uses the full slave modport (receives all Tx, drives all Rx)
    axi4_slave #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W), .DEPTH(DEPTH))
        u_slave (.s(bus.slave));

    always_ff @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            init_done <= 1'b0;
            wr_done_r <= 1'b0;
        end else begin
            if (!init_done) begin
                init_done <= 1'b1;        // one cycle after deassert
                wr_done_r <= 1'b1;         // kick write master
            end else begin
                wr_done_r <= 1'b0;         // start is a pulse
            end
        end
    end

    assign done = rd_done;
endmodule
