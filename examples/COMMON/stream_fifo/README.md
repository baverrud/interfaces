# AXI4-Stream FIFO

AXI-Stream wrapper around `sync_fifo` that packs the payload plus
all sidebands (`tlast`, `tuser`, `tid`, `tdest`, `tkeep`, `tstrb`)
into a single FIFO word.

| File | Language | Payload | Sideband Packing |
|------|----------|---------|-----------------|
| `stream_fifo.sv` | SystemVerilog | `parameter type PAYLOAD_T` | `struct packed` word |
| `stream_fifo.vhd` | VHDL | Inferred from `s.tdata'length` | Concatenation + generate unpack |

Disabled sidebands (1-bit safe-width stubs) are constant-propagated
out by synthesis — they cost zero storage.
