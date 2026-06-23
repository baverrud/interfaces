# FPGA Interfaces

FPGA interface definitions using SystemVerilog (`_if.sv`) and VHDL-2019
(`_pkg.vhd`).  All interfaces are **synthesizable** and use **mode views**
(VHDL) and **modports** (SV) with master/slave (or equivalent) role separation.

## Interfaces

| Protocol | SV | VHDL |
|---|---|---|
| **AXI4-Stream** | `lib/sv/axis_if.sv` | `lib/vhdl/stream_pkg.vhd` |
| **AXI4** | `lib/sv/axi4_if.sv` | `lib/vhdl/axi4_pkg.vhd` |
| **AXI3** | `lib/sv/axi3_if.sv` | `lib/vhdl/axi3_pkg.vhd` |
| **AXI4-Lite** | `lib/sv/axilite_if.sv` | `lib/vhdl/axilite_pkg.vhd` |
| **APB** | `lib/sv/apb_if.sv` | `lib/vhdl/apb_pkg.vhd` |
| **Wishbone** | `lib/sv/wishbone_if.sv` | `lib/vhdl/wishbone_pkg.vhd` |
| **SBI** | `lib/sv/sbi_if.sv` | `lib/vhdl/sbi_pkg.vhd` |
| **SPI** | `lib/sv/spi_if.sv` | `lib/vhdl/spi_pkg.vhd` |
| **QSPI** | `lib/sv/qspi_if.sv` | `lib/vhdl/qspi_pkg.vhd` |
| **I2C** | `lib/sv/i2c_if.sv` | `lib/vhdl/i2c_pkg.vhd` |
| **I2S** | `lib/sv/i2s_if.sv` | `lib/vhdl/i2s_pkg.vhd` |
| **UART** | `lib/sv/uart_if.sv` | `lib/vhdl/uart_pkg.vhd` |
| **CAN** | `lib/sv/can_if.sv` | `lib/vhdl/can_pkg.vhd` |
| **MDIO** | `lib/sv/mdio_if.sv` | `lib/vhdl/mdio_pkg.vhd` |
| **JTAG** | `lib/sv/jtag_if.sv` | `lib/vhdl/jtag_pkg.vhd` |

Full AXI signal reference: [`common/wrappers/README.md`](common/wrappers/README.md)

## Repository Structure

```
interfaces/
├── lib/                  ← interface definitions (reusable IP)
│   ├── sv/               ← *_if.sv (15 protocols)
│   └── vhdl/             ← *_pkg.vhd (15 protocols)
├── common/               ← reusable helpers + tooling
│   ├── hdl/              ← helper module library
│   ├── scripts/          ← shared engine.bat + Tcl
│   └── wrappers/         ← Zynq PS wrapper reference
└── examples/             ← demo projects
    ├── axi4/             ← burst write/read master + slave
    ├── axistream/        ← pixel pipeline (SV + VHDL)
    ├── axilite/          ← register access demo
    ├── axi3/             ← interface only (no demo yet)
    ├── apb/ ...          ← interface only
```

Each demo project follows a consistent layout:

```
<proto>/
├── sv/
│   ├── rtl/              ← demo modules only (masters, slaves, tops)
│   ├── tb/               ← testbenches
│   ├── scripts/          ← sim.bat, synth.bat, sources.f
│   ├── sim/              ← simulation output (gitignored)
│   └── viv/              ← Vivado project output (gitignored)
└── vhdl/
    ├── rtl/              ← demo modules only
    ├── tb/               ← testbenches
    ├── scripts/          ← sim.bat, synth.bat, sources.f
    ├── sim/              ← simulation output (gitignored)
    └── viv/              ← Vivado project output (gitignored)
```

Paths in `sources.f` reference `../../../../lib/` and `../../../../common/` from the
`scripts/` directory.  All Tcl scripts normalize paths via `file normalize`.

### Script usage

```
sim   <tb|all>   [modelsim|xsim] [gui|prj]      # simulate
synth <top|all>  [vivado]        [gui]           # synthesize
```

Examples:

| Command | Action |
|---------|--------|
| `sim top_tb` | Batch simulate one testbench |
| `sim all` | Batch simulate all testbenches |
| `sim top_tb gui` | ModelSim GUI (library mode) |
| `sim top_tb prj` | ModelSim GUI (project mode) |
| `sim top_tb xsim` | Vivado xsim batch |
| `synth top` | Synthesize one top |
| `synth all` | Synthesize all tops |
| `synth top gui` | Vivado GUI synthesis |

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

