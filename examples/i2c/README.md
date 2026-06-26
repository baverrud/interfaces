# I2C Examples

Full I2C write+read test: master writes byte 0xA5 to slave at address
0x50, then reads it back via a repeated START.  SCL/SDA use open-drain
signals with external pull-up resistors.

## Design

| Module | Port | Description |
|--------|------|-------------|
| `i2c_master` | `i2c_if.master` | Write 0xA5, repeated START, read back, verify |
| `i2c_slave` | `i2c_if.slave` | Shadow register at address 0x50 |

## Running

```powershell
cd examples/i2c/sv
.\sim.bat top_tb
```
