# VHDL Package Library

VHDL-2019 package definitions (`_pkg.vhd`) for FPGA protocols.
All packages use VHDL-2019 `view` declarations with `'converse`
aliases for master/slave mode views.

| File | Protocol | Key Types |
|------|----------|-----------|
| `axis_pkg.vhd` | AXI4-Stream | `axis_t`, `axis_32b_t`, `axis_array_t` |
| `axi4_pkg.vhd` | AXI4 | `axi4_*_t` per-channel, `axi4_hp_t` |
| `axi3_pkg.vhd` | AXI3 | `axi3_*_t` per-channel, `axi3_gp_*_t` |
| `axilite_pkg.vhd` | AXI4-Lite | `axilite_*_t` per-channel, `axilite_m*_t` |
| `apb_pkg.vhd` | APB | `apb_t` |
| `wishbone_pkg.vhd` | Wishbone | `wishbone_t` |
| `sbi_pkg.vhd` | SBI | `sbi_t` |
| `spi_pkg.vhd` | SPI | `spi_t` |
| `qspi_pkg.vhd` | QSPI | `qspi_t` |
| `i2c_pkg.vhd` | I2C | `i2c_t` |
| `i2s_pkg.vhd` | I2S | `i2s_t` |
| `uart_pkg.vhd` | UART | `uart_t` |
| `can_pkg.vhd` | CAN | `can_t` |
| `mdio_pkg.vhd` | MDIO | `mdio_t` |
| `jtag_pkg.vhd` | JTAG | `jtag_t` |

All packages target VHDL-2019.  Usage requires Questa 2025+ or
Vivado 2026+ for VHDL-2019 feature support.
