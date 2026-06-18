# AXI-Stream Interface Project

Demonstrates SystemVerilog **packed structs** and **type-generic** AXI-Stream
interfaces and FIFOs.

## Design

| File | Description |
|------|-------------|
| `sv/rtl/stream_pkg.sv` | Packed struct types: `pixel_t` (25-bit RGB+SOF), `iq_t` (32-bit complex) |
| `sv/rtl/axis_if.sv` | Parameterized AXI-Stream interface with tx/rx modports |
| `sv/rtl/sync_fifo.sv` | Type-generic first-word fall-through synchronous FIFO |
| `sv/rtl/stream_fifo.sv` | AXI-Stream wrapper around `sync_fifo` |
| `sv/rtl/pixel_producer.sv` | RGB pixel stream source |
| `sv/rtl/pixel_consumer.sv` | RGB pixel stream sink |
| `sv/rtl/top.sv` | Synthesizable top: producer → stream_fifo → consumer |
| `sv/tb/top_tb.sv` | Self-checking testbench (pack/unpack round-trips, IQ FIFO, pixel pipeline) |

## Scripts

Located in `sv/scripts/`:

| Command | Description |
|---------|-------------|
| `sim.bat` | Batch simulation (library mode) |
| `sim_gui.bat` | GUI simulation with waves |
| `sim_prj.bat` | GUI simulation (ModelSim project mode) |
| `viv.bat` | Batch Vivado (synth + sim, then exit) |
| `viv_gui.bat` | GUI Vivado project |

## Configuration

Edit `sv/scripts/sources.f` to add or remove source files and adjust project
settings (top module, part number, output directories).
