# SBI -- VHDL-2019 Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/initiator.vhd` | SBI initiator FSM: write then read |
| `rtl/target.vhd` | SBI target: single register with registered rdata |
| `rtl/top.vhd` | Top level: instantiates interface + initiator + target |
| `tb/top_tb.vhd` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
