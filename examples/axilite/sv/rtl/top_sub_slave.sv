`timescale 1ns/1ps
// =====================================================================
// top_sub_slave.sv - AXI4-Lite full sub-channel demo top level
// =====================================================================
// Demonstrates full sub-channel split on both master and slave sides:
// independent write master, read master, write slave, and read slave.
// Each module connects only to the sub-channel modports it needs.
//
// Block diagram:
//
//   axilite_write_master ── aw_src ─┐
//                        ── w_src ──┤
//                        ── b_sink ──┤
//                                    ├── axilite_if bus
//   axilite_read_master  ── ar_src ──┤
//                        ── r_sink ──┘
//                                    ├── axilite_if bus
//   axilite_write_slave  ── aw_sink─┐
//                        ── w_sink ──┤
//                        ── b_src ───┤
//                                    └── axilite_if bus
//   axilite_read_slave   ── ar_sink─┐
//                        ── r_src ──┘
//
// The write master writes one word, then the read master reads it back.
// The read slave is pre-initialized with a known pattern (0xC0C0C0C0).
// =====================================================================
module top_sub_slave #(
  parameter int DATA_W = 32,
  parameter int ADDR_W = 32,
  parameter int USER_W = 0,
  parameter int DEPTH  = 256
) (
  input  logic                aclk,
  input  logic                aresetn,
  output logic [DATA_W-1:0]   rd_data,    // read data from read master
  output logic                rd_valid,   // strobe: rd_data captured
  output logic                done        // asserted when full seq completes
);
  // One interface instance carries all AXI4-Lite signals
  axilite_if #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .USER_W(USER_W)) bus (.aclk, .aresetn);

  // ---- Sequencing logic ----------------------------------------------
  logic       wr_done;
  logic       rd_done;

  // Write master — write-side sub-channels only.
  axilite_write_master #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .USER_W(USER_W))
    u_wr_master (
      .aw    (bus.aw_src),
      .w     (bus.w_src),
      .b     (bus.b_sink),
      .start (1'b1),
      .done  (wr_done)
    );

  // Read master — read-side sub-channels only.
  axilite_read_master #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .USER_W(USER_W))
    u_rd_master (
      .ar      (bus.ar_src),
      .r       (bus.r_sink),
      .start   (wr_done),
      .done    (rd_done),
      .rd_data,
      .rd_valid
    );

  // Write slave — write-side sub-channels only.
  axilite_write_slave #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .USER_W(USER_W), .DEPTH(DEPTH))
    u_wr_slave (
      .aw (bus.aw_sink),
      .w  (bus.w_sink),
      .b  (bus.b_src)
    );

  // Read slave — read-side sub-channels only, pre-initialized with 0xC0C0C0C0.
  axilite_read_slave #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .USER_W(USER_W), .DEPTH(DEPTH))
    u_rd_slave (
      .ar (bus.ar_sink),
      .r  (bus.r_src)
    );

  // Top-level done.
  assign done = rd_done;
endmodule
