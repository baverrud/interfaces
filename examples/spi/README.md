# SPI Examples

SPI register write/read: master writes byte 0xA5 to the slave's shadow
register (8 SCLK cycles, MSB first), then reads it back and verifies.

## Interface

The SPI interface (`spi_if.sv` / `spi_pkg.vhd`) uses the classic 4-wire
SPI signalling:
- Master drives SCLK (serial clock), MOSI (master-out, slave-in), and CS (chip select, active-low)
- Slave drives MISO (master-in, slave-out)
- Data is captured on the rising edge of SCLK and driven on the falling edge

## Block Diagram

```
  top
  +---------------------------+
  |  spi_master  --bus.master-|
  |                (spi_if)   |
  |  spi_slave   --bus.slave--|
  +---------------------------+
```

## Design

| Module | File (SV) | File (VHDL) | Port | Description |
|--------|-----------|-------------|------|-------------|
| `spi_master` | `sv/rtl/master.sv` | `vhdl/rtl/master.vhd` | `spi_if.master` | Writes 0xA5, reads it back, verifies match |
| `spi_slave` | `sv/rtl/slave.sv` | `vhdl/rtl/slave.vhd` | `spi_if.slave` | Shadow register (write capture, read echo) |
| `top` | `sv/rtl/top.sv` | `vhdl/rtl/top.vhd` | — | Wires master+slave via the SPI interface |

The master sequences 8 SCLK cycles: it drives MOSI with the MSB-first
data on falling edges while the slave captures on rising edges.  For the
read phase, the slave drives MISO on falling edges and the master
captures on a dedicated capture cycle after each SCLK edge.

## Files

| Path | Contents |
|------|----------|
| `sv/rtl/master.sv` | SPI master FSM: write then read |
| `sv/rtl/slave.sv` | SPI slave: shadow register |
| `sv/rtl/top.sv` | Clean top: interface + master + slave |
| `sv/tb/top_tb.sv` | Self-checking testbench |
| `vhdl/` | VHDL-2019 equivalents using mode views |
| `sv/sources.f` | Source manifest for build system |

## Running

```powershell
cd examples/spi/sv
.\sim.bat top_tb        # Questa/ModelSim
.\sim.bat top_tb xsim    # Vivado xsim
```
