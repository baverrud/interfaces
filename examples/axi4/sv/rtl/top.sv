`timescale 1ns/1ps
// =====================================================================
// top.sv - AXI4 demo top level
// =====================================================================
// Instantiates the bus interface, the AXI4 master test sequencer, and
// the AXI4 register-file slave.  Clock and reset flow through the
// interface to both sub-modules.
//
// Interface demo: a single `axi4_if` bus instance carries all 5 AXI
// channels.  The master drives the `bus.master` modport and the slave
// responds on `bus.slave`.  Because both sub-modules need all channels,
// this uses the full modport pair.  See top_sub.sv for channel-split usage.
//
// Parameters:
//   BURST_LEN — number of beats per write/read burst (default 4)
//   DEPTH     — number of DATA_W words in the slave register file
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
  output logic [DATA_W-1:0]   rd_data,    // read data from current beat
  output logic                rd_valid,   // strobe: rd_data captured
  output logic                done
);
  // One interface instance carries all AXI4 signals between master and slave
  axi4_if #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W)) bus (.aclk, .aresetn);

  // AXI4 master — test sequencer FSM
  // Drives the write+read burst sequence on the bus.master modport.
  axi4_master #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W),
          .BURST_LEN(BURST_LEN))
    u_master (
      .m         (bus.master),
      .rd_data,
      .rd_valid,
      .done
    );

  // AXI4 slave — register-file memory
  // Responds to bursts from the master on the bus.slave modport.
  axi4_slave #(.DATA_W(DATA_W), .ADDR_W(ADDR_W), .ID_W(ID_W), .DEPTH(DEPTH))
    u_slave (.s(bus.slave));
endmodule
