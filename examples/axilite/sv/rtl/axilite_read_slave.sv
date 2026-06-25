`timescale 1ns/1ps
// =====================================================================
// axilite_read_slave.sv - read-only AXI4-Lite slave
// =====================================================================
// Handles AXI4-Lite read transactions only (AR -> R).  Returns the
// addressed word from a pre-loaded register file.
//
// AXI4-Lite: single-beat reads, no burst.
//
// The INIT_DATA parameter writes a constant pattern into all DEPTH
// words during reset, so the read-back is deterministic without
// a separate write phase.
// =====================================================================
module axilite_read_slave #(
  parameter int DATA_W    = 32,
  parameter int ADDR_W    = 32,
  parameter int USER_W    = 0,
  parameter int DEPTH     = 256,
  parameter logic [DATA_W-1:0] INIT_DATA = 32'hC0C0C0C0
) (
  axilite_if.ar_sink ar,
  axilite_if.r_src   r
);
  localparam int AW = $clog2(DEPTH);

  logic [DATA_W-1:0] mem [DEPTH];

  // Pre-initialize memory with the pattern during reset.
  integer i;
  always_ff @(posedge ar.aclk or negedge ar.aresetn) begin
    if (!ar.aresetn) begin
      for (i = 0; i < DEPTH; i++) mem[i] <= INIT_DATA;
    end
  end

  assign ar.arready = 1'b1;

  logic rvalid_r;
  always_ff @(posedge ar.aclk or negedge ar.aresetn) begin
    if (!ar.aresetn)
      rvalid_r <= 1'b0;
    else if (ar.arvalid && ar.arready)
      rvalid_r <= 1'b1;
    else if (r.rready)
      rvalid_r <= 1'b0;
  end

  assign r.rvalid = rvalid_r;
  assign r.rdata  = mem[ar.araddr[AW-1:0]];
  assign r.rresp  = 2'b00;
  assign r.ruser  = '0;
endmodule
