# Wishbone -- VHDL-2019 Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/master.vhd` | Wishbone master FSM: write then read |
| `rtl/slave.vhd` | Wishbone slave: register with combinatorial dat_i |
| `rtl/top.vhd` | Top level: instantiates interface + master + slave |
| `tb/top_tb.vhd` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
