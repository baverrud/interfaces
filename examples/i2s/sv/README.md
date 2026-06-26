# I2S -- SystemVerilog Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/controller.sv` | I2S controller (CPU/DSP side): generates audio samples |
| `rtl/peripheral.sv` | I2S peripheral (CODEC side): captures and echoes samples |
| `rtl/top.sv` | Top level: instantiates interface + controller + peripheral |
| `tb/top_tb.sv` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
