# CAN (Controller Area Network) Examples

## Overview

This example demonstrates the CAN controller-transceiver interface.
The CAN bus uses a differential pair (CAN_H / CAN_L) driven by a
transceiver, but at the digital logic level the interface is just
two signals:

| Signal | Direction | Purpose |
|--------|-----------|---------|
| `tx` | Controller → Transceiver | Transmit data (dominant = 0, recessive = 1) |
| `rx` | Transceiver → Controller | Receive data (bus state reflected back) |

The transceiver converts the digital TX signal to the differential bus
voltage and reflects the bus state back on RX.  The controller handles
the CAN protocol (arbitration, CRC, etc.).

## Design

### Architecture

```
top
 ├── can_if bus (controller ─── transceiver)
 │    │                           │
 │    ├── tx (output) ──────────►│ (input)
 │    └── rx (input)  ◄─────────┤ (output)
 │
 ├── can_master (connects to controller modport)
 └── can_slave  (connects to transceiver modport)
```

### Controller (`can_master`)

Simulates a CAN frame start on TX:

| State | TX | Description |
|-------|----|-------------|
| `IDLE` | 1 (recessive) | Bus idle |
| `DOMINANT` | 0 (dominant) | 4 cycles — simulates SOF + arbitration |
| `TOGGLE` | Toggle | 4 cycles — simulates data/CRC bits |
| `DONE` | 1 (recessive) | Back to idle, assert `done` |

The controller counts 4 cycles per state, then transitions to the next.

### Transceiver (`can_slave`)

A real CAN transceiver (e.g., SN65HVD230, TJA1050) simply buffers
the controller's TX to the differential bus and reflects the bus
state back on RX.  This model implements that loopback with one
clock cycle of propagation delay:

```
s.rx <= s.tx    -- TX → bus → RX (buffered)
```

## Interface Details

### SystemVerilog (`can_if`)

```systemverilog
interface can_if;
  logic tx;
  logic rx;

  modport controller (
    output tx,        // controller drives TX
    input  rx         // controller reads RX
  );
  modport transceiver (
    input  tx,        // transceiver reads TX from controller
    output rx         // transceiver drives RX with bus state
  );
endinterface
```

### VHDL-2019 (`can_pkg`)

```vhdl
type can_t is record
  tx : std_logic;
  rx : std_logic;
end record;

view controller of can_t is
  tx : out;
  rx : in;
end view;

alias transceiver is controller'converse;
```

No record constraints needed — both elements are `std_logic` scalars.

## Simulation

### Running

```powershell
# SystemVerilog
cd examples/can/sv
.\sim.bat top_tb

# VHDL-2019
cd examples/can/vhdl
.\sim.bat top_tb
```

### Expected Output

```
# === CAN PASSED ===
#    Time: 145 ns
# Errors: 0, Warnings: 0
```

## Files

| Path | Description |
|------|-------------|
| `sv/rtl/master.sv` | CAN controller (frame sequencer) |
| `sv/rtl/slave.sv` | CAN transceiver (loopback) |
| `sv/rtl/top.sv` | Top-level |
| `sv/tb/top_tb.sv` | Testbench |
| `sv/sources.f` | Source file list |
| `sv/sim.bat` | Simulation launcher |
| `vhdl/rtl/master.vhd` | CAN controller (VHDL-2019) |
| `vhdl/rtl/slave.vhd` | CAN transceiver (VHDL-2019) |
| `vhdl/rtl/top.vhd` | Top-level (VHDL-2019) |
| `vhdl/tb/top_tb.vhd` | Testbench (VHDL-2019) |
| `vhdl/sources.f` | Source file list |
| `vhdl/sim.bat` | Simulation launcher |

## See Also

- [`lib/sv/can_if.sv`](../../lib/sv/can_if.sv) — SV interface definition
- [`lib/vhdl/can_pkg.vhd`](../../lib/vhdl/can_pkg.vhd) — VHDL-2019 package
