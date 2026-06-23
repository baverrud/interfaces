# AXI-Stream Interface Project (VHDL)

VHDL-2019 counterpart of the SV AXI-Stream demonstration.

## Design

| File | Description |
|------|-------------|
| `../../../../lib/vhdl/stream_pkg.vhd` | Mode-view AXI-Stream record (`axis_t` with tx/rx views) |
| `../../../../common/hdl/axistream_pkg/payload_pkg.vhd` | Structured payload types + `to_slv`/`from_slv` pack/unpack |
| `../../../../common/hdl/sync_fifo/sync_fifo.vhd` | Generic-width FWFT synchronous FIFO |
| `../../../../common/hdl/stream_fifo/stream_fifo.vhd` | AXI-Stream wrapper around `sync_fifo` |
| `../../../../common/hdl/pixel/pixel_producer.vhd` | RGB pixel stream source |
| `../../../../common/hdl/pixel/pixel_consumer.vhd` | RGB pixel stream sink |
| `rtl/top.vhd` | Synthesizable top: producer → stream_fifo → consumer |
| `tb/top_tb.vhd` | Self-checking testbench |

## Scripts

| Command | Description |
|---------|-------------|
| `sim top_tb` | Batch simulation |
| `sim top_tb gui` | GUI simulation |
| `sim top_tb prj` | GUI simulation (ModelSim project mode) |
| `sim all` | Batch simulate all testbenches |
| `synth top` | Batch Vivado synthesis |
| `synth top gui` | Vivado GUI synthesis |
