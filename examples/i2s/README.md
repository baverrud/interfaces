# I2S Examples

I2S audio loopback: controller sends audio sample (0xA5A5A5) to the
peripheral via tx_data/tx_valid.  The peripheral generates BCLK and
LRCLK (divided from the system clock) and echoes the received sample
back via rx_data/rx_valid.

**Note**: The library modports are named `master`/`slave`, but here
`master` is the CPU/DSP side (controller, receives clocks) and
`slave` is the CODEC side (peripheral, generates clocks).

## Design

| Module | Port | Description |
|--------|------|-------------|
| `i2s_controller` | `i2s_if.master` | Transmits 0xA5A5A5, asserts done |
| `i2s_peripheral` | `i2s_if.slave` | Generates BCLK/LRCLK, echoes sample |

## Running

```powershell
cd examples/i2s/sv
.\sim.bat top_tb
```
