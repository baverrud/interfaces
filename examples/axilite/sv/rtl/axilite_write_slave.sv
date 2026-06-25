`timescale 1ns/1ps
// =====================================================================
// axilite_write_slave.sv - write-only AXI4-Lite slave
// =====================================================================
// Handles AXI4-Lite write transactions only (AW -> W -> B).  Stores
// incoming data into a register file with byte-strobe gating.
//
// AXI4-Lite: single-beat writes, no burst.
// =====================================================================
module axilite_write_slave #(
  parameter int DATA_W  = 32,
  parameter int ADDR_W  = 32,
  parameter int USER_W  = 0,
  parameter int DEPTH   = 256
) (
  axilite_if.aw_sink aw,
  axilite_if.w_sink  w,
  axilite_if.b_src   b
);
  localparam int AW = $clog2(DEPTH);

  logic [DATA_W-1:0] mem [DEPTH];

  typedef enum logic [1:0] { W_IDLE, W_RESP } wstate_t;
  wstate_t wstate = W_IDLE;
  logic [AW-1:0]   waddr;
  logic             aw_seen, w_seen;

  logic awready_r, wready_r;
  assign aw.awready = awready_r;
  assign w.wready   = wready_r;

  always_ff @(posedge aw.aclk or negedge aw.aresetn) begin
    if (!aw.aresetn) begin
      wstate   <= W_IDLE; waddr <= '0;
      aw_seen  <= 1'b0; w_seen <= 1'b0;
      awready_r <= 1'b0; wready_r <= 1'b0;
      b.bvalid <= 1'b0;
    end else begin
      awready_r <= (wstate == W_IDLE && !aw_seen);
      wready_r  <= (wstate == W_IDLE);
      case (wstate)
        W_IDLE: begin
          if (aw.awvalid && awready_r) begin
            aw_seen <= 1'b1;
            waddr   <= aw.awaddr[AW-1:0];
            if (w_seen) begin
              wstate <= W_RESP; aw_seen <= 1'b0; w_seen <= 1'b0;
            end
          end
          if (w.wvalid && wready_r) begin
            w_seen <= 1'b1;
            for (int i = 0; i < DATA_W/8; i++)
              if (w.wstrb[i]) mem[waddr][8*i +: 8] <= w.wdata[8*i +: 8];
            if (aw_seen) begin
              b.bvalid <= 1'b1;
              wstate <= W_RESP; aw_seen <= 1'b0; w_seen <= 1'b0;
            end
          end
        end
        W_RESP: if (b.bready) begin
          b.bvalid <= 1'b0;
          wstate <= W_IDLE;
        end
      endcase
    end
  end
  assign b.bresp  = 2'b00;
  assign b.buser  = '0;
endmodule
