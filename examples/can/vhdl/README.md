# CAN -- VHDL-2019 Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/master.vhd` | CAN controller: simulates frame start (dominant/toggle/recessive) |
| `rtl/slave.vhd` | CAN transceiver: reflects controller TX to RX |
| `rtl/top.vhd` | Top level: instantiates interface + controller + transceiver |
| `tb/top_tb.vhd` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
