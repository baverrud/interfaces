# AXI4-Stream Interface Project (VHDL)

VHDL-2019 counterpart of the SV AXI4-Stream demonstration.

## Design

| File | Description |
|------|-------------|
| `../../../lib/vhdl/axis_pkg.vhd` | Mode-view AXI-Stream record (`axis_t` with tx/rx views, `axis_32b_t` constrained type, `axis_array_t`) |
| `rtl/payload_pkg.vhd` | Structured payload types + `to_slv`/`from_slv` pack/unpack, plus the `pixel_stream_t` subtype |
| `../../COMMON/sync_fifo/sync_fifo.vhd` | Generic-width FWFT synchronous FIFO |
| `../../COMMON/stream_fifo/stream_fifo.vhd` | AXI-Stream wrapper around `sync_fifo` |
| `rtl/pixel_producer.vhd` | RGB pixel stream source |
| `rtl/pixel_consumer.vhd` | RGB pixel stream sink |
| `rtl/top.vhd` | Top with inline record constraints |
| `rtl/top_subtype.vhd` | Same top using `pixel_stream_t` subtype (no inline constraints) |
| `rtl/top_constrained.vhd` | Self-contained demo using `axis_32b_t` (fully constrained, no constraint syntax needed) |
| `rtl/top_array.vhd` | N parallel pixel lanes via `axis_array_t` with `for generate` |
| `tb/top_tb.vhd` | Self-checking testbench for `top` |
| `tb/top_subtype_tb.vhd` | Self-checking testbench for `top_subtype` |
| `tb/top_constrained_tb.vhd` | Self-checking testbench for `top_constrained` |
| `tb/top_array_tb.vhd` | Self-checking testbench for `top_array` |

## Prerequisites

Before running any scripts, ensure the required EDA tools are
available on your `PATH`:

- **Questa / ModelSim** — `vsim`, `vcom`, `vlog` must be in `PATH`
- **Vivado** — `vivado` must be in `PATH` (for xsim or synthesis)

VHDL-2019 features require a recent Questa (2025+) or Vivado (2026+).

## How to Run

### Using the convenience wrappers (Windows)

```powershell
cd examples/axistream/vhdl
.\sim.bat top_tb
.\sim.bat top_subtype_tb
.\sim.bat top_constrained_tb
.\sim.bat top_array_tb
.\sim.bat top_tb -b xsim
.\synth.bat top
.\synth.bat top_subtype
.\synth.bat top_constrained
.\synth.bat top_array
```

### Using the Python dispatcher (cross-platform)

```powershell
cd examples/axistream/vhdl
python ../../common/scripts/engine.py sim . top_tb
python ../../common/scripts/engine.py sim . top_subtype_tb
python ../../common/scripts/engine.py sim . top_constrained_tb
python ../../common/scripts/engine.py sim . top_array_tb
python ../../common/scripts/engine.py sim . top_tb -b xsim
python ../../common/scripts/engine.py synth . top
python ../../common/scripts/engine.py synth . top_subtype
python ../../common/scripts/engine.py synth . top_constrained
python ../../common/scripts/engine.py synth . top_array
```

### Options

| Option | Description |
|--------|-------------|
| `-b modelsim` | Simulate with ModelSim/Questa (default) |
| `-b xsim` | Simulate with Vivado xsim |
| `-g`, `--gui` | Launch the tool GUI (single target only) |
| `-p`, `--prj` | ModelSim project-mode GUI (implies `--gui`) |
