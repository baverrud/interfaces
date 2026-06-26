// =====================================================================
// wishbone_slave.sv - single-register Wishbone slave
// =====================================================================
// Responds to write and read transactions at address 0 with a
// single-cycle acknowledge.  Read data (dat_i) is driven via
// combinatorial assign so it's valid in the same cycle as ack.
// =====================================================================
module wishbone_slave #(
  parameter int DATA_W = 32,
  parameter int ADDR_W = 32
) (
  input  logic         clk, rstn,          // clock and reset (active low)
  wishbone_if.slave    s                   // Wishbone slave modport
);
  logic [DATA_W-1:0] reg0;                 // single register at addr 0

  // Combinatorial: drive read data (always valid — last read or zero)
  assign s.dat_i = reg0;

  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      reg0  <= '0;
      s.ack <= 0;                          // no acknowledge
      s.err <= 0;                          // no error
    end else begin
      s.ack <= 0;                          // default: no ack (pulse)
      if (s.stb && s.cyc) begin            // valid transaction
        s.ack <= 1;                        // single-cycle acknowledge
        if (s.we) begin
          reg0 <= s.dat_o;                 // write: capture data
        end
      end
    end
  end
endmodule
