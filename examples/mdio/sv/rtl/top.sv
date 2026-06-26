// =====================================================================
// top.sv - MDIO demo: manager writes, PHY reads back
// =====================================================================
module top #(
  parameter logic [4:0]  PHY_ADDR = 5'h01,
  parameter logic [4:0]  REG_ADDR = 5'h01,
  parameter logic [15:0] WR_DATA  = 16'hA5A5
) (
  input  logic clk,
  input  logic rstn,
  output logic done
);

  mdio_if bus ();

  mdio_manager #(
    .PHY_ADDR(PHY_ADDR),
    .REG_ADDR(REG_ADDR),
    .WR_DATA (WR_DATA)
  ) u_mast (
    .clk, .rstn,
    .m    (bus.manager),
    .done (done)
  );

  mdio_phy u_phy (
    .clk, .rstn,
    .s    (bus.phy)
  );

endmodule
