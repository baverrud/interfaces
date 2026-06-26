# I2C -- VHDL-2019 Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/master.vhd` | I2C master: write 0xA5, repeated START, read back, verify |
| `rtl/slave.vhd` | I2C slave: shadow register at address 0x50 |
| `rtl/top.vhd` | Top level: instantiates interface + master + slave |
| `tb/top_tb.vhd` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
