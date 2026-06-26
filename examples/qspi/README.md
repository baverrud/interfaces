# QSPI Examples

QSPI register write/read: master writes byte 0xA5 as two 4-bit nibbles
(MSB first, 2 SCLK cycles), then reads them back via io_i and verifies.

## Interface

The QSPI interface (`qspi_if.sv` / `qspi_pkg.vhd`) extends classic SPI
with bidirectional I/O lines:
- Master drives SCLK, CS, and uses `io_o`/`io_oe` for output data
- Slave drives `io_i` during read phases
- Data is transmitted as 4-bit nibbles (one nibble per SCLK cycle)
- All I/O lines are combinatorial (no registered tristate)

## Block Diagram

```
  top
  +---------------------------+
  |  qspi_master --bus.master-|
  |                (qspi_if)  |
  |  qspi_slave  --bus.slave--|
  +---------------------------+
```

## Design

| Module | File (SV) | File (VHDL) | Port | Description |
|--------|-----------|-------------|------|-------------|
| `qspi_master` | `sv/rtl/master.sv` | `vhdl/rtl/master.vhd` | `qspi_if.master` | Writes 0xA5 (2 nibbles), reads back, verifies |
| `qspi_slave` | `sv/rtl/slave.sv` | `vhdl/rtl/slave.vhd` | `qspi_if.slave` | Shadow register (2×4-bit capture, 2×4-bit echo) |
| `top` | `sv/rtl/top.sv` | `vhdl/rtl/top.vhd` | — | Wires master+slave via the QSPI interface |

The master transmits byte 0xA5 as two 4-bit nibbles (high nibble first)
over 2 SCLK cycles.  For the read phase, the slave drives its nibble on
`io_i` while the master reads it combinatorially on the same cycle.

## Files

| Path | Contents |
|------|----------|
| `sv/rtl/master.sv` | QSPI master FSM: write then read |
| `sv/rtl/slave.sv` | QSPI slave: shadow register |
| `sv/rtl/top.sv` | Clean top: interface + master + slave |
| `sv/tb/top_tb.sv` | Self-checking testbench |
| `vhdl/` | VHDL-2019 equivalents using mode views |
| `sv/sources.f` | Source manifest for build system |

## Running

```powershell
cd examples/qspi/sv
.\sim.bat top_tb        # Questa/ModelSim
.\sim.bat top_tb xsim    # Vivado xsim
```
