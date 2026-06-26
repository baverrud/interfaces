# QSPI Examples

QSPI register write/read: master writes byte 0xA5 as two 4-bit nibbles
(MSB first, 2 SCLK cycles), then reads them back via io_i and verifies.

## Design

| Module | Port | Description |
|--------|------|-------------|
| `qspi_master` | `qspi_if.master` | Writes 0xA5 (2 nibbles), reads it back, verifies |
| `qspi_slave` | `qspi_if.slave` | Shadow register (2×4-bit capture, 2×4-bit echo) |

## Running

```powershell
cd examples/qspi/sv
.\sim.bat top_tb
```
