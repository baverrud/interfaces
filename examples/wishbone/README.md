# Wishbone Examples

Wishbone B4 register-file demonstration in SystemVerilog (`sv/`) and
VHDL-2019 (`vhdl/`).  A testbench writes 0xA5 to address 0, reads it
back, and checks the result.

## Interface

The Wishbone interface (`wishbone_if.sv` / `wishbone_pkg.vhd`) uses a
classic strobe+ack handshake:
- Master drives STB, CYC, WE, address, and data
- Slave responds with ACK (one-cycle pulse)
- Read data is combinatorial from the register file

## Block Diagram

```
  top
  +----------------------------+
  | wishbone_master --bus.mstr-|
  |                 (wishbone) |
  | wishbone_slave  --bus.slv--|
  +----------------------------+
```

## Design

| Module | File (SV) | File (VHDL) | Port | Description |
|--------|-----------|-------------|------|-------------|
| `wishbone_master` | `rtl/master.sv` | `rtl/master.vhd` | `wishbone_if.master` | Test sequencer: write 0xA5, read back, assert done |
| `wishbone_slave` | `rtl/slave.sv` | `rtl/slave.vhd` | `wishbone_if.slave` | Single-register file at address 0 |
| `top` | `rtl/top.sv` | `rtl/top.vhd` | — | Wires master+slave via the Wishbone interface |

## Files

| Path | Contents |
|------|----------|
| `sv/rtl/master.sv` | Wishbone master FSM: write then read |
| `sv/rtl/slave.sv` | Wishbone slave: register with combinatorial dat_i |
| `sv/rtl/top.sv` | Clean top: interface + master + slave |
| `sv/tb/top_tb.sv` | Self-checking testbench |
| `vhdl/` | VHDL-2019 equivalents using mode views |
| `sv/sources.f` | Source manifest for build system |

## Running

```powershell
cd examples/wishbone/sv
.\sim.bat top_tb        # Questa/ModelSim
.\sim.bat top_tb xsim    # Vivado xsim
.\synth.bat top          # Vivado synthesis
```

For VHDL, replace `sv` with `vhdl`.

```powershell
cd examples/wishbone/vhdl
.\sim.bat top_tb
```
