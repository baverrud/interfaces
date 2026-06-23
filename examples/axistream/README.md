# AXI-Stream Interface Project

Demonstrates SystemVerilog **packed structs** and **type-generic** AXI-Stream
interfaces and FIFOs.

## Design

| File | Description |
|------|-------------|
| `../COMMON/axistream_pkg/stream_pkg.sv` | Packed struct types: `pixel_t` (25-bit RGB+SOF), `iq_t` (32-bit complex) |
| `../../../lib/sv/axis_if.sv` | Parameterized AXI-Stream interface with tx/rx modports |
| `../COMMON/sync_fifo/sync_fifo.sv` | Type-generic first-word fall-through synchronous FIFO |
| `../COMMON/stream_fifo/stream_fifo.sv` | AXI-Stream wrapper around `sync_fifo` |
| `../COMMON/pixel/pixel_producer.sv` | RGB pixel stream source |
| `../COMMON/pixel/pixel_consumer.sv` | RGB pixel stream sink |
| `sv/rtl/top.sv` | Synthesizable top: producer → stream_fifo → consumer |
| `sv/tb/top_tb.sv` | Self-checking testbench (pack/unpack round-trips, IQ FIFO, pixel pipeline) |

## Scripts

From the `sv/` directory:

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
| `python common/scripts/engine.py sim sv top_tb` | Batch simulate, ModelSim |
| `python common/scripts/engine.py sim sv all` | Batch simulate all testbenches |
| `python common/scripts/engine.py sim sv top_tb -b xsim` | Batch simulate, Vivado xsim |
| `python common/scripts/engine.py sim sv top_tb -g` | ModelSim GUI |
| `python common/scripts/engine.py sim sv top_tb -p` | ModelSim project mode |
| `python common/scripts/engine.py synth sv top` | Batch synthesize, Vivado |
| `python common/scripts/engine.py synth sv all` | Batch synthesize all tops |
| `python common/scripts/engine.py synth sv top -g` | Vivado GUI synthesis |

## Configuration

Edit `sv/sources.f` to add or remove source files and adjust project
settings (top module, part number, output directories).
