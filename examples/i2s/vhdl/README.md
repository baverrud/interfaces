# I2S -- VHDL-2019 Example

See `../README.md` for design description and usage.

## Files

| File | Description |
|------|-------------|
| `rtl/controller.vhd` | I2S controller (CPU/DSP side): generates audio samples |
| `rtl/peripheral.vhd` | I2S peripheral (CODEC side): captures and echoes samples |
| `rtl/top.vhd` | Top level: instantiates interface + controller + peripheral |
| `tb/top_tb.vhd` | Self-checking testbench |
| `sim.bat` | Run simulation (Questa or Vivado xsim) |
| `sources.f` | Source manifest for build system |
