`timescale 1ns/1ps
// =====================================================================
// top.sv - AXI4-Lite demo top level (full master + full slave)
// =====================================================================
// Instantiates the bus interface, the AXI4-Lite master test sequencer,
// and the AXI4-Lite register-file slave.  Clock and reset flow through
// the interface to both sub-modules.
//
// Interface demo: a single `axilite_if` bus instance carries all 5 AXI
// channels.  The master drives the `bus.master` modport and the slave
// responds on `bus.slave`.  See top_sub.sv for channel-split usage.
// =====================================================================
module top #(
  parameter int DATA_W = 32,
  parameter int ADDR_W = 32,
  parameter int USER_W = 0,
  parameter int DEPTH  = 256
) (
  input  logic                aclk,
  input  logic                aresetn,
  output logic [DATA_W-1:0]   rd_data,    // read data from current beat
  output logic                rd_valid,   // strobe: rd_data captured
  output logic                done
);
  // One interface instance carries all AXI4-Lite signals between master and slave
  axilite_if #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .USER_W(USER_W)) bus (.aclk, .aresetn);

  // AXI4-Lite master -- test sequencer FSM
  // Drives the write+read sequence on the bus.master modport.
  axilite_master #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .USER_W(USER_W))
    u_master (
      .m         (bus.master),
      .rd_data,
      .rd_valid,
      .done
    );

  // AXI4-Lite slave -- register-file memory
  // Responds to transactions from the master on the bus.slave modport.
  axilite_slave #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .USER_W(USER_W), .DEPTH(DEPTH))
    u_slave (.s(bus.slave));
endmodule
