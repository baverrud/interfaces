# AXI4 Examples

This directory contains synthesizable AXI4 master/slave demonstration designs
in both SystemVerilog (`sv/`) and VHDL-2019 (`vhdl/`).  Each variant exercises
different AXI4 interface patterns — from a single monolithic bus to fully split
sub-channel modports.

## Designs

### SystemVerilog (`sv/`)

All SV designs use the `axi4_if` interface (`lib/sv/axi4_if.sv`) with modports.
Clock and reset are embedded in the interface.

| Design | RTL | TB | Description |
|--------|-----|----|-------------|
| `top` | `rtl/top.sv` | `tb/top_tb.sv` | **Full master + full slave** — `axi4_master` drives the `master` modport, `axi4_slave` responds on the `slave` modport. The master runs a write burst then a read burst; the testbench checks every read beat matches the expected `0xA0`-prefixed pattern. |
| `top_sub` | `rtl/top_sub.sv` | `tb/top_sub_tb.sv` | **Split masters + full slave** — write and read masters are separate modules connected via sub-channel modports (`aw_src`, `w_src`, `b_sink`, `ar_src`, `r_sink`). The write master writes, then the read master reads back. Pattern base: `0xB0`. |
| `top_sub_slave` | `rtl/top_sub_slave.sv` | `tb/top_sub_slave_tb.sv` | **Split masters + split slaves** — all four AXI sub-modules are independent: `axi4_write_master`, `axi4_read_master`, `axi4_write_slave`, `axi4_read_slave`. Both master and slave sides use sub-channel modports. The read slave is pre-initialized with pattern `0xC0`. |

### VHDL (`vhdl/`)

All VHDL designs use the `axi4_pkg` package (`lib/vhdl/axi4_pkg.vhd`) with
VHDL-2019 mode views.  Clock and reset are separate entity ports.

| Design | RTL | TB | Description |
|--------|-----|----|-------------|
| `top` | `rtl/top.vhd` | `tb/top_tb.vhd` | **Full master + full slave** — `axi4_master` and `axi4_slave` connect via per-channel constrained records (`axi4_aw_t`, `axi4_w_t`, `axi4_b_t`, `axi4_ar_t`, `axi4_r_t`). Same write-then-read burst as the SV `top`. |
| `top_split` | `rtl/top_split.vhd` | `tb/top_split_tb.vhd` | **Split masters + optional split slaves** — the `SPLIT_SLAVE` generic selects between a single full slave (`false`, pattern `0xB0`) or independent write/read slaves (`true`, pattern `0xC0`). The testbench defaults to `SPLIT_SLAVE=false`; toggle the constant to test both modes. |
| `top_hp` | `rtl/top_hp.vhd` | `tb/top_hp_tb.vhd` | **HP constrained bus** — demonstrates the `axi4_hp_t` composite view (128-bit data, 49-bit address, 6-bit ID) for Zynq HP port compatibility. `axi4_master_hp` and `axi4_slave_hp` connect via a single `axi4_hp_t` signal. The testbench checks for completion only (no data observability). |
| `top_unified` | `rtl/top_unified.vhd` | (skipped) | Intentionally excluded — too many unconstrained elements in `axi4_t` for current tool support. See `.instructions.md` for details. |

### Block Diagram

```
top / top_tb (SV + VHDL):
  ┌──────────────────────────────┐
  │  axi4_master                 │
  │  ┌─────────────────┐         │
  │  │  AW → W → B     │         │
  │  │  AR → R         │──rd_data│
  │  └──────┬──────────┘         │
  │         │ AXI4 bus           │
  │  ┌──────┴──────────┐         │
  │  │  axi4_slave     │         │
  │  │  (register file)│         │
  │  └─────────────────┘         │
  └──────────────────────────────┘

top_sub (SV only):
  ┌──────────────────────────────┐
  │  axi4_write_master ──aw_src ─┤
  │                   ──w_src ───┤
  │                   ──b_sink ──┤
  │                              ├── axi4_if bus ── axi4_slave
  │  axi4_read_master  ──ar_src ─┤
  │                   ──r_sink ──┘
  └──────────────────────────────┘

top_sub_slave (SV only):
  ┌──────────────────────────────────┐
  │  axi4_write_master ──aw_src ─┐   │
  │                   ──w_src ───┤   │
  │                   ──b_sink ──┤   │
  │                              ├───┤
  │  axi4_read_master  ──ar_src ─┤   │
  │                   ──r_sink ──┘   │
  │                              ├───┤
  │  axi4_write_slave  ──aw_sink─┐   │
  │                   ──w_sink ──┤   │
  │                   ──b_src ───┤   │
  │                              ├───┤
  │  axi4_read_slave   ──ar_sink─┐   │
  │                   ──r_src ───┘   │
  └──────────────────────────────────┘

top_split (VHDL only):
  ┌──────────────────────────────────┐
  │  axi4_write_master ──aw, w, b ──┤
  │  axi4_read_master  ──ar, r ─────┤
  │  (optionally)                    │
  │  axi4_slave        ──channels ──┤  (SPLIT_SLAVE=false)
  │  or:                              │
  │  axi4_write_slave ──aw, w, b ───┤  (SPLIT_SLAVE=true)
  │  axi4_read_slave  ──ar, r ──────┤
  └──────────────────────────────────┘
```

## Interface Patterns

Each design demonstrates a different way to connect AXI4 sub-modules through
the interface/modport/view system.  The internal sequencer logic is secondary
— pay attention to the **port connections** and **signal routing**.

### SV Modport Patterns (`axi4_if`)

| Design | Modport Pair | What It Demonstrates |
|--------|-------------|----------------------|
| `top` | `master` / `slave` | A single module drives all Tx channels (AW, W, AR) and another responds on all Rx channels (B, R). Clock/reset embedded in the interface. |
| `top_sub` | `aw_src`+`w_src`+`b_sink` (write-only) + `ar_src`+`r_sink` (read-only) + `slave` | The bus is split on the **master side only**: two independent modules share write and read channels, each connected only to the modports they need. The slave uses the full `slave` modport. |
| `top_sub_slave` | All 8 sub-channel modports | Both master and slave sides are split: 4 independent modules, each with its own dedicated modport. No module sees another's signals at compile time — the `axi4_if` instance routes internally. |

### VHDL-2019 View Patterns (`axi4_pkg`)

| Design | Views Used | What It Demonstrates |
|--------|-----------|----------------------|
| `top` | `master_aw`, `master_w`, `master_b`, `master_ar`, `master_r` / `slave_aw`..`slave_r` | Per-channel mode views, each with ≤3 unconstrained `std_logic_vector` elements (avoids Questa's parser limit). Each view is a separate VHDL-2019 `view` declaration; the slave views are derived via `'converse`. |
| `top_split` | Same per-channel views as `top`, with a `generate` | Demonstrates that the same per-channel views can be routed to either a single full slave (all channels in one entity) or to independent write/read slaves. The VHDL package's `'converse` aliases make this symmetric. |
| `top_hp` | `master_hp` / `slave_hp` | A fully constrained composite record (`axi4_hp_t`) with fixed vector widths matching the Zynq MPSoC HP wrapper ports (128-bit data, 49-bit address, 6-bit ID). Because all widths are fixed, this compiles in both Questa and Vivado without record-constraint issues. |
| `top_unified` | `master` / `slave` of `axi4_t` | *(Intentionally broken)* — the unified `axi4_t` record has >6 unconstrained `std_logic_vector` elements, exceeding current EDA parser limits. Kept as a test case for future tool versions. |

### Key VHDL-2019 Features Demonstrated

| Feature | Where |
|---------|-------|
| `view` declarations | `axi4_pkg.vhd` defines `master_aw`, `master_w`, etc. with per-channel direction |
| `'converse` alias | `alias slave_aw is master_aw'converse` in `axi4_pkg.vhd` — auto-generates the opposite direction view |
| Record constraints | `signal aw_bus: axi4_aw_t(awid(..), awaddr(..), awuser(..))` in `top.vhd` — sizes unconstrained elements per instance |
| Fully constrained record | `axi4_hp_t` in `axi4_pkg.vhd` — all vector widths are fixed, matching real hardware wrapper ports |
| `view <name> of <type>` port syntax | `aw: view master_aw of axi4_aw_t` in entity ports |

## Parameterization

All designs support `DATA_W`, `ADDR_W`, and `ID_W` generics/parameters.

The SV interface additionally supports `USER_W` for user-defined sideband
signals on every channel (`awuser`, `wuser`, `buser`, `aruser`, `ruser`):

```systemverilog
// Enable 4-bit user sidebands on all channels
axi4_if #(.DATA_W(32), .ADDR_W(32), .ID_W(4), .USER_W(4)) bus (.aclk, .aresetn);
```

When `USER_W=0` (the default), user signals are stubbed to 1-bit safe width
to avoid Vivado null-range crashes.  The existing demos do not exercise user
sidebands — adding them is left as an exercise for the reader.

## Prerequisites

Before running any scripts, ensure the required EDA tools are
available on your `PATH`:

- **Questa / ModelSim** — `vsim`, `vcom`, `vlog` must be in `PATH`
- **Vivado** — `vivado` must be in `PATH` (for xsim or synthesis)

VHDL-2019 features require a recent Questa (2025+) or Vivado (2026+).

## How to Run

### Using the convenience wrappers (Windows)

```powershell
cd examples/axi4/sv

# Simulate all testbenches with Questa (default)
.\sim.bat all

# Simulate a single testbench
.\sim.bat top_tb

# Simulate with Vivado xsim
.\sim.bat all xsim

# Synthesize all tops with Vivado (default)
.\synth.bat all

# Synthesize a single top
.\synth.bat top
```

For VHDL, substitute `sv` → `vhdl`:

```powershell
cd examples/axi4/vhdl
.\sim.bat all
.\sim.bat top_tb
.\sim.bat all xsim
.\synth.bat all
.\synth.bat top
```

> **Note:** In PowerShell, batch files need a `.\` prefix.  Use `.\sim.bat`,
> not `sim.bat`.

### Using the Python dispatcher directly (cross-platform)

```powershell
cd examples/axi4/sv

# Questa simulation — all testbenches
python ../../common/scripts/engine.py sim . all

# Questa simulation — single testbench
python ../../common/scripts/engine.py sim . top_tb

# Vivado xsim — all testbenches
python ../../common/scripts/engine.py sim . all -b xsim

# Vivado synthesis — all tops
python ../../common/scripts/engine.py synth . all

# Vivado synthesis — single top
python ../../common/scripts/engine.py synth . top
```

Same for VHDL — replace `.` with the path to the `vhdl/` directory, or
`cd vhdl` first and use `.`.

### Target names

| Target | Action | Description |
|--------|--------|-------------|
| `all` | sim / synth | Run all testbenches / synthesize all design tops listed in `sources.f` |
| `top_tb` | sim | Simulate the full master+slave testbench |
| `top_sub_tb` | sim | Simulate the split-master testbench (SV only) |
| `top_sub_slave_tb` | sim | Simulate the full sub-channel testbench (SV only) |
| `top_split_tb` | sim | Simulate the split-master testbench (VHDL only) |
| `top_hp_tb` | sim | Simulate the HP constrained bus testbench (VHDL only) |
| `top` | synth | Synthesize the full master+slave design |
| `top_split` | synth | Synthesize the split-master design (VHDL only) |
| `top_hp` | synth | Synthesize the HP constrained bus design (VHDL only) |

### Options

| Option | Description |
|--------|-------------|
| `-b modelsim` | Simulate with ModelSim/Questa (default for sim) |
| `-b xsim` | Simulate with Vivado xsim |
| `-g`, `--gui` | Launch the tool GUI (single target only) |
| `-p`, `--prj` | ModelSim project-mode GUI (implies `--gui`) |

## Source Manifest (`sources.f`)

Each language variant has a `sources.f` file that lists all source files and
project configuration:

```
design  ../../../lib/sv/axi4_if.sv     # interface library (shared)
design  rtl/axi4_master.sv             # design sources
...
sim     tb/top_tb.sv                   # testbench sources
top     top_tb                          # default simulation top
name    top                             # design name (also synthesis top)
part    xc7s6cpga196-1                  # target FPGA part
simdir  sim                             # simulation output directory
vivdir  viv                             # Vivado project output directory
```

## Expected Results

All testbenches (except the intentionally excluded `top_unified`) should
pass with **0 errors**:

| Testbench | Language | Design | Expected |
|-----------|----------|--------|----------|
| `top_tb` | SV | Full master + full slave | 4 beats `0xA0`+idx, PASS |
| `top_sub_tb` | SV | Split masters + full slave | 4 beats `0xB0`+idx, PASS |
| `top_sub_slave_tb` | SV | Full sub-channel split | 4 beats `0xC0`+idx, PASS |
| `top_tb` | VHDL | Full master + full slave | 4 beats `0xA0`+idx, PASS |
| `top_split_tb` (SPLIT_SLAVE=false) | VHDL | Split masters + full slave | 4 beats `0xB0`+idx, PASS |
| `top_split_tb` (SPLIT_SLAVE=true) | VHDL | Split masters + split slaves | 4 beats `0xC0`+idx, PASS |
| `top_hp_tb` | VHDL | HP constrained bus | Completion check only, PASS |

Synthesis should complete with 0 errors for all design tops (`top`, `top_split`, `top_hp`).
Benign warnings are expected — see `.instructions.md` for the full list.
