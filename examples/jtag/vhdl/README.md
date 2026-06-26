# JTAG -- VHDL-2019 Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/controller.vhd` | JTAG controller: drives TCK/TMS/TDI through 16-state TAP FSM |
| `rtl/tap.vhd` | JTAG TAP: 16-state FSM with bypass register |
| `rtl/top.vhd` | Top level: instantiates interface + controller + TAP |
| `tb/top_tb.vhd` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
