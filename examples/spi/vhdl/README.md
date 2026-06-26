# SPI -- VHDL-2019 Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/master.vhd` | SPI master: writes 0xA5, reads it back, verifies |
| `rtl/slave.vhd` | SPI slave: shadow register (write capture, read echo) |
| `rtl/top.vhd` | Top level: instantiates interface + master + slave |
| `tb/top_tb.vhd` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
