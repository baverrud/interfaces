# UART -- SystemVerilog Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/tx.sv` | UART transmitter: sends 0xA5 with start+8+stop framing |
| `rtl/rx.sv` | UART receiver: captures byte, echoes it back |
| `rtl/top.sv` | Top level: instantiates interface + tx + rx |
| `tb/top_tb.sv` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
