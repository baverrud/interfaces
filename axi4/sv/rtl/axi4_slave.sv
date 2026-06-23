`timescale 1ns/1ps
// =====================================================================
// axi4_slave.sv - parameterized AXI4 register-file slave
// =====================================================================
// Handles burst writes (AW -> W beats -> B) and burst reads (AR -> R
// beats).  DEPTH words of DATA_W bits; address auto-increments within
// a burst.  Uses axi4_if.slave modport for clean port list.
// =====================================================================
module axi4_slave #(
    parameter int DATA_W  = 32,
    parameter int ADDR_W  = 32,
    parameter int ID_W    = 4,
    parameter int DEPTH   = 256       // number of DATA_W words
) (
    axi4_if.slave s
);
    localparam int AW = $clog2(DEPTH);  // address bits used internally

    // ---- Register file -------------------------------------------------
    logic [DATA_W-1:0] mem [DEPTH];

    // ---- Write channel FSM --------------------------------------------
    // AXI4 does not mandate ordering between AW and W — the master may
    // send write address, write data, or both in any order.  The FSM
    // below handles three scenarios:
    //
    //   1. AW-first (common):  AW arrives, we latch the address, then
    //      wait for W data beats in W_DATA.
    //   2. W-first (spec-compliant): W data arrives before AW.  We
    //      capture it in wdata_early/strobe_early, set wdata_pending,
    //      and stay in W_IDLE.  When AW eventually arrives, we commit
    //      the captured data immediately.
    //   3. Interleaved (for bursts): the first W beat may arrive before
    //      or with AW; remaining beats arrive in W_DATA after AW.
    //
    // Limitation: for multi-beat bursts, only the FIRST W beat can
    // arrive before AW.  A full implementation would use a small FIFO
    // on the early W-data path.
    typedef enum logic [1:0] {
        W_IDLE  = 2'd0,     // waiting for AW and/or first W beat
        W_DATA  = 2'd1,     // receiving W beats (AW already captured)
        W_RESP  = 2'd2      // sending B response
    } wstate_t;

    wstate_t wstate = W_IDLE;
    logic [AW-1:0]   waddr;
    logic [7:0]      wcnt;            // beats remaining in burst
    logic [ID_W-1:0] wid;

    // ---- W-before-AW capture registers --------------------------------
    // When W data arrives before AW (scenario 2), we hold it here until
    // the address arrives.  These are only used in W_IDLE.
    logic [DATA_W-1:0]   wdata_early;
    logic [DATA_W/8-1:0] wstrb_early;
    logic                wdata_pending;   // set when W captured before AW

    // Write-address handshake: ready in W_IDLE only (addresses are always
    // ordered — we only accept one at a time).
    assign s.awready = (wstate == W_IDLE);

    // Write-data handshake: ready in both W_IDLE (for W-before-AW) and
    // W_DATA (normal burst reception).
    assign s.wready  = (wstate == W_IDLE) || (wstate == W_DATA);

    always_ff @(posedge s.aclk or negedge s.aresetn) begin
        if (!s.aresetn) begin
            wstate        <= W_IDLE;
            wdata_pending <= 1'b0;
            waddr         <= '0;
            wcnt          <= '0;
        end else begin
            case (wstate)
                W_IDLE: begin
                    // Capture early W data (W-before-AW).
                    // If more W beats arrive before AW (burst case), the
                    // first is captured here and subsequent beats are
                    // handled when AW transitions us to W_DATA.
                    if (s.wvalid && s.wready && !wdata_pending) begin
                        wdata_early   <= s.wdata;
                        wstrb_early   <= s.wstrb;
                        wdata_pending <= 1'b1;
                    end

                    if (s.awvalid && s.awready) begin
                        wid   <= s.awid;
                        wcnt  <= s.awlen;
                        waddr <= s.awaddr[AW-1:0];

                        if (wdata_pending) begin
                            // W beat arrived before AW — commit it now.
                            // If awlen==0 (single-beat), go straight to
                            // W_RESP.  Otherwise move to W_DATA for the
                            // remaining beats.
                            for (int i = 0; i < DATA_W/8; i++)
                                if (wstrb_early[i])
                                    mem[s.awaddr[AW-1:0]][i*8 +: 8]
                                        <= wdata_early[i*8 +: 8];
                            waddr <= s.awaddr[AW-1:0] + 1'b1;
                            wdata_pending <= 1'b0;
                            wstate <= (s.awlen == 0) ? W_RESP : W_DATA;
                        end else begin
                            // Normal AW-first: wait for W beats.
                            wstate <= (s.awlen == 0) ? W_RESP : W_DATA;
                        end
                    end
                end

                W_DATA: begin
                    // Store write data on each handshake and advance address.
                    // AXI4 allows wvalid before awready; the W-before-AW
                    // path above handles the first beat if it arrived early.
                    if (s.wvalid && s.wready) begin
                        for (int i = 0; i < DATA_W/8; i++)
                            if (s.wstrb[i])
                                mem[waddr][i*8 +: 8] <= s.wdata[i*8 +: 8];
                        waddr <= waddr + 1'b1;
                        if (s.wlast) wstate <= W_RESP;
                    end
                end

                W_RESP: begin
                    if (s.bvalid && s.bready)
                        wstate <= W_IDLE;
                end

                default: wstate <= W_IDLE;
            endcase
        end
    end

    // Write response
    logic bvalid_r;
    always_ff @(posedge s.aclk or negedge s.aresetn) begin
        if (!s.aresetn) begin
            bvalid_r <= 1'b0;
        end else if (wstate == W_RESP && !bvalid_r) begin
            bvalid_r <= 1'b1;
        end else if (s.bready) begin
            bvalid_r <= 1'b0;
        end
    end
    assign s.bvalid = bvalid_r;
    assign s.bid    = wid;
    assign s.bresp  = 2'b00;

    // ---- Read channel FSM ----------------------------------------------
    typedef enum logic [1:0] {
        R_IDLE  = 2'd0,     // waiting for AR handshake
        R_DATA  = 2'd1      // sending R beats
    } rstate_t;

    rstate_t rstate = R_IDLE;
    logic [AW-1:0]   raddr;
    logic [7:0]      rcnt;
    logic [ID_W-1:0] rid_latched;
    logic            rlast_r;

    // Read-address handshake
    assign s.arready = (rstate == R_IDLE);

    always_ff @(posedge s.aclk or negedge s.aresetn) begin
        if (!s.aresetn) begin
            rstate <= R_IDLE;
            raddr  <= '0;
            rcnt   <= '0;
        end else begin
            case (rstate)
                R_IDLE:
                    if (s.arvalid && s.arready) begin
                        raddr       <= s.araddr[AW-1:0];
                        rid_latched <= s.arid;
                        rcnt        <= s.arlen;
                        rstate      <= R_DATA;
                    end
                R_DATA: begin
                    if (s.rvalid && s.rready) begin
                        raddr <= raddr + 1'b1;
                        if (rcnt > 0) rcnt <= rcnt - 1'b1;
                    end
                    if (s.rvalid && s.rready && rlast_r)
                        rstate <= R_IDLE;
                end
                default: rstate <= R_IDLE;
            endcase
        end
    end

    // Read data (combinatorial from register file)
    assign s.rdata = mem[raddr];
    assign s.rid   = rid_latched;
    assign s.rresp = 2'b00;

    logic rvalid_r;
    always_ff @(posedge s.aclk or negedge s.aresetn) begin
        if (!s.aresetn) begin
            rvalid_r <= 1'b0;
        end else if (rstate == R_DATA && !rvalid_r) begin
            rvalid_r <= 1'b1;
        end else if (s.rready && rlast_r) begin
            rvalid_r <= 1'b0;
        end
    end
    assign s.rvalid = rvalid_r;

    assign rlast_r = (rcnt == 0);
    assign s.rlast = rlast_r;

    // ---- Tie off unused sidebands --------------------------------------
    assign s.buser = '0;
    assign s.ruser = '0;
endmodule
