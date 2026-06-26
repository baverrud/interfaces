// =====================================================================
// sbi_target.sv - single-register SBI target
// =====================================================================
// Responds to write and read transactions at address 0.
// Ready is asserted for one cycle when CS is active.
// =====================================================================
module sbi_target #(
  parameter int DATA_W = 32,
  parameter int ADDR_W = 8
) (
  input  logic       clk, rstn,           // clock and reset (active low)
  sbi_if.target      s                    // SBI target modport
);
  logic [DATA_W-1:0] reg0;                 // single register at addr 0

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      reg0    <= '0;
      s.rdata <= '0;
      s.ready <= 0;
    end else begin
      s.ready <= 0;                        // default: not ready (one-cycle pulse)
      s.rdata <= reg0;                     // registered read data (available next cycle)
      if (s.cs) begin                      // chip select active
        s.ready <= 1;                      // single-cycle ready
        if (s.wr) begin
          reg0 <= s.wdata;                 // write: capture data
        end
      end
    end
  end
endmodule
