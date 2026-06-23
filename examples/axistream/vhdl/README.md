# AXI-Stream Interface Project (VHDL)

VHDL-2019 counterpart of the SV AXI-Stream demonstration.

## Design

| File | Description |
|------|-------------|
| `../../../lib/vhdl/stream_pkg.vhd` | Mode-view AXI-Stream record (`axis_t` with tx/rx views) |
| `../../COMMON/axistream_pkg/payload_pkg.vhd` | Structured payload types + `to_slv`/`from_slv` pack/unpack |
| `../../COMMON/sync_fifo/sync_fifo.vhd` | Generic-width FWFT synchronous FIFO |
| `../../COMMON/stream_fifo/stream_fifo.vhd` | AXI-Stream wrapper around `sync_fifo` |
| `../../COMMON/pixel/pixel_producer.vhd` | RGB pixel stream source |
| `../../COMMON/pixel/pixel_consumer.vhd` | RGB pixel stream sink |
| `rtl/top.vhd` | Synthesizable top: producer → stream_fifo → consumer |
| `tb/top_tb.vhd` | Self-checking testbench |

## Scripts

From the `vhdl/` directory:

| Command | Description |
|---------|-------------|
| `sim top_tb` | Batch simulate, ModelSim |
| `sim all` | Batch simulate all testbenches |
| `sim top_tb -b xsim` | Batch simulate, Vivado xsim |
| `sim top_tb -g` | ModelSim GUI (library mode) |
| `sim top_tb -p` | ModelSim GUI (project mode) |
| `synth top` | Batch synthesize, Vivado |
| `synth all` | Batch synthesize all tops |
| `synth top -g` | Vivado GUI synthesis |

Or from anywhere, using the Python dispatcher directly:

| Command | Description |
|---------|-------------|
| `python common/scripts/engine.py sim vhdl top_tb` | Batch simulate, ModelSim |
| `python common/scripts/engine.py sim vhdl all` | Batch simulate all testbenches |
| `python common/scripts/engine.py sim vhdl top_tb -b xsim` | Batch simulate, Vivado xsim |
| `python common/scripts/engine.py sim vhdl top_tb -g` | ModelSim GUI |
| `python common/scripts/engine.py sim vhdl top_tb -p` | ModelSim project mode |
| `python common/scripts/engine.py synth vhdl top` | Batch synthesize, Vivado |
| `python common/scripts/engine.py synth vhdl all` | Batch synthesize all tops |
| `python common/scripts/engine.py synth vhdl top -g` | Vivado GUI synthesis |
