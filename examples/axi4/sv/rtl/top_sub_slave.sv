`timescale 1ns/1ps
// =====================================================================
// top_sub_slave.sv - AXI4 full sub-channel demo (master + slave split)
// =====================================================================
// Demonstrates BOTH master-side and slave-side sub-channel modports.
// Four independent modules share a single axi4_if bus, each connected
// only to the channels they need:
//
// Interface demo: this is the most granular arrangement.  Every AXI
// sub-module is an independent entity connected to its own dedicated
// modport.  The bus instance (`axi4_if`) internally routes the five
// channel pairs so that all four modules communicate without a central
// arbiter.
//
//   write_master ── aw_src ─┐
//                  ── w_src ─┤
//                  ── b_sink─┤
//                            ├── axi4_if bus
//   read_master  ── ar_src ─┤
//                  ── r_sink─┘
//                            ├── axi4_if bus
//   write_slave  ── aw_sink─┐
//                  ── w_sink─┤
//                  ── b_src──┤
//                            ├── axi4_if bus
//   read_slave   ── ar_sink─┐
//                  ── r_src──┘
//
// The write master writes BURST_LEN words, then the read master reads
// from a different address (served by the read slave).  The write and
// read slaves are independent — they do not share memory.
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
  // One interface instance carries all AXI4 signals
  axi4_if #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W)) bus (.aclk, .aresetn);

  // ---- Sequencing signals --------------------------------------------
  logic       init_done;
  logic       wr_done;
  logic       rd_done;
  logic       wr_start;

  // ---- Write master (master-side split) ------------------------------
  // Uses only write-side sub-channels: aw_src + w_src + b_sink
  axi4_write_master #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W),
            .BURST_LEN(BURST_LEN))
    u_wr_master (
      .aw    (bus.aw_src),
      .w     (bus.w_src),
      .b     (bus.b_sink),
      .start (wr_start),
      .done  (wr_done)
    );

  // ---- Read master (master-side split) -------------------------------
  // Uses only read-side sub-channels: ar_src + r_sink
  axi4_read_master #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W),
             .BURST_LEN(BURST_LEN))
    u_rd_master (
      .ar      (bus.ar_src),
      .r       (bus.r_sink),
      .start   (wr_done),
      .done    (rd_done),
      .rd_data,
      .rd_valid
    );

  // ---- Write slave (slave-side split) --------------------------------
  // Uses only write-side sub-channels: aw_sink + w_sink + b_src
  axi4_write_slave #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W),
             .DEPTH(DEPTH))
    u_wr_slave (
      .aw (bus.aw_sink),
      .w  (bus.w_sink),
      .b  (bus.b_src)
    );

  // ---- Read slave (slave-side split) ---------------------------------
  // Uses only read-side sub-channels: ar_sink + r_src
  axi4_read_slave #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W),
            .DEPTH(DEPTH))
    u_rd_slave (
      .ar (bus.ar_sink),
      .r  (bus.r_src)
    );

  // ---- Start sequencing ----------------------------------------------
  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      init_done <= 1'b0;
      wr_start  <= 1'b0;
    end else begin
      if (!init_done) begin
        init_done <= 1'b1;
        wr_start  <= 1'b1;
      end else begin
        wr_start <= 1'b0;
      end
    end
  end

  assign done = rd_done;
endmodule
