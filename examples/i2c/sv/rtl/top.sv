// =====================================================================
// top.sv - I2C demo: master writes 0xA5, reads it back
// =====================================================================
module top #(
  parameter logic [6:0] DEV_ADDR = 7'h50
) (
  input  logic clk,
  input  logic rstn,
  output logic done
);

  i2c_if bus ();

  i2c_master #(.DEV_ADDR(DEV_ADDR)) u_mast (
    .clk, .rstn,
    .m    (bus.master),
    .done (done)
  );

  i2c_slave u_slav (
    .clk, .rstn,
    .s    (bus.slave)
  );

endmodule
