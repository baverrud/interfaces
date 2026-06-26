// =====================================================================
// can_slave.sv - CAN transceiver (physical-layer loopback)
// =====================================================================
// A real CAN transceiver buffers the controller's TX to the
// differential CAN_H/CAN_L bus, and reflects the bus state back
// on RX.  This model implements that loopback with one clock
// cycle of propagation delay.
// =====================================================================
module can_slave (
  input  logic         clk,            // system clock
  input  logic         rstn,           // active-low reset
  can_if.transceiver   s               // transceiver modport (tx=input, rx=output)
);

  // The transceiver simply passes TX to RX (buffered, one cycle delay).
  // In a real system the delay is tens of ns; here it's one clk cycle.
  always_ff @(posedge clk or negedge rstn) begin
    if (!rstn) begin
      s.rx <= 1;                       // default recessive
    end else begin
      s.rx <= s.tx;                    // TX → bus → RX loopback
    end
  end

endmodule
