# SV Interface Library

SystemVerilog interface definitions (`_if.sv`) for FPGA protocols.
All interfaces use modports for master/slave role separation and
carry clock/reset (`aclk`, `aresetn`) as interface ports.

| File | Protocol | Modports |
|------|----------|----------|
| `axis_if.sv` | AXI4-Stream | `master`, `slave` |
| `axi4_if.sv` | AXI4 | `master`, `slave`, sub-channel |
| `axi3_if.sv` | AXI3 | `master`, `slave`, sub-channel |
| `axilite_if.sv` | AXI4-Lite | `master`, `slave`, sub-channel |
| `apb_if.sv` | APB | `master`, `slave` |
| `wishbone_if.sv` | Wishbone | `master`, `slave` |
| `sbi_if.sv` | SBI | `master`, `slave` |
| `spi_if.sv` | SPI | `master`, `slave` |
| `qspi_if.sv` | QSPI | `master`, `slave` |
| `i2c_if.sv` | I2C | `manager`, `target` |
| `i2s_if.sv` | I2S | `controller`, `peripheral` |
| `uart_if.sv` | UART | `master`, `slave` |
| `can_if.sv` | CAN | `master`, `slave` |
| `mdio_if.sv` | MDIO | `master`, `slave` |
| `jtag_if.sv` | JTAG | `controller`, `tap` |
