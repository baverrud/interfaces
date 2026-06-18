# AXI-Stream Interface Project (VHDL)

VHDL-2019 counterpart of the SV AXI-Stream demonstration.

## Design

| File | Description |
|------|-------------|
| `rtl/stream_pkg.vhd` | Mode-view AXI-Stream record (`axis_t` with tx/rx views) |
| `rtl/payload_pkg.vhd` | Structured payload types + `to_slv`/`from_slv` pack/unpack |
| `rtl/sync_fifo.vhd` | Generic-width FWFT synchronous FIFO |
| `rtl/stream_fifo.vhd` | AXI-Stream wrapper around `sync_fifo` |
| `rtl/pixel_producer.vhd` | RGB pixel stream source |
| `rtl/pixel_consumer.vhd` | RGB pixel stream sink |
| `rtl/top.vhd` | Synthesizable top: producer → stream_fifo → consumer |
| `tb/top_tb.vhd` | Self-checking testbench |

## Scripts

Located in `scripts/`:

| Command | Description |
|---------|-------------|
| `sim.bat` | Batch simulation (library mode) |
| `sim_gui.bat` | GUI simulation with waves |
| `sim_prj.bat` | GUI simulation (ModelSim project mode) |
| `viv.bat` | Batch Vivado (synth + sim, then exit) |
| `viv_gui.bat` | GUI Vivado project |
