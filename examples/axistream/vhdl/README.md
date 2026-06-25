# AXI4-Stream Interface Project (VHDL)

VHDL-2019 counterpart of the SV AXI4-Stream demonstration.

## Design

| File | Description |
|------|-------------|
| `../../../lib/vhdl/axis_pkg.vhd` | Mode-view AXI-Stream record (`axis_t` with tx/rx views) |
| `rtl/payload_pkg.vhd` | Structured payload types + `to_slv`/`from_slv` pack/unpack |
| `../../COMMON/sync_fifo/sync_fifo.vhd` | Generic-width FWFT synchronous FIFO |
| `../../COMMON/stream_fifo/stream_fifo.vhd` | AXI-Stream wrapper around `sync_fifo` |
| `rtl/pixel_producer.vhd` | RGB pixel stream source |
| `rtl/pixel_consumer.vhd` | RGB pixel stream sink |
| `rtl/top.vhd` | Synthesizable top: producer → stream_fifo → consumer |
| `tb/top_tb.vhd` | Self-checking testbench |

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
.\sim.bat top_tb -b xsim
.\synth.bat top
```

### Using the Python dispatcher (cross-platform)

```powershell
cd examples/axistream/vhdl
python ../../common/scripts/engine.py sim . top_tb
python ../../common/scripts/engine.py sim . top_tb -b xsim
python ../../common/scripts/engine.py synth . top
```

### Options

| Option | Description |
|--------|-------------|
| `-b modelsim` | Simulate with ModelSim/Questa (default) |
| `-b xsim` | Simulate with Vivado xsim |
| `-g`, `--gui` | Launch the tool GUI (single target only) |
| `-p`, `--prj` | ModelSim project-mode GUI (implies `--gui`) |
