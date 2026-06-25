# AXI3 Examples

This directory contains synthesizable AXI3 master/slave demonstration designs
in both SystemVerilog (`sv/`) and VHDL-2019 (`vhdl/`).  Each variant exercises
different AXI3 interface patterns — from a single monolithic bus to fully split
sub-channel modports.

AXI3 differs from AXI4: burst length is 4-bit (1-16 beats), lock is 2-bit,
the write data channel carries a `wid` for write interleaving, and there is
no `awregion`/`arregion`.

## Designs

### SystemVerilog (`sv/`)

All SV designs use the `axi3_if` interface (`lib/sv/axi3_if.sv`) with modports.
Clock and reset are embedded in the interface.

| Design | RTL | TB | Description |
|--------|-----|----|-------------|
| `top` | `rtl/top.sv` | `tb/top_tb.sv` | **Full master + full slave** — `axi3_master` drives the `master` modport, `axi3_slave` responds on the `slave` modport. The master runs a write burst then a read burst; the testbench checks every read beat matches the expected `0xA0`-prefixed pattern. |
| `top_sub` | `rtl/top_sub.sv` | `tb/top_sub_tb.sv` | **Split masters + full slave** — write and read masters are separate modules connected via sub-channel modports (`aw_src`, `w_src`, `b_sink`, `ar_src`, `r_sink`). Pattern base: `0xB0`. |
| `top_sub_slave` | `rtl/top_sub_slave.sv` | `tb/top_sub_slave_tb.sv` | **Split masters + split slaves** — all four AXI sub-modules are independent. Both master and slave sides use sub-channel modports. Pattern base: `0xC0`. |

### VHDL (`vhdl/`)

All VHDL designs use the `axi3_pkg` package (`lib/vhdl/axi3_pkg.vhd`) with
VHDL-2019 mode views.  Clock and reset are separate entity ports.

| Design | RTL | TB | Description |
|--------|-----|----|-------------|
| `top` | `rtl/top.vhd` | `tb/top_tb.vhd` | **Full master + full slave** — `axi3_master` and `axi3_slave` connect via per-channel constrained records (`axi3_aw_t`, `axi3_w_t`, `axi3_b_t`, `axi3_ar_t`, `axi3_r_t`). |
| `top_split` | `rtl/top_split.vhd` | `tb/top_split_tb.vhd` | **Split masters + optional split slaves** — the `SPLIT_SLAVE` generic selects between a single full slave (`false`, pattern `0xB0`) or independent write/read slaves (`true`, pattern `0xC0`). |
| `top_hp` | `rtl/top_hp.vhd` | `tb/top_hp_tb.vhd` | **HP constrained bus** — demonstrates the `axi3_hp_t` composite view (64-bit data, 32-bit address, 6-bit ID) for Zynq-7000 HP port compatibility. |

### Block Diagram

```
top / top_tb (SV + VHDL):
  ┌──────────────────────────────┐
  │  axi3_master                 │
  │  ┌─────────────────┐         │
  │  │  AW → W → B     │         │
  │  │  AR → R         │──rd_data│
  │  └──────┬──────────┘         │
  │         │ AXI3 bus           │
  │  ┌──────┴──────────┐         │
  │  │  axi3_slave     │         │
  │  │  (register file)│         │
  │  └─────────────────┘         │
  └──────────────────────────────┘
```

## Interface Patterns

Each design demonstrates a different way to connect AXI3 sub-modules through
the interface/modport/view system.

### SV Modport Patterns (`axi3_if`)

| Design | Modport Pair | What It Demonstrates |
|--------|-------------|----------------------|
| `top` | `master` / `slave` | A single module drives all Tx channels (AW, W, AR) and another responds on all Rx channels (B, R). AXI3: `wid` present on W channel. |
| `top_sub` | `aw_src`+`w_src`+`b_sink` + `ar_src`+`r_sink` + `slave` | Split on master side only. Write and read masters are independent. |
| `top_sub_slave` | All 8 sub-channel modports | Both master and slave sides split: 4 independent modules. |

### VHDL-2019 View Patterns (`axi3_pkg`)

| Design | Views Used | What It Demonstrates |
|--------|-----------|----------------------|
| `top` | `master_aw`..`master_r` / `slave_aw`..`slave_r` | Per-channel mode views, slave views via `'converse`. AXI3: `wid` in `master_w`, 4-bit `awlen`/`arlen`, 2-bit `awlock`/`arlock`. |
| `top_split` | Same per-channel views, with `generate` | Routes same views to full or split slave via generic. |
| `top_hp` | `master_hp` / `slave_hp` | Fully constrained `axi3_hp_t` matching Zynq-7000 HP wrapper ports (64-bit data, 32-bit addr, 6-bit ID). |

### Key VHDL-2019 Features Demonstrated

| Feature | Where |
|---------|-------|
| `view` declarations | `axi3_pkg.vhd` defines per-channel direction views |
| `'converse` alias | `alias slave_aw is master_aw'converse` |
| Record constraints | `signal aw_bus: axi3_aw_t(awid(..), awaddr(..), awuser(..))` |
| Fully constrained record | `axi3_hp_t` — fixed widths matching Zynq-7000 wrapper |
| `view <name> of <type>` port syntax | `aw: view master_aw of axi3_aw_t` |

## Prerequisites

Before running any scripts, ensure the required EDA tools are
available on your `PATH`:

- **Questa / ModelSim** — `vsim`, `vcom`, `vlog` must be in `PATH`
- **Vivado** — `vivado` must be in `PATH` (for xsim or synthesis)

VHDL-2019 features require a recent Questa (2025+) or Vivado (2026+).

## How to Run

```powershell
cd examples/axi3/sv

# Simulate all testbenches with Questa
.\sim.bat all

# Simulate a single testbench
.\sim.bat top_tb

# Simulate with Vivado xsim
.\sim.bat all xsim

# Synthesize all tops with Vivado
.\synth.bat all

# Synthesize a single top
.\synth.bat top
```

For VHDL, substitute `sv` → `vhdl`.

### Python dispatcher (cross-platform)

```powershell
cd examples/axi3/sv
python ../../common/scripts/engine.py sim . all           # Questa sim
python ../../common/scripts/engine.py sim . all -b xsim   # Xilinx xsim
python ../../common/scripts/engine.py synth . all         # Vivado synth
```

### Target names

| Target | Action | Description |
|--------|--------|-------------|
| `all` | sim / synth | Run all testbenches / synthesize all tops |
| `top_tb` | sim | Full master+slave testbench |
| `top_sub_tb` | sim | Split-master testbench (SV only) |
| `top_sub_slave_tb` | sim | Full sub-channel testbench (SV only) |
| `top_split_tb` | sim | Split-master testbench (VHDL only) |
| `top_hp_tb` | sim | HP constrained bus testbench (VHDL only) |
| `top` | synth | Full master+slave design |
| `top_split` | synth | Split-master design (VHDL only) |
| `top_hp` | synth | HP constrained bus design (VHDL only) |

### Options

| Option | Description |
|--------|-------------|
| `-b modelsim` | Simulate with ModelSim/Questa (default) |
| `-b xsim` | Simulate with Vivado xsim |
| `-g`, `--gui` | Launch the tool GUI (single target only) |
| `-p`, `--prj` | ModelSim project-mode GUI (implies `--gui`) |

## Expected Results

All testbenches should pass with **0 errors**:

| Testbench | Language | Design | Expected |
|-----------|----------|--------|----------|
| `top_tb` | SV | Full master + full slave | 4 beats `0xA0`+idx, PASS |
| `top_sub_tb` | SV | Split masters + full slave | 4 beats `0xB0`+idx, PASS |
| `top_sub_slave_tb` | SV | Full sub-channel split | 4 beats `0xC0`+idx, PASS |
| `top_tb` | VHDL | Full master + full slave | 4 beats `0xA0`+idx, PASS |
| `top_split_tb` (SPLIT_SLAVE=false) | VHDL | Split masters + full slave | 4 beats `0xB0`+idx, PASS |
| `top_split_tb` (SPLIT_SLAVE=true) | VHDL | Split masters + split slaves | 4 beats `0xC0`+idx, PASS |
| `top_hp_tb` | VHDL | HP constrained bus | Completion check only, PASS |
