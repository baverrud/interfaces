# QSPI -- SystemVerilog Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/master.sv` | QSPI master: writes 0xA5 (2 nibbles), reads back, verifies |
| `rtl/slave.sv` | QSPI slave: shadow register (2×4-bit capture, 2×4-bit echo) |
| `rtl/top.sv` | Top level: instantiates interface + master + slave |
| `tb/top_tb.sv` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
