# SPI Examples

SPI register write/read: master writes byte 0xA5 to the slave's shadow
register (8 SCLK cycles, MSB first), then reads it back and verifies.

## Design

| Module | Port | Description |
|--------|------|-------------|
| `spi_master` | `spi_if.master` | Writes 0xA5, reads it back, verifies match |
| `spi_slave` | `spi_if.slave` | Shadow register (write capture, read echo) |

## Running

```powershell
cd examples/spi/sv
.\sim.bat top_tb
```
