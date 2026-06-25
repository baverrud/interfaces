`timescale 1ns/1ps
// =====================================================================
// top_sub.sv - AXI4-Lite sub-channel demo top level
// =====================================================================
// Demonstrates the sub-channel modport paradigm: the write master and
// read master are physically separate modules, each connected only to
// the channels they need.  They share a single axilite_if bus instance
// along with the register-file slave.
//
// Interface demo: the write master connects to `aw_src` + `w_src` +
// `b_sink` (write-side only) while the read master connects to `ar_src`
// + `r_sink` (read-side only).
//
// Block diagram:
//
//   axilite_write_master ── aw_src ─┐
//                        ── w_src ──┤
//                        ── b_sink ──┤
//                                    ├── axilite_if bus ── slave ── axilite_slave
//   axilite_read_master  ── ar_src ──┤
//                        ── r_sink ──┘
//
// The write master writes one word, then the read master reads it back.
// =====================================================================
module top_sub #(
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
  logic       wr_done;         // write master finished
  logic       rd_done;         // read master finished

  // Write master — only connects to write-side sub-channels.
  axilite_write_master #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .USER_W(USER_W))
    u_wr_master (
      .aw    (bus.aw_src),     // Write Address source (Tx)
      .w     (bus.w_src),      // Write Data source    (Tx)
      .b     (bus.b_sink),     // Write Response sink  (Rx)
      .start (1'b1),           // kick off after reset
      .done  (wr_done)
    );

  // Read master — only connects to read-side sub-channels.
  axilite_read_master #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .USER_W(USER_W))
    u_rd_master (
      .ar      (bus.ar_src),   // Read Address source  (Tx)
      .r       (bus.r_sink),   // Read Data sink       (Rx)
      .start   (wr_done),      // start read after write completes
      .done    (rd_done),
      .rd_data,
      .rd_valid
    );

  // AXI4-Lite slave — uses the full slave modport
  axilite_slave #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .USER_W(USER_W), .DEPTH(DEPTH))
    u_slave (.s(bus.slave));

  // Top-level done is asserted when both write and read are complete.
  assign done = rd_done;
endmodule
