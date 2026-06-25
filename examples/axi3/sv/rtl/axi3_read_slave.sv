`timescale 1ns/1ps
// =====================================================================
// axi3_read_slave.sv - read-only AXI3 slave (sub-channel example)
// =====================================================================
// Handles AXI3 read transactions only.  Memory is pre-initialized with
// an incrementing pattern (0xC0+addr) so read data is deterministic.
// =====================================================================
module axi3_read_slave #(
  parameter int DATA_W  = 32,
  parameter int ADDR_W  = 32,
  parameter int ID_W    = 4,
  parameter int DEPTH   = 256
) (
  axi3_if.ar_sink ar,
  axi3_if.r_src   r
);
  localparam int AW = $clog2(DEPTH);

  logic [DATA_W-1:0] mem [DEPTH];

  initial begin
    for (int i = 0; i < DEPTH; i++)
      mem[i] = {8'(8'hC0 + i[7:0]), 24'(i + 1)};
  end

  typedef enum logic [1:0] { R_IDLE, R_DATA } rstate_t;
  rstate_t rstate = R_IDLE;
  logic [AW-1:0]     raddr;
  logic [7:0]        rcnt;
  logic [ID_W-1:0]   rid_latched;

  assign ar.arready = (rstate == R_IDLE);

  always_ff @(posedge ar.aclk or negedge ar.aresetn) begin
    if (!ar.aresetn) begin rstate <= R_IDLE; raddr <= '0; rcnt <= '0; end
    else begin
      case (rstate)
        R_IDLE: if (ar.arvalid && ar.arready) begin
          raddr <= ar.araddr[AW-1:0]; rid_latched <= ar.arid;
          rcnt <= ar.arlen; rstate <= R_DATA; end
        R_DATA: begin
          if (r.rvalid && r.rready) begin raddr <= raddr + 1'b1; if (rcnt > 0) rcnt <= rcnt - 1'b1; end
          if (r.rvalid && r.rready && (rcnt == 0)) rstate <= R_IDLE; end
        default: rstate <= R_IDLE;
      endcase
    end
  end

  assign r.rdata = mem[raddr];
  assign r.rid   = rid_latched;
  assign r.rresp = 2'b00;
  assign r.ruser = '0;

  logic rvalid_r;
  always_ff @(posedge ar.aclk or negedge ar.aresetn) begin
    if (!ar.aresetn) rvalid_r <= 1'b0;
    else if (rstate == R_DATA && !rvalid_r) rvalid_r <= 1'b1;
    else if (r.rready && (rcnt == 0)) rvalid_r <= 1'b0;
  end
  assign r.rvalid = rvalid_r;
  assign r.rlast  = (rcnt == 0);
endmodule
