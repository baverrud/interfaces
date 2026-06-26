# MDIO -- SystemVerilog Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/master.sv` | MDIO manager: writes 0xA5A5, reads back, verifies |
| `rtl/slave.sv` | MDIO PHY: shadow register at address 0x01 |
| `rtl/top.sv` | Top level: instantiates interface + manager + PHY |
| `tb/top_tb.sv` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
