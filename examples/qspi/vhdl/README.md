# QSPI -- VHDL-2019 Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/master.vhd` | QSPI master: writes 0xA5 (2 nibbles), reads back, verifies |
| `rtl/slave.vhd` | QSPI slave: shadow register (2×4-bit capture, 2×4-bit echo) |
| `rtl/top.vhd` | Top level: instantiates interface + master + slave |
| `tb/top_tb.vhd` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
