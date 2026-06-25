`timescale 1ns/1ps
// =====================================================================
// axi3_write_slave.sv - write-only AXI3 slave (sub-channel example)
// =====================================================================
// Handles AXI3 write transactions only.  AXI3-specific: wid is present
// on the write data channel.
// =====================================================================
module axi3_write_slave #(
  parameter int DATA_W  = 32,
  parameter int ADDR_W  = 32,
  parameter int ID_W    = 4,
  parameter int DEPTH   = 256
) (
  axi3_if.aw_sink aw,
  axi3_if.w_sink  w,
  axi3_if.b_src   b
);
  localparam int AW = $clog2(DEPTH);

  logic [DATA_W-1:0] mem [DEPTH];

  typedef enum logic [1:0] { W_IDLE, W_DATA, W_RESP } wstate_t;
  wstate_t wstate = W_IDLE;
  logic [AW-1:0]     waddr;
  logic [7:0]        wcnt;
  logic [ID_W-1:0]   wid;
  logic              bvalid_r;

  assign aw.awready = (wstate == W_IDLE);
  assign w.wready   = (wstate == W_IDLE || wstate == W_DATA);

  always_ff @(posedge aw.aclk or negedge aw.aresetn) begin
    if (!aw.aresetn) begin
      wstate <= W_IDLE; waddr <= '0; wcnt <= '0; bvalid_r <= 1'b0;
    end else begin
      case (wstate)
        W_IDLE: if (aw.awvalid && aw.awready) begin
          wid <= aw.awid; wcnt <= aw.awlen; waddr <= aw.awaddr[AW-1:0];
          wstate <= (aw.awlen == 0) ? W_RESP : W_DATA; end
        W_DATA: if (w.wvalid && w.wready) begin
          for (int i = 0; i < DATA_W/8; i++)
            if (w.wstrb[i]) mem[waddr][8*i +: 8] <= w.wdata[8*i +: 8];
          waddr <= waddr + 1'b1;
          if (w.wlast) wstate <= W_RESP; end
        W_RESP: if (bvalid_r && b.bready) wstate <= W_IDLE;
      endcase
    end
  end

  always_ff @(posedge aw.aclk or negedge aw.aresetn) begin
    if (!aw.aresetn) bvalid_r <= 1'b0;
    else if (wstate == W_RESP && !bvalid_r) bvalid_r <= 1'b1;
    else if (b.bready) bvalid_r <= 1'b0;
  end

  assign b.bvalid = bvalid_r;
  assign b.bid    = wid;
  assign b.bresp  = 2'b00;
  assign b.buser  = '0;
endmodule
