# FPGA Interfaces

FPGA interface definitions using SystemVerilog (`_if.sv`) and VHDL-2019
(`_pkg.vhd`).  All interfaces are **synthesizable** and use **mode views**
(VHDL) and **modports** (SV) with master/slave (or equivalent) role separation.

## Interfaces

| Protocol | SV | VHDL |
|---|---|---|
| **AXI4-Stream** | `lib/sv/axis_if.sv` | `lib/vhdl/axis_pkg.vhd` |
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
├── common/               ← reusable tooling
│   ├── scripts/          ← shared engine.py + Tcl
│   └── wrappers/         ← Zynq PS wrapper reference
└── examples/             ← demo projects
    ├── COMMON/           ← shared helper modules (sync_fifo, stream_fifo, axil_reg)
    ├── apb/              ← register write/read
    ├── axi3/             ← full AXI3 examples (SV + VHDL)
    ├── axi4/             ← burst write/read master + slave
    ├── axilite/          ← register access demo
    ├── axistream/        ← pixel pipeline (SV + VHDL)
    ├── can/              ← controller/transceiver loopback
    ├── i2c/              ← open-drain write+read with pull-ups
    ├── i2s/              ← controller/peripheral audio loopback
    ├── jtag/             ← IEEE 1149.1 TAP state machine + bypass register
    ├── mdio/             ← Clause 22 manager/PHY write+read
    ├── qspi/             ← quad-SPI register write/read
    ├── sbi/              ← initiator/target register access
    ├── spi/              ← register write/read
    ├── uart/             ← tx/rx with start+8+stop framing
    └── wishbone/         ← master/slave register access
```

Each demo project follows a consistent layout:

```
<proto>/
├── sv/
│   ├── sim.bat / synth.bat  ← convenience wrappers (call engine.py)
│   ├── sources.f            ← source manifest (paths relative to this dir)
│   ├── rtl/                 ← demo modules only (masters, slaves, tops)
│   ├── tb/                  ← testbenches
│   ├── sim/                 ← simulation output (gitignored)
│   └── viv/                 ← Vivado project output (gitignored)
└── vhdl/
    ├── sim.bat / synth.bat  ← convenience wrappers (call engine.py)
    ├── sources.f            ← source manifest (paths relative to this dir)
    ├── rtl/                 ← demo modules only
    ├── tb/                  ← testbenches
    ├── sim/                 ← simulation output (gitignored)
    └── viv/                 ← Vivado project output (gitignored)
```

Paths in `sources.f` are relative to the file's own directory (project root):
`../../../lib/` for the interface library (3 levels up to repo root),
`../../COMMON/` for the shared helper modules (2 levels up to `examples/`).
All Tcl scripts normalize paths via `file normalize`.

### Script usage

Two ways to run:

**1. Python (cross-platform)** — works everywhere:

```
python common/scripts/engine.py <sim|synth> <proj_dir> <target> [options]
```

| Position | Description |
|----------|-------------|
| `sim|synth` | Action: simulate or synthesize |
| `proj_dir` | Path to the project root (`sv/`, `vhdl/`, or `.`) |
| `target` | Testbench/top module name, or `all` for all targets |

**2. Convenience wrappers** — Windows only, less typing:

```
cd <project>\sv
sim top_tb
synth top
```

Each project root has `sim.bat` and `synth.bat` that forward to `engine.py`
automatically.  From any `sv/` or `vhdl/` directory:

| Command | Action |
|---------|--------|
| `sim top_tb` | Batch simulate, ModelSim (default) |
| `sim all` | Batch simulate all testbenches |
| `sim top_tb -b xsim` | Batch simulate, Vivado xsim |
| `sim top_tb -g` | ModelSim GUI (library mode) |
| `sim top_tb -p` | ModelSim GUI (project mode) |
| `synth top` | Batch synthesize, Vivado (default) |
| `synth all` | Batch synthesize all tops |
| `synth top -g` | Vivado GUI synthesis |

Python equivalent (cross-platform, works from anywhere):

| Command | Action |
|---------|--------|
| `python common/scripts/engine.py sim sv top_tb` | Batch simulate, ModelSim |
| `python common/scripts/engine.py sim sv all` | Batch simulate all |
| `python common/scripts/engine.py sim sv top_tb -b xsim` | Batch simulate, Vivado xsim |
| `python common/scripts/engine.py sim sv top_tb -g` | ModelSim GUI |
| `python common/scripts/engine.py sim sv top_tb -p` | ModelSim project mode |
| `python common/scripts/engine.py synth vhdl top` | Batch synthesize |
| `python common/scripts/engine.py synth vhdl all` | Batch synthesize all |
| `python common/scripts/engine.py synth vhdl top -g` | Vivado GUI |

Options (same for both methods):

| Option | Description |
|--------|-------------|
| `-b modelsim` | Simulate with ModelSim/Questa (default for sim) |
| `-b vivado` / `-b xsim` | Simulate / synthesize with Vivado (default for synth) |
| `-g` / `--gui` | Launch the tool GUI (single target only) |
| `-p` / `--prj` | ModelSim project-mode GUI (implies `--gui`; ModelSim only) |

Flag conventions: single-dash short flags (`-g`) are compact; double-dash long flags (`--gui`, `--prj`) are self-documenting.
You can use either form (`-p` and `--prj` are equivalent).

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

All projects use the cross-platform Python dispatcher.  From any
project's `sv/` or `vhdl/` directory:

```
python ../../common/scripts/engine.py sim . top_tb      ← batch simulation
python ../../common/scripts/engine.py sim . top_tb -g   ← GUI simulation
python ../../common/scripts/engine.py synth . top       ← batch synthesis
python ../../common/scripts/engine.py synth . top -g    ← GUI synthesis
```

