# VHDL-2019 Interface Guide

This repository uses **VHDL-2019** (IEEE 1076-2019) features — primarily
**mode views** and **record constraints** — to implement FPGA interface
definitions that are safe, synthesizable, and symmetric across master
and slave roles.

---

## 1. VHDL-2019 Tool Support

| Tool | Min. version | Notes |
|------|-------------|-------|
| **Questa** | 2025.3 (`q26.bat`) | Full VHDL-2019 support |
| **Vivado** | 2026.1 (`v26.bat`) | Full VHDL-2019 support |
| **ModelSim** | 2020.1 (`m20.bat`) | VHDL-2008 only (cannot compile packages, but can *simulate* pre-compiled designs) |

The convenience wrappers `q26.bat` (Questa 2025.3) and `v26.bat`
(Vivado 2026.1) are available at `c:\cmdtools`.

---

## 2. The Pattern: Record + Mode Views

Every protocol in this library follows the same pattern:

1. A **record type** bundles all signals of the interface
2. **Mode views** declare the direction of each signal from the
   perspective of one role (e.g., `master`)
3. **`'converse`** automatically derives the opposite role (e.g., `slave`)

```vhdl
-- spi_pkg.vhd (simplified)
library ieee;
use ieee.std_logic_1164.all;

package spi_pkg is

  type spi_t is record
    sclk : std_logic;
    mosi : std_logic;
    miso : std_logic;
    cs   : std_logic_vector;          -- unconstrained: width per signal
  end record;

  view master of spi_t is
    sclk, mosi, cs : out;
    miso : in;
  end view;

  alias slave is master'converse;     -- automatically: sclk/mosi/cs=in, miso=out

end package;
```

Key points:
- The record uses **unconstrained** `std_logic_vector` elements where
  widths are instance-specific (CS width, data bus width, etc.)
- The `view` keyword declares which elements are `in`, `out`, or `inout`
- `'converse` swaps all `in` ↔ `out`; `inout` stays `inout`
- **No duplication**: you only write one view; the other is automatic

---

## 3. Record Constraints

Since record elements like `cs : std_logic_vector` are unconstrained,
they must be **constrained at the signal declaration** when used:

```vhdl
-- In the top-level architecture (or testbench)
signal b : spi_t(cs(0 downto 0));     -- 1-bit chip-select
```

Multiple unconstrained elements are listed in parentheses:

```vhdl
-- AXI4-Lite with configurable address/data widths
signal b : axilite_t(
  awaddr(31 downto 0),
  wdata(31 downto 0),
  wstrb(3 downto 0),
  araddr(31 downto 0),
  rdata(31 downto 0)
);

-- I2S with 24-bit audio samples
signal b : i2s_t(
  tx_data(23 downto 0),
  rx_data(23 downto 0)
);
```

### Constraint Rules

1. Only **unconstrained** record elements need constraints — scalars
   (`std_logic`) are always fixed-width and need no constraint.
2. The constraint order must match the record element order.  Because
   of a Questa 2025.3 parser limitation, keep **≤3 unconstrained
   elements** per record (or group them into sub-records per channel
   as done for AXI3/4/4L).
3. Constraints are part of the **subtype**, not the type.  The same
   record type can be constrained differently in different contexts.

---

## 4. Using Mode Views in Entity Ports

Entity ports are declared with `view <name> of <record_type>`:

```vhdl
entity spi_master is
  port (
    clk, rstn : in  std_logic;
    m         : view master of spi_t;    -- master mode view
    done      : out std_logic
  );
end entity;
```

The slave side uses the converse view:

```vhdl
entity spi_slave is
  port (
    clk, rstn : in  std_logic;
    s         : view slave of spi_t;    -- slave = master'converse
    done      : out std_logic
  );
end entity;
```

### `inout` in Mode Views

For bidirectional protocols (I2C, MDIO), port elements are declared
`inout` in the view.  VHDL-2019 mode views support `inout` natively:

```vhdl
view master of i2c_t is
  scl, sda : inout;
end view;
```

---

## 5. Driving and Reading View Port Elements

Inside the architecture, use dot notation to access individual signals:

```vhdl
-- Drive outputs (master drives SCLK, MOSI, CS)
m.sclk <= not m.sclk;
m.mosi <= cnt(0);
m.cs   <= (m.cs'range => '1');          -- see Section 5a

-- Read inputs (master samples MISO)
if m.miso = '1' then ...
```

### 5a. The `'range` Idiom — Never Use `(others => ...)`

View port elements are **unconstrained** at the entity boundary — the
constraint comes from the actual signal connected at elaboration time.
The compiler therefore cannot determine the array bounds when you write:

```vhdl
m.cs <= (others => '1');    -- ERROR: unconstrained array aggregate
```

The solution is to use `'range` to refer to the element's own bounds:

```vhdl
m.cs <= (m.cs'range => '1');           -- OK: uses actual bounds
m.io_o <= (m.io_o'range => '0');       -- OK
```

This idiom works because `'range` is evaluated after the port is
connected and its constraint is known.

### 5b. Comparing Vectors

The same issue applies to comparisons.  Do not compare a vector view
port with a scalar:

```vhdl
if s.cs(0) = '0' then ...              -- OK: index into 1-bit vector
if s.cs = "0" then ...                 -- OK: string literal
if s.cs = '0' then ...                 -- ERROR: vector vs scalar
```

### 5c. Concurrent Assignments for Tristate (I2C, MDIO)

For open-drain protocols, drive the view port with a conditional
concurrent assignment:

```vhdl
s.sda <= '0' when sda_drv = '1' else 'Z';
```

This works because VHDL-2019 allows concurrent signal assignments on
view port elements.

---

## 6. Architecture Wiring

Entities are instantiated normally, connecting the constrained record
signal to the view port:

```vhdl
architecture rtl of top is
  signal b : spi_t(cs(0 downto 0));
begin

  u_mast : entity work.spi_master
    port map (
      clk  => clk,
      rstn => rstn,
      m    => b,                       -- master view → record
      done => done
    );

  u_slav : entity work.spi_slave
    port map (
      clk  => clk,
      rstn => rstn,
      s    => b,                       -- slave view → same record
    );

end architecture;
```

Both the master and slave connect to the **same** record signal `b`.
The mode views ensure that each entity sees the correct signal
directions.

---

## 7. Alias `'converse` — The Symmetry Principle

The `'converse` attribute automatically generates the opposite view.
Instead of manually writing both `view master` and `view slave`:

```vhdl
view master of spi_t is
  sclk, mosi, cs : out;
  miso : in;
end view;

alias slave is master'converse;       -- auto-generated opposite
```

This guarantees the two views are always consistent — no risk of
forgetting to update one side when the interface changes.

Some protocols need **custom view names** (not just `master`/`slave`):

```vhdl
-- CAN: controller ↔ transceiver
view controller of can_t is
  tx : out;
  rx : in;
end view;
alias transceiver is controller'converse;

-- JTAG: controller ↔ tap
view tap of jtag_t is
  tck, tms, tdi, trst : in;
  tdo : out;
end view;
alias controller is tap'converse;

-- MDIO: manager ↔ phy (inout)
view manager of mdio_t is
  mdc  : out;
  mdio : inout;
end view;
alias phy is manager'converse;
```

---

## 8. Weak Pull-ups (`'H`) for I2C/MDIO Simulation

For open-drain protocols, model the pull-up resistor in the top-level
architecture by driving the signal with `'H` (weak high):

```vhdl
-- i2c top.vhd
signal b : i2c_t;
begin
  b.scl <= 'H';                        -- weak pull-up
  b.sda <= 'H';                        -- weak pull-up
```

`std_logic` resolution combines the strong `'0'` (from the active
driver) with the weak `'H'` (pull-up) to produce correct open-drain
behaviour.  A non-driven line reads as `'H'` (logical 1).

---

## 9. Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| `(others => '0')` on view port | Use `(port'range => '0')` instead |
| `cs = '0'` on `std_logic_vector` | Use `cs(0) = '0'` or `cs = "0"` |
| Bus as identifier | Rename to `b` (VHDL reserved word) |
| Wait as identifier | Rename to `wait_s` (VHDL reserved word) |
| Access as identifier | Rename to `access_s` (VHDL reserved word) |
| Unconstrained record not constrained | Add constraint at signal declaration |
| Missing `'converse` alias | Add `alias slave is master'converse;` |
| Concurrent `done <= '0'` conflicting with process `done <= '1'` | Move `done <= '0'` inside the reset branch |
| Record constraint parser limit (>6 elements) | Sub-divide into per-channel records (see AXI packages) |

---

## 10. Comparison with SystemVerilog

| Feature | VHDL-2019 | SystemVerilog |
|---------|-----------|---------------|
| Signal bundle | `record` | `interface` |
| Role directions | `view X of rec` | `modport X` |
| Opposite role | `alias Y is X'converse` | Manual second `modport` |
| Width parameterisation | Record constraints | `parameter int` in interface |
| Bidirectional | `inout` in view | `inout` in modport |
| Tristate drive | Concurrent assignment on view port | `assign` on modport signal |
| General-purpose | Not needed — records are plain | `parameter type PAYLOAD_T` |

---

## See Also

- All VHDL-2019 packages: [`lib/vhdl/`](lib/vhdl/)
- Example projects using VHDL-2019: [`examples/`](examples/)
- [`SYSTEMVERILOG_GUIDE.md`](SYSTEMVERILOG_GUIDE.md) — the SV counterpart
