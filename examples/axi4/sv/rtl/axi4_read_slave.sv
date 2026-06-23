`timescale 1ns/1ps
// =====================================================================
// axi4_read_slave.sv - read-only AXI4 slave (sub-channel example)
// =====================================================================
// Demonstrates the slave-side sub-channel paradigm: this module uses
// only the read-side sink modport (ar_sink) to receive read requests
// and the source modport (r_src) to respond with data.  It has zero
// write-channel logic or signals.  A write slave would use aw_sink +
// w_sink + b_src.
//
// Ports:
//   ar      — Read Address channel (axi4_if.ar_sink) — Rx
//   r       — Read Data channel    (axi4_if.r_src)   — Tx
//
// Each modport carries only its own channel's signals + clock/reset,
// so a module that only handles reads never sees AW, W, B, or their
// signals.
// =====================================================================
module axi4_read_slave #(
    parameter int DATA_W  = 32,
    parameter int ADDR_W  = 32,
    parameter int ID_W    = 4,
    parameter int DEPTH   = 256
) (
    axi4_if.ar_sink ar,        // read address sink   (Rx)
    axi4_if.r_src   r          // read data source    (Tx)
);
    localparam int AW = $clog2(DEPTH);

    // Pre-initialized read-only data pattern for demonstration.
    // Each address contains {8'hC0 + addr, 24'(addr + 1)} so reads
    // return a predictable pattern distinct from the write slave's.
    logic [DATA_W-1:0] mem [DEPTH];

    // Initialize with a recognizable pattern
    initial begin
        for (int i = 0; i < DEPTH; i++)
            mem[i] = {8'(8'hC0 + i[7:0]), 24'(i + 1)};
    end

    // ---- Read FSM ------------------------------------------------------
    typedef enum logic [1:0] {
        R_IDLE, R_DATA
    } rstate_t;

    rstate_t rstate = R_IDLE;
    logic [AW-1:0]   raddr;
    logic [7:0]      rcnt;
    logic [ID_W-1:0] rid_latched;

    assign ar.arready = (rstate == R_IDLE);

    always_ff @(posedge ar.aclk or negedge ar.aresetn) begin
        if (!ar.aresetn) begin
            rstate <= R_IDLE;
            raddr  <= '0;
            rcnt   <= '0;
        end else begin
            case (rstate)
                R_IDLE:
                    if (ar.arvalid && ar.arready) begin
                        raddr       <= ar.araddr[AW-1:0];
                        rid_latched <= ar.arid;
                        rcnt        <= ar.arlen;
                        rstate      <= R_DATA;
                    end
                R_DATA: begin
                    if (r.rvalid && r.rready) begin
                        raddr <= raddr + 1'b1;
                        if (rcnt > 0) rcnt <= rcnt - 1'b1;
                    end
                    if (r.rvalid && r.rready && (rcnt == 0))
                        rstate <= R_IDLE;
                end
                default: rstate <= R_IDLE;
            endcase
        end
    end

    // ---- Read data path ------------------------------------------------
    assign r.rdata = mem[raddr];
    assign r.rid   = rid_latched;
    assign r.rresp = 2'b00;
    assign r.ruser = '0;

    logic rvalid_r;
    always_ff @(posedge ar.aclk or negedge ar.aresetn) begin
        if (!ar.aresetn) begin
            rvalid_r <= 1'b0;
        end else if (rstate == R_DATA && !rvalid_r) begin
            rvalid_r <= 1'b1;
        end else if (r.rready && (rcnt == 0)) begin
            rvalid_r <= 1'b0;
        end
    end
    assign r.rvalid = rvalid_r;
    assign r.rlast  = (rcnt == 0);
endmodule
