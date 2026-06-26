# APB Examples

APB4 register-file demonstration in SystemVerilog (`sv/`) and VHDL-2019
(`vhdl/`).  A testbench writes 0xA5 to address 0, reads it back, and
checks the result.

## Interface

The APB interface (`apb_if.sv` / `apb_pkg.vhd`) uses a two-phase handshake:
SETUP (PSEL=1, PENABLE=0) followed by ACCESS (PSEL=1, PENABLE=1).
Clock and reset are **not** part of the interface — they are separate
ports (unlike AXI-style interfaces).

## Block Diagram

```
  testbench
     |
     | pclk, prstn
     v
  top
  +----------------------------+
  |  apb_master  --bus.master--|
  |                (apb_if)    |
  |  apb_slave   --bus.slave---|
  +----------------------------+
```

## Design

| Module | File (SV) | File (VHDL) | Port | Description |
|--------|-----------|-------------|------|-------------|
| `apb_master` | `rtl/master.sv` | `rtl/master.vhd` | `apb_if.master` | Test sequencer: write 0xA5 to addr 0, read back, assert done |
| `apb_slave` | `rtl/slave.sv` | `rtl/slave.vhd` | `apb_if.slave` | Single-register file at address 0 (3-state FSM) |
| `top` | `rtl/top.sv` | `rtl/top.vhd` | — | Wires master+slave via the APB interface |

The top instantiates the APB interface, the master (drives the bus),
and the slave (responds to transactions).

## Files

| Path | Contents |
|------|----------|
| `sv/rtl/master.sv` | APB master FSM: write 0xA5 then read back |
| `sv/rtl/slave.sv` | APB slave FSM: IDLE → SETUP → ACCESS |
| `sv/rtl/top.sv` | Clean top: instantiates interface + master + slave |
| `sv/tb/top_tb.sv` | Self-checking testbench |
| `vhdl/` | VHDL-2019 equivalents using mode views |
| `sv/sources.f` | Source manifest for build system |

## Running

```powershell
cd examples/apb/sv
.\sim.bat top_tb        # Questa/ModelSim
.\sim.bat top_tb xsim    # Vivado xsim
.\synth.bat top          # Vivado synthesis
```

For VHDL, replace `sv` with `vhdl`:

```powershell
cd examples/apb/vhdl
.\sim.bat top_tb
```

### Python dispatcher (cross-platform)

```powershell
python ../../common/scripts/engine.py sim . top_tb
python ../../common/scripts/engine.py synth . top
```

## Prerequisites

See the root `README.md` for tool setup instructions.
