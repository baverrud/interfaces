// =====================================================================
// top.sv - SBI demo: initiator -> target
// =====================================================================
// Clean top: instantiates the SBI interface, an initiator (write 0xA5
// then read back), and a target (single register).
// =====================================================================
module top #(parameter DATA_W=32,ADDR_W=8) (
  input  logic              clk, rstn,
  output logic [DATA_W-1:0] rd_data,
  output logic              rd_valid,
  output logic              done
);
  sbi_if #(.ADDR_W(ADDR_W),.DATA_W(DATA_W)) bus ();
  sbi_initiator #(.DATA_W(DATA_W),.ADDR_W(ADDR_W)) u_init (
    .clk,.rstn,.m(bus.initiator),.rd_data,.rd_valid,.done
  );
  sbi_target #(.DATA_W(DATA_W),.ADDR_W(ADDR_W)) u_targ (
    .clk,.rstn,.s(bus.target)
  );
endmodule
