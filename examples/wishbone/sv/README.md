# Wishbone -- SystemVerilog Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/master.sv` | Wishbone master FSM: write then read |
| `rtl/slave.sv` | Wishbone slave: register with combinatorial dat_i |
| `rtl/top.sv` | Top level: instantiates interface + master + slave |
| `tb/top_tb.sv` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
