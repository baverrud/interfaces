// =====================================================================
// top.sv - JTAG demo: controller sequences TAP through bypass test
// =====================================================================
module top (
  input  logic clk,
  input  logic rstn,
  output logic done
);

  jtag_if #() bus ();

  // ---- controller: drives TCK, TMS, TDI; reads TDO -------------
  jtag_controller u_ctrl (
    .clk, .rstn,
    .m    (bus.tap),
    .done (done)
  );

  // ---- TAP: IEEE 1149.1 state machine + bypass register ---------
  jtag_tap u_tap (
    .clk, .rstn,
    .s    (bus.tap)
  );
endmodule
