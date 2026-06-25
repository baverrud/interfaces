`timescale 1ns/1ps
// =====================================================================
// top.sv - AXI3 demo top level
// =====================================================================
// Instantiates the bus interface, the AXI3 master test sequencer, and
// the AXI3 register-file slave.  Clock and reset flow through the
// interface to both sub-modules.
//
// Interface demo: a single `axi3_if` bus instance carries all 5 AXI3
// channels.  The master drives the `bus.master` modport and the slave
// responds on `bus.slave`.
// =====================================================================
module top #(
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

  axi3_master #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W),
          .BURST_LEN(BURST_LEN))
    u_master (.m(bus.master), .rd_data, .rd_valid, .done);

  axi3_slave #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W), .DEPTH(DEPTH))
    u_slave (.s(bus.slave));
endmodule
