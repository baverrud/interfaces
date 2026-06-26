# SBI -- SystemVerilog Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/initiator.sv` | SBI initiator FSM: write then read |
| `rtl/target.sv` | SBI target: single register with registered rdata |
| `rtl/top.sv` | Top level: instantiates interface + initiator + target |
| `tb/top_tb.sv` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
