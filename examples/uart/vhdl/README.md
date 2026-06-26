# UART -- VHDL-2019 Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/tx.vhd` | UART transmitter: sends 0xA5 with start+8+stop framing |
| `rtl/rx.vhd` | UART receiver: captures byte, echoes it back |
| `rtl/top.vhd` | Top level: instantiates interface + tx + rx |
| `tb/top_tb.vhd` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
