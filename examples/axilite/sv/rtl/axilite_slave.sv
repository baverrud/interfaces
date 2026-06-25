`timescale 1ns/1ps
// =====================================================================
// axilite_slave.sv - parameterized AXI4-Lite register-file slave
// =====================================================================
// Handles single-beat writes (AW -> W -> B) and single-beat reads
// (AR -> R).  DEPTH words of DATA_W bits; AXI4-Lite has no burst, so
// each transaction accesses exactly one word.
//
// Write path: captures W data with byte-strobe gating into memory.
// Read path:  returns the addressed word with RRESP=OKAY.
//
// Uses axilite_if.slave modport for clean port list.
// =====================================================================
module axilite_slave #(
  parameter int DATA_W  = 32,
  parameter int ADDR_W  = 32,
  parameter int USER_W  = 0,
  parameter int DEPTH   = 256
) (
  axilite_if.slave s
);
  localparam int AW = $clog2(DEPTH);  // address bits used internally

  // ---- Register file -------------------------------------------------
  logic [DATA_W-1:0] mem [DEPTH];

  // ---- Write channel FSM --------------------------------------------
  // AXI4-Lite does not mandate ordering between AW and W.
  typedef enum logic [1:0] {
    W_IDLE  = 2'd0,     // waiting for AW and/or W
    W_DATA  = 2'd1,     // receiving W data
    W_RESP  = 2'd2      // sending B response
  } wstate_t;

  wstate_t wstate = W_IDLE;
  logic [AW-1:0]   waddr;
  logic             aw_seen;
  logic awready_r, wready_r;

  assign s.awready = awready_r;
  assign s.wready  = wready_r;

  always_ff @(posedge s.aclk or negedge s.aresetn) begin
    if (!s.aresetn) begin
      wstate     <= W_IDLE;
      aw_seen    <= 1'b0;
      waddr      <= '0;
      awready_r  <= 1'b0;
      wready_r   <= 1'b0;
      s.bvalid   <= 1'b0;
    end else begin
      awready_r <= (wstate == W_IDLE && !aw_seen);
      wready_r  <= (wstate == W_IDLE || wstate == W_DATA);
      case (wstate)
        W_IDLE: begin
          if (s.awvalid && awready_r) begin
            aw_seen <= 1'b1;
            waddr   <= s.awaddr[AW-1:0];
            wstate  <= W_DATA;
          end
        end
        W_DATA: begin
          if (s.wvalid && wready_r) begin
            for (int i = 0; i < DATA_W/8; i++)
              if (s.wstrb[i])
                mem[waddr][i*8 +: 8] <= s.wdata[i*8 +: 8];
            s.bvalid <= 1'b1;
            wstate   <= W_RESP;
          end
        end
        W_RESP: begin
          if (s.bready) begin
            s.bvalid <= 1'b0;
            wstate   <= W_IDLE;
            aw_seen  <= 1'b0;
          end
        end
      endcase
    end
  end

  assign s.bresp = 2'b00;
  assign s.buser = '0;
  assign s.arready = 1'b1;

  // ---- Read path (single-beat) --------------------------------------
  logic rvalid_r;
  always_ff @(posedge s.aclk or negedge s.aresetn) begin
    if (!s.aresetn)
      rvalid_r <= 1'b0;
    else if (s.arvalid && s.arready)
      rvalid_r <= 1'b1;
    else if (s.rready)
      rvalid_r <= 1'b0;
  end
  assign s.rvalid = rvalid_r;
  assign s.rdata  = mem[s.araddr[AW-1:0]];
  assign s.rresp  = 2'b00;
  assign s.ruser  = '0;
endmodule
