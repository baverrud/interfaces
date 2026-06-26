// =====================================================================
// top.sv - I2S demo: controller -> peripheral
// =====================================================================
// Clean top level: instantiates the I2S interface, a controller
// (sends audio sample to codec), and a peripheral (echoes back).
// =====================================================================
module top (
  input  logic clk,
  input  logic rstn,
  output logic done
);

  // ---- I2S interface instance (24-bit audio samples) ------------
  i2s_if #(.DATA_W(24)) bus ();

  // ---- controller (CPU/DSP): sends 0xA5A5A5 via tx_data/tx_valid --
  i2s_controller u_ctrl (
    .clk, .rstn,
    .m    (bus.master),
    .done (done)
  );

  // ---- peripheral (CODEC): generates BCLK/LRCLK, echoes sample --
  i2s_peripheral u_per (
    .clk, .rstn,
    .s    (bus.slave)
  );
endmodule
