# Example Projects

Demonstration designs for each protocol, organized by language variant.

## Protocols with Full Examples

| Protocol | SV | VHDL | Description |
|----------|----|------|-------------|
| **AXI4-Stream** | `axistream/sv/` | `axistream/vhdl/` | Type-generic pixel pipeline + 5 interface pattern variants |
| **AXI4** | `axi4/sv/` | `axi4/vhdl/` | Burst write/read master + slave, split sub-channel modports |
| **AXI3** | `axi3/sv/` | `axi3/vhdl/` | AXI3 with wid, 4-bit len, 2-bit lock, HP constrained bus |
| **AXI4-Lite** | `axilite/sv/` | `axilite/vhdl/` | Register access, sub-channel modports, m40 address variant |
| **APB** | `apb/sv/` | `apb/vhdl/` | Register write/read (write 0xA5, read back) |
| **Wishbone** | `wishbone/sv/` | `wishbone/vhdl/` | Register write/read (classic B4) |
| **SBI** | `sbi/sv/` | `sbi/vhdl/` | Initiator/target register access |
| **SPI** | `spi/sv/` | `spi/vhdl/` | Register write/read, 8 SCLK cycles, MSB first |
| **QSPI** | `qspi/sv/` | `qspi/vhdl/` | Quad-SPI register write/read, 2 nibbles |
| **I2C** | `i2c/sv/` | `i2c/vhdl/` | Open-drain write+read with repeated START |
| **I2S** | `i2s/sv/` | `i2s/vhdl/` | Controller/peripheral audio sample loopback |
| **UART** | `uart/sv/` | `uart/vhdl/` | TX/RX with start+8+stop framing, baud divider |
| **CAN** | `can/sv/` | `can/vhdl/` | Controller/transceiver frame simulation |
| **MDIO** | `mdio/sv/` | `mdio/vhdl/` | Clause 22 manager/PHY register write+read |
| **JTAG** | `jtag/sv/` | `jtag/vhdl/` | IEEE 1149.1 TAP state machine + bypass register |

## Shared Helpers

| Module | Location | Description |
|--------|----------|-------------|
| `sync_fifo` | `COMMON/sync_fifo/` | Generic-width FWFT synchronous FIFO |
| `stream_fifo` | `COMMON/stream_fifo/` | AXI-Stream wrapper around sync_fifo |
| `axil_reg` | `COMMON/axil_reg/` | AXI4-Lite register file (decoupled) |
| `pixel` | `COMMON/pixel/` | Pixel producer/consumer for AXI4-Stream demo |
| `axistream_pkg` | `COMMON/axistream_pkg/` | AXI4-Stream payload type definitions |
