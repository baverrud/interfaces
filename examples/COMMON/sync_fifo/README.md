# Synchronous FIFO

Generic-width FWFT (First-Word Fall-Through) synchronous FIFO.

| File | Language | Description |
|------|----------|-------------|
| `sync_fifo.sv` | SystemVerilog | Parameterized with `parameter type T` |
| `sync_fifo.vhd` | VHDL | Parameterized with `generic (WIDTH, DEPTH)` |

Both implementations are equivalent — same FWFT behaviour, same flags
(`full`, `empty`), same `DEPTH` parameter.
