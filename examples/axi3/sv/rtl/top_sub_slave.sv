`timescale 1ns/1ps
// =====================================================================
// top_sub_slave.sv - AXI3 full sub-channel demo (master + slave split)
// =====================================================================
// Demonstrates BOTH master-side and slave-side sub-channel modports.
// Four independent modules share a single axi3_if bus, each connected
// only to the channels they need.
// =====================================================================
module top_sub_slave #(
  parameter int DATA_W    = 32,
  parameter int ADDR_W    = 32,
  parameter int ID_W      = 4,
  parameter int BURST_LEN = 4,
  parameter int DEPTH     = 256
) (
  input  logic                aclk,
  input  logic                aresetn,
  output logic [DATA_W-1:0]   rd_data,
  output logic                rd_valid,
  output logic                done
);
  axi3_if #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W)) bus (.aclk, .aresetn);

  logic init_done, wr_done, rd_done, wr_start;

  axi3_write_master #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W),
            .BURST_LEN(BURST_LEN))
    u_wr_master (
      .aw(bus.aw_src), .w(bus.w_src), .b(bus.b_sink),
      .start(wr_start), .done(wr_done));

  axi3_read_master #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W),
             .BURST_LEN(BURST_LEN))
    u_rd_master (
      .ar(bus.ar_src), .r(bus.r_sink),
      .start(wr_done), .done(rd_done), .rd_data, .rd_valid);

  axi3_write_slave #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W),
             .DEPTH(DEPTH))
    u_wr_slave (.aw(bus.aw_sink), .w(bus.w_sink), .b(bus.b_src));

  axi3_read_slave #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W),
            .DEPTH(DEPTH))
    u_rd_slave (.ar(bus.ar_sink), .r(bus.r_src));

  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin init_done <= 1'b0; wr_start <= 1'b0; end
    else begin
      if (!init_done) begin init_done <= 1'b1; wr_start <= 1'b1; end
      else wr_start <= 1'b0;
    end
  end
  assign done = rd_done;
endmodule
