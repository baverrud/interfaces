# UART Examples

Full UART frame echo: transmitter sends byte 0xA5 (start bit + 8 LSB-first
data bits + stop bit), receiver captures and echoes it back.

## Design

| Module   | Port            | Description                               |
|----------|-----------------|-------------------------------------------|
| `uart_tx` | `uart_if.master` | Transmits 0xA5, then listens for echo     |
| `uart_rx` | `uart_if.slave`  | Captures byte, re-transmits it back       |

## Running

```powershell
cd examples/uart/sv
.\sim.bat top_tb
```
