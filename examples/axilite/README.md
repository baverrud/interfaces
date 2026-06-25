# AXI4-Lite Examples

This directory contains synthesizable AXI4-Lite master/slave demonstration
designs in both SystemVerilog (`sv/`) and VHDL-2019 (`vhdl/`).  Each variant
exercises different interface patterns — from a single monolithic bus to
fully split sub-channel modports.

AXI4-Lite is a single-beat subset of AXI4: no burst signals, no ID tags,
no `wlast`.  Transactions are always exactly one beat.

## Designs

### SystemVerilog (`sv/`)

All SV designs use the `axilite_if` interface (`lib/sv/axilite_if.sv`) with
modports.  Clock and reset are embedded in the interface.

| Design | RTL | TB | Description |
|--------|-----|----|-------------|
| `top` | `rtl/top.sv` | `tb/top_tb.sv` | **Full master + full slave** — `axilite_master` drives the `master` modport, `axilite_slave` responds on the `slave` modport. The master writes `0xA5A5A5A5` then reads it back. |
| `top_sub` | `rtl/top_sub.sv` | `tb/top_sub_tb.sv` | **Split masters + full slave** — write and read masters are separate modules connected via sub-channel modports (`aw_src`, `w_src`, `b_sink`, `ar_src`, `r_sink`). Pattern: `0xB0B0B0B0`. |
| `top_sub_slave` | `rtl/top_sub_slave.sv` | `tb/top_sub_slave_tb.sv` | **Split masters + split slaves** — all four AXI sub-modules are independent. Both master and slave sides use sub-channel modports. The read slave is pre-initialized with `0xC0C0C0C0`. |

### VHDL (`vhdl/`)

All VHDL designs use the `axilite_pkg` package (`lib/vhdl/axilite_pkg.vhd`)
with VHDL-2019 mode views.  Clock and reset are separate entity ports.

| Design | RTL | TB | Description |
|--------|-----|----|-------------|
| `top` | `rtl/top.vhd` | `tb/top_tb.vhd` | **Full master + full slave** — `axilite_master` and `axilite_slave` connect via per-channel constrained records (`axilite_aw_t` .. `axilite_r_t`). Pattern `0xA5A5A5A5`. |
| `top_split` | `rtl/top_split.vhd` | `tb/top_split_tb.vhd` | **Split masters + optional split slaves** — the `SPLIT_SLAVE` generic selects between a single full slave (`false`, pattern `0xB0`) or independent write/read slaves (`true`, pattern `0xC0`). |
| `top_m40` | `rtl/top_m40.vhd` | `tb/top_m40_tb.vhd` | **M40 constrained bus** — demonstrates the `axilite_m40_t` composite view (40-bit address, 32-bit data) for Zynq MPSoC M00_AXI..M07_AXI AXI4-Lite port compatibility. |

### Block Diagram

```
top / top_tb (SV + VHDL):
  ┌──────────────────────────────┐
  │  axilite_master              │
  │  ┌─────────────────┐         │
  │  │  AW → W → B     │         │
  │  │  AR → R         │──rd_data│
  │  └──────┬──────────┘         │
  │         │ AXI4-Lite bus      │
  │  ┌──────┴──────────┐         │
  │  │  axilite_slave  │         │
  │  │  (register file)│         │
  │  └─────────────────┘         │
  └──────────────────────────────┘

top_m40 (VHDL only):
  ┌──────────────────────────────────┐
  │  axilite_master_m40  ──bus_m ──┐│
  │                                 ││
  │  axilite_slave_m40   ──bus_s ──┘│
  │  (single axilite_m40_t signal)  │
  └──────────────────────────────────┘
```

## Interface Patterns

### SV Modport Patterns (`axilite_if`)

| Design | Modport Pair | What It Demonstrates |
|--------|-------------|----------------------|
| `top` | `master` / `slave` | A single module drives all Tx channels (AW, W, AR) and another responds on all Rx channels (B, R). |
| `top_sub` | `aw_src`+`w_src`+`b_sink` + `ar_src`+`r_sink` + `slave` | The bus is split on the **master side only**: two independent modules share write and read channels. |
| `top_sub_slave` | All 8 sub-channel modports | Both master and slave sides are split: 4 independent modules, each with its own dedicated modport. |

### VHDL-2019 View Patterns (`axilite_pkg`)

| Design | Views Used | What It Demonstrates |
|--------|-----------|----------------------|
| `top` | `master_aw`..`master_r` / `slave_aw`..`slave_r` | Per-channel mode views, each with ≤3 unconstrained `std_logic_vector` elements. Slave views via `'converse`. |
| `top_split` | Same per-channel views, with `generate` | Same views routed to a single full slave or independent write/read slaves via generic. |
| `top_m40` | `master_m40` / `slave_m40` | Fully constrained composite record (`axilite_m40_t`) with fixed 40-bit address, 32-bit data. Compiles in both Questa and Vivado. |

### Key VHDL-2019 Features Demonstrated

| Feature | Where |
|---------|-------|
| `view` declarations | `axilite_pkg.vhd` defines per-channel direction views |
| `'converse` alias | `alias slave_aw is master_aw'converse` — auto-generates opposite view |
| Record constraints | `signal aw_bus: axilite_aw_t(awaddr(..), awuser(..))` in `top.vhd` |
| Fully constrained record | `axilite_m40_t` — all vector widths fixed for MPSoC wrapper ports |
| `view <name> of <type>` port syntax | `aw: view master_aw of axilite_aw_t` in entity ports |

## Parameterization

All VHDL designs support `DATA_W`, `ADDR_W`, `USER_W` generics.
The SV designs support `DATA_W`, `ADDR_W`, `USER_W` parameters.

The user sideband width `USER_W` can be set to any positive value.  When
not used, `USER_W=1` (1-bit stub) avoids VHDL null-range issues.

## Prerequisites

Before running any scripts, ensure the required EDA tools are
available on your `PATH`:

- **Questa / ModelSim** — `vsim`, `vcom`, `vlog` must be in `PATH`
- **Vivado** — `vivado` must be in `PATH` (for xsim or synthesis)

VHDL-2019 features require a recent Questa (2025+) or Vivado (2026+).

## How to Run

```powershell
cd examples/axilite/sv

# Simulate all testbenches with Questa
.\sim.bat all

# Simulate a single testbench
.\sim.bat top_tb

# Simulate with Vivado xsim
.\sim.bat all xsim

# Synthesize all tops with Vivado
.\synth.bat all
```

For VHDL, substitute `sv` → `vhdl`:

```powershell
cd examples/axilite/vhdl
.\sim.bat all
.\sim.bat top_tb
.\synth.bat all
```

### Python dispatcher (cross-platform)

```powershell
cd examples/axilite/sv
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
| `top_m40_tb` | sim | M40 constrained bus testbench (VHDL only) |
| `top` | synth | Full master+slave design |
| `top_split` | synth | Split-master design (VHDL only) |
| `top_m40` | synth | M40 constrained bus design (VHDL only) |

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
| `top_tb` | SV | Full master + full slave | `0xA5A5A5A5`, PASS |
| `top_sub_tb` | SV | Split masters + full slave | `0xB0B0B0B0`, PASS |
| `top_sub_slave_tb` | SV | Full sub-channel split | `0xC0C0C0C0`, PASS |
| `top_tb` | VHDL | Full master + full slave | `0xA5A5A5A5`, PASS |
| `top_split_tb` (SPLIT_SLAVE=false) | VHDL | Split masters + full slave | `0xB0B0B0B0`, PASS |
| `top_m40_tb` | VHDL | M40 constrained bus | `0xA5A5A5A5`, PASS |
