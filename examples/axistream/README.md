# AXI-Stream Interface Project

Demonstrates SystemVerilog **packed structs** and **type-generic** AXI-Stream
interfaces and FIFOs.

## Design

| File | Description |
|------|-------------|
| `../../../../common/hdl/axistream_pkg/stream_pkg.sv` | Packed struct types: `pixel_t` (25-bit RGB+SOF), `iq_t` (32-bit complex) |
| `../../../../lib/sv/axis_if.sv` | Parameterized AXI-Stream interface with tx/rx modports |
| `../../../../common/hdl/sync_fifo/sync_fifo.sv` | Type-generic first-word fall-through synchronous FIFO |
| `../../../../common/hdl/stream_fifo/stream_fifo.sv` | AXI-Stream wrapper around `sync_fifo` |
| `../../../../common/hdl/pixel/pixel_producer.sv` | RGB pixel stream source |
| `../../../../common/hdl/pixel/pixel_consumer.sv` | RGB pixel stream sink |
| `sv/rtl/top.sv` | Synthesizable top: producer → stream_fifo → consumer |
| `sv/tb/top_tb.sv` | Self-checking testbench (pack/unpack round-trips, IQ FIFO, pixel pipeline) |

## Scripts

| Command | Description |
|---------|-------------|
| `sim top_tb` | Batch simulation |
| `sim top_tb gui` | GUI simulation |
| `sim top_tb prj` | GUI simulation (ModelSim project mode) |
| `sim all` | Batch simulate all testbenches |
| `synth top` | Batch Vivado synthesis |
| `synth top gui` | Vivado GUI synthesis |

## Configuration

Edit `sv/scripts/sources.f` to add or remove source files and adjust project
settings (top module, part number, output directories).
