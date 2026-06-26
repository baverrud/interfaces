# UART Examples

Full UART frame echo: transmitter sends byte 0xA5 (start bit + 8 LSB-first
data bits + stop bit), receiver captures and echoes it back.

## Interface

The UART interface (`uart_if.sv` / `uart_pkg.vhd`) models the
asynchronous serial link with classic UART framing:
- `txd`: serial data output (idle-high, driven by transmitter)
- `rxd`: serial data input (idle-high, sampled by receiver)
- Baud rate is controlled by a clock divider (clk / BAUD_DIV)
- Frame format: 1 start bit (low), 8 data bits (LSB first), 1 stop bit (high)

## Block Diagram

```
  top
  +---------------------------+
  |   uart_tx   --bus.master--|
  |               (uart_if)   |
  |   uart_rx   --bus.slave---|
  +---------------------------+
```

## Design

| Module | File (SV) | File (VHDL) | Port | Description |
|--------|-----------|-------------|------|-------------|
| `uart_tx` | `sv/rtl/tx.sv` | `vhdl/rtl/tx.vhd` | `uart_if.master` | Transmits 0xA5, then listens for echo |
| `uart_rx` | `sv/rtl/rx.sv` | `vhdl/rtl/rx.vhd` | `uart_if.slave` | Captures byte, re-transmits it back |
| `top` | `sv/rtl/top.sv` | `vhdl/rtl/top.vhd` | — | Wires tx + rx via the UART interface |

The transmitter waits for a start trigger, then serialises 0xA5
(start → bit 0 → bit 1 → ... → bit 7 → stop).  The receiver samples
RXD at the BAUD rate, detects the start bit, captures the 8 data bits,
checks the stop bit, and re-transmits the captured byte.

## Files

| Path | Contents |
|------|----------|
| `sv/rtl/tx.sv` | UART transmitter: serialises byte with framing |
| `sv/rtl/rx.sv` | UART receiver: samples and deserialises |
| `sv/rtl/top.sv` | Clean top: interface + tx + rx |
| `sv/tb/top_tb.sv` | Self-checking testbench |
| `vhdl/` | VHDL-2019 equivalents using mode views |
| `sv/sources.f` | Source manifest for build system |

## Running

```powershell
cd examples/uart/sv
.\sim.bat top_tb        # Questa/ModelSim
.\sim.bat top_tb xsim    # Vivado xsim
```
