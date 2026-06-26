# Shared Helper Modules

Reusable RTL modules shared across multiple example projects.

| Module | Files | Description |
|--------|-------|-------------|
| `sync_fifo/` | SV + VHDL | Generic-width FWFT synchronous FIFO |
| `stream_fifo/` | SV + VHDL | AXI-Stream wrapper that packs payload + sidebands into a single FIFO word |
| `axil_reg/` | SV + VHDL | AXI4-Lite register file with decoupled write/read interfaces |

These modules are referenced by `sources.f` files via `../../COMMON/`
relative paths from each example's `sv/` or `vhdl/` directory.
