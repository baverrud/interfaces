# JTAG -- SystemVerilog Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/controller.sv` | JTAG controller: drives TCK/TMS/TDI through 16-state TAP FSM |
| `rtl/tap.sv` | JTAG TAP: 16-state FSM with bypass register |
| `rtl/top.sv` | Top level: instantiates interface + controller + TAP |
| `tb/top_tb.sv` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
