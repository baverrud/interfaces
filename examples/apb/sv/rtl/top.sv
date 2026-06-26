// =====================================================================
// top.sv - APB demo: producer writes, consumer stores, producer reads
// =====================================================================
// Clean top level — instantiates the APB interface, a producer
// (write-then-read test sequencer), and a consumer (register slave).
// Clock and reset are separate ports (the APB interface doesn't carry
// them — only AXI-style interfaces embed clock/reset).
// =====================================================================
module top #(
  parameter int DATA_W = 32,
  parameter int ADDR_W = 32
) (
  input  logic              pclk,           // APB clock
  input  logic              prstn,          // APB reset (active low)
  output logic [DATA_W-1:0] rd_data,        // read data from producer
  output logic              rd_valid,       // strobe: rd_data valid this cycle
  output logic              done            // write+read sequence complete
);
  // APB interface instance: connects producer (master) to consumer (slave)
  apb_if #(.DATA_W(DATA_W), .ADDR_W(ADDR_W)) bus ();

  // Producer: test sequencer — writes 0xA5 to address 0, reads it back
  apb_master #(.DATA_W(DATA_W), .ADDR_W(ADDR_W)) u_prod (
    .pclk, .prstn,
    .m       (bus.master),
    .rd_data, .rd_valid, .done
  );

  // Consumer: single-register slave at address 0
  apb_slave #(.DATA_W(DATA_W), .ADDR_W(ADDR_W)) u_cons (
    .pclk, .prstn,
    .s       (bus.slave)
  );
endmodule
