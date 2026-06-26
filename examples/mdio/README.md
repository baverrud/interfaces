# MDIO Examples

IEEE 802.3 Clause 22 MDIO register write/read: manager writes 16-bit
value 0xA5A5 to PHY register, then reads it back and verifies.

## Interface

The MDIO interface (`mdio_if.sv` / `mdio_pkg.vhd`) implements the
IEEE 802.3 Clause 22 Management Data I/O protocol:
- `mdc`: Management Data Clock (driven by the station management entity)
- `mdio`: Management Data I/O (bidirectional, open-drain with pull-up)
- Frame format: 32-bit serial frame (preamble + start + op + PHY addr + reg addr + turn-around + data)
- Clause 22 supports up to 32 PHYs and 32 registers per PHY

### Frame Format

| Field | Bits | Description |
|-------|------|-------------|
| PRE | 32 | Preamble (ones) |
| ST | 2 | Start (01) |
| OP | 2 | Operation: 01=write, 10=read |
| PHY_ADDR | 5 | PHY device address |
| REG_ADDR | 5 | Register address |
| TA | 2 | Turn-around (Z for read, 10 for write) |
| DATA | 16 | Register data |

## Block Diagram

```
  top
  +---------------------------+
  | mdio_manager --bus.mgr----|
  |                (mdio_if)  |
  |   mdio_phy   --bus.phy----|
  +---------------------------+
```

## Design

| Module | File (SV) | File (VHDL) | Port | Description |
|--------|-----------|-------------|------|-------------|
| `mdio_manager` | `sv/rtl/master.sv` | `vhdl/rtl/master.vhd` | `mdio_if.manager` | Write 0xA5A5, read back, verify |
| `mdio_phy` | `sv/rtl/slave.sv` | `vhdl/rtl/slave.vhd` | `mdio_if.phy` | Shadow register at address 0x01 |
| `top` | `sv/rtl/top.sv` | `vhdl/rtl/top.vhd` | — | Wires manager + PHY via the MDIO interface |

The manager clocks out a Clause 22 write frame (preamble → start →
write op → PHY addr 0x01 → reg addr 0x01 → TA → data 0xA5A5), then
issues a read frame for the same register and compares the result.

## Files

| Path | Contents |
|------|----------|
| `sv/rtl/master.sv` | MDIO manager: Clause 22 write then read FSM |
| `sv/rtl/slave.sv` | MDIO PHY: shadow register at address 0x01 |
| `sv/rtl/top.sv` | Clean top: interface + manager + PHY |
| `sv/tb/top_tb.sv` | Self-checking testbench |
| `vhdl/` | VHDL-2019 equivalents using mode views |
| `sv/sources.f` | Source manifest for build system |

## Running

```powershell
cd examples/mdio/sv
.\sim.bat top_tb        # Questa/ModelSim
.\sim.bat top_tb xsim    # Vivado xsim
```
