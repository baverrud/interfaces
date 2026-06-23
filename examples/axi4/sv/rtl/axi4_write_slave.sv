`timescale 1ns/1ps
// =====================================================================
// axi4_write_slave.sv - write-only AXI4 slave (sub-channel example)
// =====================================================================
// Demonstrates the slave-side sub-channel paradigm: this module uses
// only the write-side sink modports (aw_sink, w_sink) to receive writes
// and the source modport (b_src) to respond.  It has zero read-channel
// logic or signals.  A read slave would use ar_sink + r_src.
//
// Ports:
//   aw      — Write Address channel (axi4_if.aw_sink) — Rx
//   w       — Write Data channel    (axi4_if.w_sink)  — Rx
//   b       — Write Response channel (axi4_if.b_src)   — Tx
//
// Each modport carries only its own channel's signals + clock/reset,
// so a module that only handles writes never sees AR, R, or their
// signals.
// =====================================================================
module axi4_write_slave #(
    parameter int DATA_W  = 32,
    parameter int ADDR_W  = 32,
    parameter int ID_W    = 4,
    parameter int DEPTH   = 256
) (
    axi4_if.aw_sink aw,        // write address sink   (Rx)
    axi4_if.w_sink  w,         // write data sink      (Rx)
    axi4_if.b_src   b          // write response source (Tx)
);
    localparam int AW = $clog2(DEPTH);
    localparam int STRB_W = DATA_W / 8;

    logic [DATA_W-1:0] mem [DEPTH];

    // ---- Write FSM -----------------------------------------------------
    typedef enum logic [1:0] {
        W_IDLE, W_DATA, W_RESP
    } wstate_t;

    wstate_t wstate = W_IDLE;
    logic [AW-1:0]   waddr;
    logic [7:0]      wcnt;
    logic [ID_W-1:0] wid;

    assign aw.awready = (wstate == W_IDLE);
    assign w.wready   = (wstate == W_IDLE) || (wstate == W_DATA);

    always_ff @(posedge aw.aclk or negedge aw.aresetn) begin
        if (!aw.aresetn) begin
            wstate <= W_IDLE;
        end else begin
            case (wstate)
                W_IDLE: begin
                    if (aw.awvalid && aw.awready) begin
                        waddr <= aw.awaddr[AW-1:0];
                        wid   <= aw.awid;
                        wcnt  <= aw.awlen;
                        wstate <= (aw.awlen == 0) ? W_RESP : W_DATA;
                    end
                end
                W_DATA: begin
                    if (w.wvalid && w.wready) begin
                        for (int i = 0; i < STRB_W; i++)
                            if (w.wstrb[i])
                                mem[waddr][i*8 +: 8] <= w.wdata[i*8 +: 8];
                        waddr <= waddr + 1'b1;
                        if (w.wlast) wstate <= W_RESP;
                    end
                end
                W_RESP: begin
                    if (b.bvalid && b.bready)
                        wstate <= W_IDLE;
                end
                default: wstate <= W_IDLE;
            endcase
        end
    end

    // ---- Write response ------------------------------------------------
    logic bvalid_r;
    always_ff @(posedge aw.aclk or negedge aw.aresetn) begin
        if (!aw.aresetn) begin
            bvalid_r <= 1'b0;
        end else if (wstate == W_RESP && !bvalid_r) begin
            bvalid_r <= 1'b1;
        end else if (b.bready) begin
            bvalid_r <= 1'b0;
        end
    end
    assign b.bvalid = bvalid_r;
    assign b.bid    = wid;
    assign b.bresp  = 2'b00;
    assign b.buser  = '0;
endmodule
