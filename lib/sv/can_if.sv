`timescale 1ns/1ps
// =====================================================================
// can_if.sv - CAN bus interface (2-wire, dominant/recessive)
// =====================================================================
// TX: transmit (controller -> transceiver)
// RX: receive  (transceiver -> controller)
// The transceiver handles the physical CAN_H/CAN_L differential pair.
// =====================================================================
interface can_if;
  logic tx;                    // transmit (controller -> transceiver)
  logic rx;                    // receive  (transceiver -> controller)

  modport controller (
    output tx,
    input  rx
  );
  modport transceiver (
    input  tx,
    output rx
  );
endinterface
