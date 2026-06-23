`timescale 1ns/1ps
// =====================================================================
// axi4_write_master.sv - write-only AXI4 master (sub-channel example)
// =====================================================================
// Demonstrates the sub-channel modport paradigm: this module uses only
// the write-side modports (aw_src, w_src, b_sink) and has zero read-
// channel logic or signals.  A read master would use ar_src + r_sink.
//
// Ports:
//   aw  — Write Address channel (axi4_if.aw_src) — Tx
//   w   — Write Data channel    (axi4_if.w_src)   — Tx
//   b   — Write Response channel (axi4_if.b_sink)  — Rx
//   start   — pulse to begin a write burst
//   done    — asserted when the write transaction (incl. B response) completes
//
// Each modport carries only its own channel's signals + clock/reset,
// so a module that only writes never sees AR, R, or their signals.
// =====================================================================
module axi4_write_master #(
    parameter int DATA_W    = 32,
    parameter int ADDR_W    = 32,
    parameter int ID_W      = 4,
    parameter int BURST_LEN = 4
) (
    axi4_if.aw_src aw,        // write address source  (Tx)
    axi4_if.w_src  w,         // write data source     (Tx)
    axi4_if.b_sink b,         // write response sink   (Rx)
    input  logic              start,
    output logic              done
);
    localparam logic [7:0] AXLEN = 8'(BURST_LEN - 1);

    // ---- FSM -----------------------------------------------------------
    // 5 states: S_IDLE(0), S_AW(1), S_WRITE(2), S_B(3), S_DONE(4) — needs 3 bits
    typedef enum logic [2:0] {
        S_IDLE, S_AW, S_WRITE, S_B, S_DONE
    } state_t;

    state_t state = S_IDLE;
    logic [7:0] beat_cnt;

    always_ff @(posedge aw.aclk or negedge aw.aresetn) begin
        if (!aw.aresetn) begin
            state <= S_IDLE;
            done  <= 1'b0;
            aw.awvalid <= 1'b0;
            w.wvalid   <= 1'b0;
            b.bready   <= 1'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    if (start) begin
                        state    <= S_AW;
                        beat_cnt <= '0;
                    end
                end

                S_AW: begin
                    aw.awaddr  <= 32'h0000_1000;  // write target address
                    if (!aw.awvalid) aw.awvalid <= 1'b1;
                    if (aw.awvalid && aw.awready) begin
                        state    <= S_WRITE;
                        beat_cnt <= '0;
                    end
                end

                S_WRITE: begin
                    if (!w.wvalid) begin
                        w.wvalid <= 1'b1;
                        w.wstrb  <= '1;
                        w.wlast  <= (BURST_LEN == 1);
                        w.wdata  <= {8'(8'hB0 + beat_cnt), 24'(beat_cnt + 1)};
                    end else if (w.wvalid && w.wready) begin
                        if (beat_cnt == AXLEN) begin
                            state <= S_B;
                        end else begin
                            beat_cnt <= beat_cnt + 1'b1;
                            w.wdata  <= {8'(8'hB0 + beat_cnt + 1), 24'(beat_cnt + 2)};
                            w.wlast  <= (beat_cnt + 1 == AXLEN);
                        end
                    end
                end

                S_B: begin
                    if (!b.bready) b.bready <= 1'b1;
                    if (b.bvalid && b.bready) begin
                        // Deassert stale valid signals so the slave
                        // W-before-AW path does not capture a spurious
                        // write data beat after write completes.
                        w.wvalid   <= 1'b0;
                        aw.awvalid <= 1'b0;
                        state <= S_DONE;
                    end
                end

                S_DONE: begin
                    done     <= 1'b1;
                    // Final deassert for clean repeated-start
                    aw.awvalid <= 1'b0;
                    w.wvalid   <= 1'b0;
                    b.bready   <= 1'b0;
                end

                default: state <= S_IDLE;
            endcase
        end
    end

    // ---- Default tie-offs (write address) ------------------------------
    assign aw.awid     = '0;
    assign aw.awlen    = AXLEN;
    assign aw.awsize   = 3'b010;
    assign aw.awburst  = 2'b01;
    assign aw.awlock   = 1'b0;
    assign aw.awcache  = 4'b0;
    assign aw.awprot   = 3'b0;
    assign aw.awqos    = 4'b0;
    assign aw.awregion = 4'b0;
    assign aw.awuser   = '0;

    // ---- Default tie-offs (write data) ---------------------------------
    assign w.wuser     = '0;
endmodule
