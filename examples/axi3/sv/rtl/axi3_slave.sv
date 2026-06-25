`timescale 1ns/1ps
// =====================================================================
// axi3_slave.sv - AXI3 register-file slave (full slave modport)
// =====================================================================
// Implements a register-file memory that handles both write and read
// burst transactions.  AXI3-specific: wid is handled on the write data
// channel, and awlock/arlock are 2-bit.
// =====================================================================
module axi3_slave #(
  parameter int DATA_W  = 32,
  parameter int ADDR_W  = 32,
  parameter int ID_W    = 4,
  parameter int DEPTH   = 256
) (
  axi3_if.slave s
);
  localparam int AW = $clog2(DEPTH);

  logic [DATA_W-1:0] mem [DEPTH];

  // ---- Write FSM -----------------------------------------------------
  typedef enum logic [1:0] { W_IDLE, W_DATA, W_RESP } wstate_t;
  wstate_t wstate = W_IDLE;
  logic [AW-1:0]     waddr;
  logic [7:0]        wcnt;
  logic [ID_W-1:0]   wid;
  logic              bvalid_r;

  // Early-data pipeline (handles W before AW edge case)
  logic [DATA_W-1:0]   wdata_early;
  logic [DATA_W/8-1:0] wstrb_early;
  logic                wdata_pending;

  assign s.awready = (wstate == W_IDLE);
  assign s.wready  = (wstate == W_IDLE || wstate == W_DATA);

  always_ff @(posedge s.aclk or negedge s.aresetn) begin
    if (!s.aresetn) begin
      wstate <= W_IDLE; wdata_pending <= 1'b0;
      waddr <= '0; wcnt <= '0; bvalid_r <= 1'b0;
    end else begin
      case (wstate)
        W_IDLE: begin
          if (s.wvalid && s.wready && !wdata_pending) begin
            wdata_early <= s.wdata; wstrb_early <= s.wstrb; wdata_pending <= 1'b1; end
          if (s.awvalid && s.awready) begin
            wid <= s.awid; wcnt <= s.awlen; waddr <= s.awaddr[AW-1:0];
            if (wdata_pending) begin
              for (int i = 0; i < DATA_W/8; i++)
                if (wstrb_early[i])
                  mem[{s.awaddr[AW-1:0]}][8*i +: 8] <= wdata_early[8*i +: 8];
              waddr <= s.awaddr[AW-1:0] + 1'b1; wdata_pending <= 1'b0; end
            wstate <= (s.awlen == 0) ? W_RESP : W_DATA; end
        end
        W_DATA: begin
          if (s.wvalid && s.wready) begin
            for (int i = 0; i < DATA_W/8; i++)
              if (s.wstrb[i]) mem[waddr][8*i +: 8] <= s.wdata[8*i +: 8];
            waddr <= waddr + 1'b1;
            if (s.wlast) wstate <= W_RESP; end
        end
        W_RESP: if (bvalid_r && s.bready) wstate <= W_IDLE;
      endcase
    end
  end

  always_ff @(posedge s.aclk or negedge s.aresetn) begin
    if (!s.aresetn) bvalid_r <= 1'b0;
    else if (wstate == W_RESP && !bvalid_r) bvalid_r <= 1'b1;
    else if (s.bready) bvalid_r <= 1'b0;
  end

  assign s.bvalid = bvalid_r;
  assign s.bid    = wid;
  assign s.bresp  = 2'b00;
  assign s.buser  = '0;

  // ---- Read FSM ------------------------------------------------------
  typedef enum logic [1:0] { R_IDLE, R_DATA } rstate_t;
  rstate_t rstate = R_IDLE;
  logic [AW-1:0]     raddr;
  logic [7:0]        rcnt;
  logic [ID_W-1:0]   rid_latched;
  logic              rlast_r, rvalid_r;

  assign s.arready = (rstate == R_IDLE);

  always_ff @(posedge s.aclk or negedge s.aresetn) begin
    if (!s.aresetn) begin rstate <= R_IDLE; raddr <= '0; rcnt <= '0; end
    else begin
      case (rstate)
        R_IDLE: if (s.arvalid && s.arready) begin
          raddr <= s.araddr[AW-1:0]; rid_latched <= s.arid;
          rcnt <= s.arlen; rstate <= R_DATA; end
        R_DATA: begin
          if (rvalid_r && s.rready) begin raddr <= raddr + 1'b1; if (rcnt > 0) rcnt <= rcnt - 1'b1; end
          if (rvalid_r && s.rready && (rcnt == 0)) rstate <= R_IDLE; end
        default: rstate <= R_IDLE;
      endcase
    end
  end

  assign rlast_r = (rcnt == 0);
  assign s.rdata = mem[raddr];
  assign s.rid   = rid_latched;
  assign s.rresp = 2'b00;
  assign s.ruser = '0;

  always_ff @(posedge s.aclk or negedge s.aresetn) begin
    if (!s.aresetn) rvalid_r <= 1'b0;
    else if (rstate == R_DATA && !rvalid_r) rvalid_r <= 1'b1;
    else if (s.rready && rlast_r) rvalid_r <= 1'b0;
  end
  assign s.rvalid = rvalid_r;
  assign s.rlast  = rlast_r;
endmodule
