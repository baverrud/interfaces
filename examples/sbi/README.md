# SBI Examples

SBI (Simple Bus Interface) register-file demonstration in SystemVerilog
(`sv/`) and VHDL-2019 (`vhdl/`).  A testbench writes 0xA5 to address 0,
reads it back, and checks the result.

## Interface

The SBI interface (`sbi_if.sv` / `sbi_pkg.vhd`) is a lightweight
register-access protocol:
- Initiator drives CS, WR/RD strobes, address, write data
- Target responds with READY (one-cycle pulse) and read data
- Uses initiator/target naming (instead of master/slave)

## Block Diagram

```
  top
  +----------------------------+
  | sbi_initiator  --bus.init--|
  |                  (sbi_if)  |
  | sbi_target     --bus.targ--|
  +----------------------------+
```

## Design

| Module | File (SV) | File (VHDL) | Port | Description |
|--------|-----------|-------------|------|-------------|
| `sbi_initiator` | `rtl/initiator.sv` | `rtl/initiator.vhd` | `sbi_if.initiator` | Test sequencer: write 0xA5, read back, assert done |
| `sbi_target` | `rtl/target.sv` | `rtl/target.vhd` | `sbi_if.target` | Single-register file at address 0 |
| `top` | `rtl/top.sv` | `rtl/top.vhd` | — | Wires initiator+target via the SBI interface |

## Files

| Path | Contents |
|------|----------|
| `sv/rtl/initiator.sv` | SBI initiator FSM: write then read |
| `sv/rtl/target.sv` | SBI target: single register with registered rdata |
| `sv/rtl/top.sv` | Clean top: interface + initiator + target |
| `sv/tb/top_tb.sv` | Self-checking testbench |
| `vhdl/` | VHDL-2019 equivalents using mode views |
| `sv/sources.f` | Source manifest for build system |

## Running

```powershell
cd examples/sbi/sv
.\sim.bat top_tb        # Questa/ModelSim
.\sim.bat top_tb xsim    # Vivado xsim
.\synth.bat top          # Vivado synthesis
```

For VHDL, replace `sv` with `vhdl`.

```powershell
cd examples/sbi/vhdl
.\sim.bat top_tb
```
