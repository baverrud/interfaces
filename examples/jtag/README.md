# JTAG (IEEE 1149.1) Examples

## Overview

JTAG is a serial interface for test and debug, originally developed for
boundary-scan testing of PCBs.  The interface consists of four (or five)
signals:

| Signal | Direction (TAP side) | Purpose |
|--------|---------------------|---------|
| `TCK` | Input | Test clock |
| `TMS` | Input | Test mode select |
| `TDI` | Input | Test data in |
| `TDO` | Output | Test data out |
| `TRST` | Input (optional) | Test reset |

The device being tested contains a **TAP** (Test Access Port) controller
— a 16-state finite state machine that transitions on the rising edge
of TCK based on the TMS signal.

## Design

### Architecture

```
top
 ├── jtag_if bus (tap modport ─── tap modport)
 │    │                            │
 │    ├── tck (output) ──────────►│ (input)
 │    ├── tms (output) ──────────►│ (input)
 │    ├── tdi (output) ──────────►│ (input)
 │    └── tdo (input)  ◄─────────┤ (output)
 │
 ├── jtag_controller  (connects to tap modport)
 └── jtag_tap         (connects to tap modport)
```

Both modules connect to the same `tap` modport — the controller drives
TCK/TMS/TDI, the TAP reads them and drives TDO.

### Controller (`jtag_controller`)

Generates TCK (clk/2) and sequences TMS through the JTAG state machine:

| TCK cycle | TMS | TAP state transition |
|-----------|-----|----------------------|
| 1–5 | 1 | Stay in Test-Logic-Reset |
| 6 | 0 | → Run-Test/Idle |
| 7 | 1 | → Select-DR-Scan |
| 8 | 0 | → Capture-DR |
| 9 | 0 | → Shift-DR |
| 10 | 0→1 | Stay in Shift-DR (shift 1 bit), then → Exit1-DR |
| 11 | 1 | → Update-DR |
| 12 | 0 | → Run-Test/Idle |

In Shift-DR, the controller drives TDI = 1.  The bypass register
captures this bit; TDO reflects the bypass register value.

### TAP (`jtag_tap`)

Implements the full IEEE 1149.1 16-state TAP controller:

```
              ┌─────┐
              │ TLR │◄──── TMS=1
              └──┬──┘
           TMS=0 │
              ┌──┴──┐
         ┌───►│ RTI │
         │    └──┬──┘
         │ TMS=0 │ TMS=1
         │   ┌───┴────┐
         │   │ SEL_DR │───→ SEL_IR → ...
         │   └───┬────┘
         │ TMS=0 │ TMS=1
         │   ┌───┴────┐
         │   │ CAP_DR │
         │   └───┬────┘
         │ TMS=0 │ TMS=1
         │   ┌───┴────┐
         │   │SHIFT_DR│──→ (bypass: shift TDI→TDO)
         │   └───┬────┘
         │ TMS=0 │ TMS=1
         │   ┌───┴────┐
         │   │EXIT1_DR│
         │   └───┬────┘
         │ TMS=0 │ TMS=1
         │   ┌───┴────┐
         │   │UPD_DR  │──────────────┘
         │   └────────┘
         └───────────── TMS=0
```

**Bypass register** (1-bit):
- On `Capture-DR`: loads `0`
- On `Shift-DR`: samples TDI on TCK rising edge, drives TDO on
  TCK falling edge

### Test Flow

1. Controller holds TAP in Test-Logic-Reset for 5 TCK cycles
2. Sequences to Shift-DR via Run-Test/Idle → Select-DR → Capture-DR
3. Shifts 1 bit (TDI=1) through the bypass register
4. Exits Shift-DR → Update-DR → Run-Test/Idle
5. Asserts done (the bypass path is verified by TDO capturing the
   shifted-in bit)

## Interface Details

### SystemVerilog (`jtag_if`)

```systemverilog
interface jtag_if #(parameter bit HAS_TRST = 0);
  logic tck, tms, tdi, tdo, trst;

  modport tap (
    input  tck, tms, tdi, trst,
    output tdo
  );
endinterface
```

There is only one modport (`tap`).  Both controller and TAP connect
to it — the controller drives the inputs and reads TDO, the TAP reads
the inputs and drives TDO.

### VHDL-2019 (`jtag_pkg`)

```vhdl
type jtag_t is record
  tck, tms, tdi, tdo, trst : std_logic;
end record;

view tap of jtag_t is
  tck, tms, tdi, trst : in;
  tdo : out;
end view;

alias controller is tap'converse;      -- tck/tms/tdi=out, tdo=in
```

## Simulation

### Running

```powershell
# SystemVerilog
cd examples/jtag/sv
.\sim.bat top_tb

# VHDL-2019
cd examples/jtag/vhdl
.\sim.bat top_tb
```

### Expected Output

```
# === JTAG PASSED ===
#    Time: 335 ns
# Errors: 0, Warnings: 0
```

## Files

| Path | Description |
|------|-------------|
| `sv/rtl/controller.sv` | JTAG controller (TAP sequencer) |
| `sv/rtl/tap.sv` | JTAG TAP with 16-state machine and bypass register |
| `sv/rtl/top.sv` | Top-level |
| `sv/tb/top_tb.sv` | Testbench |
| `sv/sources.f` | Source file list |
| `sv/sim.bat` | Simulation launcher |
| `vhdl/rtl/controller.vhd` | JTAG controller (VHDL-2019) |
| `vhdl/rtl/tap.vhd` | JTAG TAP (VHDL-2019) |
| `vhdl/rtl/top.vhd` | Top-level (VHDL-2019) |
| `vhdl/tb/top_tb.vhd` | Testbench (VHDL-2019) |
| `vhdl/sources.f` | Source file list |
| `vhdl/sim.bat` | Simulation launcher |

## See Also

- [`lib/sv/jtag_if.sv`](../../lib/sv/jtag_if.sv) — SV interface definition
- [`lib/vhdl/jtag_pkg.vhd`](../../lib/vhdl/jtag_pkg.vhd) — VHDL-2019 package
