# Example Projects

Demonstration designs for each protocol, organized by language variant.

## Protocols with Full Examples

| Protocol | SV | VHDL | Description |
|----------|----|------|-------------|
| **AXI4-Stream** | `axistream/sv/` | `axistream/vhdl/` | Type-generic pixel pipeline + 5 interface pattern variants |
| **AXI4** | `axi4/sv/` | `axi4/vhdl/` | Burst write/read master + slave, split sub-channel modports |
| **AXI3** | `axi3/sv/` | `axi3/vhdl/` | AXI3 with wid, 4-bit len, 2-bit lock, HP constrained bus |
| **AXI4-Lite** | `axilite/sv/` | `axilite/vhdl/` | Register access, sub-channel modports, m40 address variant |

## Shared Helpers

| Module | Location | Description |
|--------|----------|-------------|
| `sync_fifo` | `COMMON/sync_fifo/` | Generic-width FWFT synchronous FIFO |
| `stream_fifo` | `COMMON/stream_fifo/` | AXI-Stream wrapper around sync_fifo |
| `axil_reg` | `COMMON/axil_reg/` | AXI4-Lite register file (decoupled) |

## Stubs (interface only, no examples yet)

`apb/`, `can/`, `i2c/`, `i2s/`, `jtag/`, `mdio/`, `qspi/`, `sbi/`,
`spi/`, `uart/`, `wishbone/` — protocol definitions exist in `lib/`
but no example designs have been written yet.
