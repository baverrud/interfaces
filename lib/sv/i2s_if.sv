`timescale 1ns/1ps
// =====================================================================
// i2s_if.sv - I2S audio interface (Philips standard)
// =====================================================================
// Parameters:
//   DATA_W = 24 — audio sample width
// =====================================================================
interface i2s_if #(
  parameter int DATA_W = 24
);
  logic bclk;                  // bit clock
  logic lrclk;                 // left/right clock (word select)
  logic [DATA_W-1:0] tx_data;  // transmit data (parallel, one sample)
  logic [DATA_W-1:0] rx_data;  // receive data (parallel, one sample)
  logic tx_valid;              // new sample on tx_data
  logic rx_valid;              // new sample on rx_data

  modport master (
    input  bclk, lrclk,
    output tx_data, tx_valid,
    input  rx_data, rx_valid
  );
  modport slave (
    output bclk, lrclk,
    input  tx_data, tx_valid,
    output rx_data, rx_valid
  );
endinterface
