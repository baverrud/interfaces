# SPI -- SystemVerilog Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/master.sv` | SPI master: writes 0xA5, reads it back, verifies |
| `rtl/slave.sv` | SPI slave: shadow register (write capture, read echo) |
| `rtl/top.sv` | Top level: instantiates interface + master + slave |
| `tb/top_tb.sv` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
