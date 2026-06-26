// =====================================================================
// top.sv - Wishbone demo: master -> slave
// =====================================================================
// Clean top: instantiates the Wishbone interface, a master (write
// 0xA5 then read back), and a slave (single register).  Clock/reset
// are separate ports because the interface doesn't carry them.
// =====================================================================
module top #(parameter DATA_W=32,ADDR_W=32) (
  input  logic              clk, rstn,
  output logic [DATA_W-1:0] rd_data,
  output logic              rd_valid,
  output logic              done
);
  wishbone_if #(.DATA_W(DATA_W),.ADDR_W(ADDR_W)) bus ();
  wishbone_master #(.DATA_W(DATA_W),.ADDR_W(ADDR_W)) u_mast (
    .clk,.rstn,.m(bus.master),.rd_data,.rd_valid,.done
  );
  wishbone_slave #(.DATA_W(DATA_W),.ADDR_W(ADDR_W)) u_slav (
    .clk,.rstn,.s(bus.slave)
  );
endmodule
