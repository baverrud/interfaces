# CAN -- SystemVerilog Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/master.sv` | CAN controller: simulates frame start (dominant/toggle/recessive) |
| `rtl/slave.sv` | CAN transceiver: reflects controller TX to RX |
| `rtl/top.sv` | Top level: instantiates interface + controller + transceiver |
| `tb/top_tb.sv` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
