# MDIO Examples

IEEE 802.3 Clause 22 MDIO register write/read: manager writes 16-bit
value 0xA5A5 to PHY register, then reads it back and verifies.

## Design

| Module | Port | Description |
|--------|------|-------------|
| `mdio_manager` | `mdio_if.manager` | Write 0xA5A5, read back, verify |
| `mdio_phy` | `mdio_if.phy` | Shadow register at address 0x01 |

## Running

```powershell
cd examples/mdio/sv
.\sim.bat top_tb
```
