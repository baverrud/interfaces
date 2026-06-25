# AXI4-Stream Examples

Demonstrates **type-generic** AXI4-Stream interfaces and FIFOs using
SystemVerilog packed structs.

A single design is provided — a pixel pipeline: `pixel_producer` →
`stream_fifo` → `pixel_consumer`. The testbench also exercises an IQ
(complex-number) stream through the same generic FIFO to demonstrate
type parameterization.

## Designs

### SystemVerilog (`sv/`)

All SV designs use the `axis_if` interface (`lib/sv/axis_if.sv`) with
tx/rx modports and the `payload_pkg` package (`sv/rtl/`).

| Design | RTL | TB | Description |
|--------|-----|----|-------------|
| `top` | `rtl/top.sv` | `tb/top_tb.sv` | **Pixel pipeline** — `pixel_producer` drives the `master` modport, `pixel_consumer` responds on the `slave` modport, with a `stream_fifo` between them. Tests pack/unpack round-trips and IQ stream through a generic FIFO. |

### VHDL (`vhdl/`)

All VHDL designs use the `axis_pkg` package (`lib/vhdl/axis_pkg.vhd`)
with VHDL-2019 mode views.  Clock and reset are separate entity ports.

| Design | RTL | TB | Description |
|--------|-----|----|-------------|
| `top` | `rtl/top.vhd` | `tb/top_tb.vhd` | **Pixel pipeline** — same structure as the SV version: producer → stream_fifo → consumer. Demonstrates the `axis_t` record with `master`/`slave` views. |

### Block Diagram

```
top / top_tb (SV + VHDL):
  ┌──────────────────────────────────────┐
  │  pixel_producer  ── tx ──┐           │
  │                         ├── stream_  │
  │  pixel_consumer  ── rx ─┘   fifo     │
  └──────────────────────────────────────┘
```

## User Guide

### Interface Parameterization (`axis_if` / `axis_pkg`)

The AXI4-Stream interface is **type-generic**: the payload width is set not
by a numeric parameter but by the actual data type you plug in.

#### SystemVerilog (`axis_if`)

```systemverilog
// Parameters:
//   PAYLOAD_T   = data type for tdata (any packed type, or logic [N:0])
//   HAS_TLAST   = 0 (default) or 1 — enables tlast end-of-packet marker
//   TUSER_WIDTH = width of tuser sideband (0 = disabled → 1-bit stub)
//   TID_WIDTH   = width of tid   sideband (0 = disabled → 1-bit stub)
//   TDEST_WIDTH = width of tdest sideband
//   TKEEP_WIDTH = width of tkeep sideband
//   TSTRB_WIDTH = width of tstrb sideband

// Example: 32-bit raw data, no sidebands
axis_if #(.PAYLOAD_T(logic [31:0])) bus (.aclk, .aresetn);

// Example: pixel_t struct with tlast enabled
axis_if #(.PAYLOAD_T(pixel_t), .HAS_TLAST(1)) bus (.aclk, .aresetn);
```

**Modports:**
- `master` — Transmitter (drives `tvalid`, `tdata`, sidebands; samples `tready`)
- `slave`  — Receiver  (drives `tready`; samples `tvalid`, `tdata`, sidebands)

Connect via the sub-modport syntax:

```systemverilog
pixel_producer #(.LINE(LINE)) u_prod (.m(src.master));
pixel_consumer                 u_cons (.s(sink.slave));
```

#### VHDL-2019 (`axis_pkg`)

The VHDL record uses **unconstrained `std_logic_vector`** elements sized
per-instance with record constraints:

```vhdl
signal s : axis_t(
    tdata(31 downto 0),        -- payload width
    tuser(0 downto 0),         -- 1-bit stub (sideband absent)
    tid(0 downto 0),
    tdest(0 downto 0),
    tkeep(0 downto 0),
    tstrb(0 downto 0)
);
```

**Important:** `tlast` is always present (it is a `std_logic`, not a vector).
You do **not** constrain it — it is always 1 bit.  All other sidebands
should be `(0 downto 0)` when unused (never `(-1 downto 0)`, which crashes
Vivado's waveform viewer).

**Mode views:**
- `view master of axis_t` — Transmitter (drives `tvalid`, `tdata`, sidebands)
- `view slave  of axis_t` — Receiver (derived via `alias slave is master'converse`)

Entity ports use the view-as-port syntax:

```vhdl
entity pixel_producer is
  port (
    clk : in  std_logic;
    rst : in  std_logic;
    m   : view master of axis_t    -- transmitter port
  );
end entity;
```

#### Why `HAS_TLAST` matters

When `HAS_TLAST=0` in the SV interface, `tlast` is still present as a 1-bit
signal (safe-width stub), but the property assertions in `axis_if` check that
`tlast` is **not** used — the `$stable(tlast)` check is guarded by
`(!HAS_TLAST || $stable(tlast))`.  Set `HAS_TLAST=1` to enable the
end-of-packet marker and its stability assertion.

In VHDL, `tlast` is always 1 bit because it's a scalar `std_logic`.  Whether
you drive it is up to your logic; the record has no way to "disable" it.

### Payload Type Parameterization

The key AXI4-Stream feature is that `tdata` can be **any packed type**,
not just a bit-vector:

| Language | Mechanism | Example |
|----------|-----------|---------|
| **SV** | `parameter type PAYLOAD_T` | `axis_if #(.PAYLOAD_T(pixel_t))` |
| **VHDL** | Unconstrained `std_logic_vector` + `to_slv`/`from_slv` | `signal s : axis_t(tdata(PIXEL_W-1 downto 0))` |

In SystemVerilog, a `typedef struct packed` IS its bit-vector, so the
serialization is automatic — casting between the struct and a plain vector
costs zero logic in synthesis:

```systemverilog
typedef struct packed {
  logic [7:0] r;
  logic [7:0] g;
  logic [7:0] b;
  logic       sof;
} pixel_t;                          // $bits(pixel_t) == 25

// Using a pixel_t as the tdata type:
axis_if #(.PAYLOAD_T(pixel_t), .HAS_TLAST(1)) bus (...);

// Accessing fields directly from the interface:
assign next_pixel.r = pixel.r + 1;
```

In VHDL, you write explicit `to_slv` / `from_slv` pack-unpack functions.
Place them in a `payload_pkg` alongside the type so every stream flavour is
defined in one place:

```vhdl
-- In rtl/payload_pkg.vhd:
function pixel_to_slv(p : pixel_t) return std_logic_vector is
begin
  return p.r & p.g & p.b & p.sof;          -- 8 + 8 + 8 + 1 = 25
end function;

function pixel_from_slv(v : std_logic_vector) return pixel_t is ...
```

The width constant is then derived from the sum of subfields:

```vhdl
constant PIXEL_W : natural := 8 + 8 + 8 + 1;   -- = 25
```

Both approaches ensure you never hand-count bits — the compiler checks.

### Stream FIFO Parameters

The `stream_fifo` modules (`COMMON/stream_fifo/`) accept the same
parameters and adapt automatically to whatever payload and sidebands
are connected:

| Parameter | SV | VHDL | Description |
|-----------|----|------|-------------|
| `PAYLOAD_T` / (inferred) | `parameter type PAYLOAD_T` | Width computed from `s.tdata'length` | Payload type for the FIFO word |
| `DEPTH` | `parameter int DEPTH` | `generic (DEPTH : positive)` | Number of entries |
| `HAS_TLAST` | `parameter bit HAS_TLAST` | Always present | Pack tlast into the FIFO word |
| `TUSER_WIDTH` | `parameter int TUSER_WIDTH` | Inferred from `s.tuser'length` | Width of tuser to pack |
| `TID_WIDTH` | `parameter int TID_WIDTH` | Inferred | — |
| `TDEST_WIDTH` | `parameter int TDEST_WIDTH` | Inferred | — |
| `TKEEP_WIDTH` | `parameter int TKEEP_WIDTH` | Inferred | — |
| `TSTRB_WIDTH` | `parameter int TSTRB_WIDTH` | Inferred | — |

The SV `stream_fifo` uses a `struct packed` word to bundle payload + all
sidebands into one FIFO entry; disabled sidebands (1-bit stubs) are
constant-propagated out by synthesis.  The VHDL version computes the word
width at elaboration from `s.tdata'length`, `s.tuser'length`, etc. and
packs/unpacks via generate.

### SV / VHDL Differences at a Glance

| Aspect | SystemVerilog | VHDL-2019 |
|--------|---------------|-----------|
| Clock/reset | Inside the interface (`aclk`, `aresetn`) | Separate entity ports |
| Payload width | Set by `PAYLOAD_T` parameter type | Set by record constraint `tdata(N downto 0)` |
| Sideband enable | Numeric parameter (`TUSER_WIDTH=0` → stub) | All present; constrain to `(0 downto 0)` for stub |
| tlast control | `HAS_TLAST` parameter (0=stub, 1=enabled) | Always 1-bit `std_logic` |
| Role separation | Modports: `master` / `slave` | Mode views: `view master` / `alias slave is master'converse` |
| Pack/unpack payload | Automatic via `struct packed` cast | Explicit `to_slv` / `from_slv` functions |

### Quick-Start Template

To add a new AXI4-Stream interface in your own design:

**SystemVerilog:**
```systemverilog
// 1. Define your payload type
typedef struct packed {
  logic [15:0] x;
  logic [15:0] y;
  logic        valid;
} point_t;

// 2. Instantiate the interface
axis_if #(.PAYLOAD_T(point_t), .HAS_TLAST(1)) stream (.aclk, .aresetn);

// 3. Connect producer and consumer
producer_mod u_prod (.m(stream.master));
consumer_mod u_cons (.s(stream.slave));
```

**VHDL:**
```vhdl
-- 1. Define your payload type + pack/unpack functions in a package
constant POINT_W : natural := 16 + 16 + 1;   -- = 33

-- 2. Declare a constrained axis_t signal
signal stream : axis_t(
    tdata(POINT_W - 1 downto 0),
    tuser(0 downto 0),
    tid(0 downto 0),
    tdest(0 downto 0),
    tkeep(0 downto 0),
    tstrb(0 downto 0)
);

-- 3. Instantiate producer / consumer with view ports
u_prod : entity work.producer_mod port map (clk => clk, rst => rst, m => stream);
u_cons : entity work.consumer_mod port map (clk => clk, rst => rst, s => stream);
```

## Prerequisites

Before running any scripts, ensure the required EDA tools are
available on your `PATH`:

- **Questa / ModelSim** — `vsim`, `vcom`, `vlog` must be in `PATH`
- **Vivado** — `vivado` must be in `PATH` (for xsim or synthesis)

VHDL-2019 features require a recent Questa (2025+) or Vivado (2026+).

## How to Run

### Using the convenience wrappers (Windows)

```powershell
cd examples/axistream/sv

# Simulate
.\sim.bat top_tb

# Simulate with Vivado xsim
.\sim.bat top_tb xsim

# Synthesize with Vivado
.\synth.bat top
```

For VHDL, substitute `sv` → `vhdl`:

```powershell
cd examples/axistream/vhdl
.\sim.bat top_tb
.\synth.bat top
```

### Using the Python dispatcher directly (cross-platform)

```powershell
cd examples/axistream/sv

# Questa simulation
python ../../common/scripts/engine.py sim . top_tb

# Vivado xsim
python ../../common/scripts/engine.py sim . top_tb -b xsim

# Vivado synthesis
python ../../common/scripts/engine.py synth . top
```

### Target names

| Target | Action | Description |
|--------|--------|-------------|
| `top_tb` | sim | Simulate the pixel pipeline testbench |
| `top` | synth | Synthesize the pixel pipeline design |

### Options

| Option | Description |
|--------|-------------|
| `-b modelsim` | Simulate with ModelSim/Questa (default) |
| `-b xsim` | Simulate with Vivado xsim |
| `-g`, `--gui` | Launch the tool GUI (single target only) |
| `-p`, `--prj` | ModelSim project-mode GUI (implies `--gui`) |

## Source Manifest (`sources.f`)

Each language variant has a `sources.f` file that lists all source files
and project configuration.  Paths are relative to the file's directory.

## Expected Results

| Testbench | Language | Expected |
|-----------|----------|----------|
| `top_tb` | SV | pack/unpack OK, IQ FIFO OK, pixel pipeline 62 beats, PASSED |
| `top_tb` | VHDL | pack/unpack OK, IQ FIFO OK, pixel pipeline 62 beats, PASSED |
