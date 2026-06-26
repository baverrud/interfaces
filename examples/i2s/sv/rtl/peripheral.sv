// =====================================================================
// i2s_peripheral.sv - I2S peripheral (CODEC side)
// =====================================================================
// Generates BCLK (clk/2) and LRCLK (BCLK/64); echoes received
// tx_data/tx_valid back as rx_data/rx_valid.
// =====================================================================
module i2s_peripheral (
  input  logic       clk,             // system clock
  input  logic       rstn,            // active-low reset
  i2s_if.slave       s                // slave modport (bclk/lrclk=output,
                                       //   tx_data/tx_valid=input,
                                       //   rx_data/rx_valid=output)
);

  // ---- clock divider for BCLK/LRCLK generation ------------------
  logic [5:0] div;

  // Generate BCLK (clk/2) and LRCLK (BCLK/64)
  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      div     <= 0;
      s.bclk  <= 0;
      s.lrclk <= 0;
    end else begin
      s.bclk  <= div[0];               // BCLK = clk/2
      s.lrclk <= div[5];               // LRCLK = BCLK/64
      div     <= div + 1;
    end
  end

  // ---- loopback: echo received tx_data/tx_valid as rx_data/rx_valid
  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      s.rx_data  <= 0;
      s.rx_valid <= 0;
    end else begin
      s.rx_data  <= s.tx_data;         // echo sample
      s.rx_valid <= s.tx_valid;        // echo strobe
    end
  end

endmodule
