# I2C Examples

Full I2C write+read test: master writes byte 0xA5 to slave at address
0x50, then reads it back via a repeated START.  SCL/SDA use open-drain
signals with external pull-up resistors.

## Interface

The I2C interface (`i2c_if.sv` / `i2c_pkg.vhd`) models the open-drain
I2C bus with weak pull-up behaviour:
- `scl` / `sda`: **inout** ports driven low by the active device or
  pulled high via `'H'` in VHDL (modelled as pull-up resistors)
- Arbitration: if multiple devices drive the bus simultaneously, a
  device that drives high while the bus is low loses arbitration
- Open-drain means no device ever drives high — they only release
  (let pull-up bring high) or drive low

## Block Diagram

```
  top
  +---------------------------+
  |  i2c_master  --bus.master-|
  |                (i2c_if)   |
  |  i2c_slave   --bus.slave--|
  +---------------------------+
```

## Design

| Module | File (SV) | File (VHDL) | Port | Description |
|--------|-----------|-------------|------|-------------|
| `i2c_master` | `sv/rtl/master.sv` | `vhdl/rtl/master.vhd` | `i2c_if.master` | Write 0xA5, repeated START, read back, verify |
| `i2c_slave` | `sv/rtl/slave.sv` | `vhdl/rtl/slave.vhd` | `i2c_if.slave` | Shadow register at address 0x50 |
| `top` | `sv/rtl/top.sv` | `vhdl/rtl/top.vhd` | — | Wires master+slave via the I2C interface |

The master generates a START condition (SDA low while SCL high),
transmits the slave address + write bit, sends byte 0xA5, then issues a
repeated START followed by the address + read bit.  The slave drives the
read data on SDA while the master acknowledges each byte.

## Files

| Path | Contents |
|------|----------|
| `sv/rtl/master.sv` | I2C master FSM: write with repeated START, read back |
| `sv/rtl/slave.sv` | I2C slave: shadow register at address 0x50 |
| `sv/rtl/top.sv` | Clean top: interface + master + slave |
| `sv/tb/top_tb.sv` | Self-checking testbench |
| `vhdl/` | VHDL-2019 equivalents using mode views |
| `sv/sources.f` | Source manifest for build system |

## Running

```powershell
cd examples/i2c/sv
.\sim.bat top_tb        # Questa/ModelSim
.\sim.bat top_tb xsim    # Vivado xsim
```
