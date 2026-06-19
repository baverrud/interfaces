# FPGA Interfaces

FPGA interface definitions using SystemVerilog (`_if.sv`) and VHDL-2019
(`_pkg.vhd`).  All interfaces are **synthesizable** and use **mode views**
(VHDL) and **modports** (SV) with master/slave (or equivalent) role separation.

## Interfaces

| Protocol | SV | VHDL |
|---|---|---|
| **AXI4-Stream** | `axistream/sv/rtl/axis_if.sv` | `axistream/vhdl/rtl/stream_pkg.vhd` |
| **AXI4** | `axi4/sv/rtl/axi4_if.sv` | `axi4/vhdl/rtl/axi4_pkg.vhd` |
| **AXI3** | `axi3/sv/rtl/axi3_if.sv` | `axi3/vhdl/rtl/axi3_pkg.vhd` |
| **AXI4-Lite** | `axilite/sv/rtl/axilite_if.sv` | `axilite/vhdl/rtl/axilite_pkg.vhd` |
| **APB** | `apb/sv/rtl/apb_if.sv` | `apb/vhdl/rtl/apb_pkg.vhd` |
| **Wishbone** | `wishbone/sv/rtl/wishbone_if.sv` | `wishbone/vhdl/rtl/wishbone_pkg.vhd` |
| **SBI** | `sbi/sv/rtl/sbi_if.sv` | `sbi/vhdl/rtl/sbi_pkg.vhd` |
| **SPI / QSPI** | `spi/sv/rtl/spi_if.sv` | `spi/vhdl/rtl/spi_pkg.vhd` |
| **I2C** | `i2c/sv/rtl/i2c_if.sv` | `i2c/vhdl/rtl/i2c_pkg.vhd` |
| **I2S** | `i2s/sv/rtl/i2s_if.sv` | `i2s/vhdl/rtl/i2s_pkg.vhd` |
| **UART** | `uart/sv/rtl/uart_if.sv` | `uart/vhdl/rtl/uart_pkg.vhd` |
| **CAN** | `can/sv/rtl/can_if.sv` | `can/vhdl/rtl/can_pkg.vhd` |
| **MDIO** | `mdio/sv/rtl/mdio_if.sv` | `mdio/vhdl/rtl/mdio_pkg.vhd` |
| **JTAG** | `jtag/sv/rtl/jtag_if.sv` | `jtag/vhdl/rtl/jtag_pkg.vhd` |

Full AXI signal reference: [`common/wrappers/README.md`](common/wrappers/README.md)

## Repository Structure

```
interfaces/
├── common/
│   ├── scripts/          ← shared Tcl (modelsim.tcl, vivado.tcl)
│   └── wrappers/         ← Zynq PS wrapper reference + AXI signal table
├── axistream/            ← AXI-Stream (SV + VHDL, demo pipeline)
├── axi4/                 ← AXI4 (interface + VHDL demo)
├── axi3/                 ← AXI3 (interface only)
├── axilite/              ← AXI4-Lite (interface + SV demo)
├── apb/                  ← APB (interface only)
├── wishbone/             ← Wishbone (interface only)
├── sbi/                  ← SBI (interface only)
├── spi/                  ← SPI/QSPI (interface only)
├── i2c/                  ← I2C (interface only)
├── i2s/                  ← I2S (interface only)
├── uart/                 ← UART (interface only)
├── can/                  ← CAN (interface only)
├── mdio/                 ← MDIO (interface only)
└── jtag/                 ← JTAG (interface only)
```

Each sub-project follows a consistent layout:

```
<proto>/
├── sv/
│   ├── rtl/              ← SystemVerilog sources
│   ├── tb/               ← testbenches
│   ├── scripts/          ← sim.bat, viv.bat, sources.f
│   ├── sim/              ← simulation output (gitignored)
│   └── viv/              ← Vivado project output (gitignored)
└── vhdl/
    ├── rtl/              ← VHDL-2019 sources
    ├── tb/               ← testbenches
    ├── scripts/          ← sim.bat, viv.bat, sources.f
    ├── sim/              ← simulation output (gitignored)
    └── viv/              ← Vivado project output (gitignored)
```

## Design Conventions

- **Modports / mode views**: `master` = manager/controller (drives payload),
  `slave` = subordinate/peripheral (responds).  For I2C/MDIO/JTAG,
  role-specific modports are used (`manager`/`phy`, `controller`/`transceiver`,
  `tap`).
- **Configurable widths**: `DATA_W`, `ADDR_W`, `ID_W`, `USER_W` are parameters
  on SV interfaces; VHDL uses unconstrained `std_logic_vector` elements
  constrained per-signal.
- **Safe-width stubs**: VHDL sideband signals use `(0 downto 0)` stubs, never
  null ranges `(-1 downto 0)` — null ranges crash Vivado's waveform viewer.
- **aclk/aresetn**: SV AXI interfaces carry clock/reset in the interface;
  VHDL keeps them as separate entity ports.
- **Protocol assertions**: `ifndef SYNTHESIS` guards simulation-only assertions
  in SV interfaces (payload stability, tvalid stability).

## Prerequisites

Vivado and Questa/ModelSim must be on `PATH` before running any scripts.
The scripts do not call vendor environment setup internally — you must
source the appropriate `settings64` script first.

**Vivado (synthesis + simulation):**
```cmd
call C:\Xilinx\<version>\Vivado\.settings64-Vivado.bat
```

**Questa / ModelSim (simulation):** `vsim` must be on `PATH`.
```cmd
set PATH=C:\intelFPGA\<version>\questa_fse\win64;%PATH%
```
<!-- or source your vendor-supplied setup script -->

Verify with `vsim -version` and `vivado -version` before proceeding.

## Workflow

```cmd
cd <project>\sv\scripts
sim.bat              ← batch simulation
sim_gui.bat          ← GUI simulation
viv.bat              ← batch Vivado (synth + sim)
viv_gui.bat          ← GUI Vivado
```

