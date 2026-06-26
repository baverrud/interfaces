# SystemVerilog Interface Guide

This repository uses **SystemVerilog interfaces** (IEEE 1800-2017) —
specifically **modports**, **parameterised interfaces**, and **interface
arrays** — to create reusable, synthesizable FPGA interface definitions.

---

## 1. What is a SystemVerilog Interface?

An `interface` bundles related signals into a single port, reducing
connection clutter and enabling modular design:

```systemverilog
// Without interface: 4 separate port wires
module spi_master (
  input  logic       clk,
  output logic       sclk,
  output logic       mosi,
  input  logic       miso,
  output logic [0:0] cs,
  ...
);

// With interface: one interface port
module spi_master (
  input  logic    clk,
  spi_if.master   m,                 // single port, 4 signals inside
  ...
);
```

---

## 2. Interface Declaration

### Basic Structure

```systemverilog
// lib/sv/spi_if.sv
interface spi_if #(
  parameter int CS_COUNT = 1
);
  logic                sclk;
  logic                mosi;
  logic                miso;
  logic [CS_COUNT-1:0] cs;

  modport master (
    output sclk, mosi, cs,
    input  miso
  );
  modport slave (
    input  sclk, mosi, cs,
    output miso
  );
endinterface
```

Key points:
- Signals declared inside the interface are **logic** (4-state) by default
- **Modports** declare direction from the *connecting module's* perspective
- **Parameters** make widths configurable per instance

### Interface with Ports (I2C, MDIO)

For protocols with bidirectional top-level pins, the interface exposes
`inout` ports:

```systemverilog
interface i2c_if (
  inout wire scl,
  inout wire sda
);
  modport master (inout scl, sda);
  modport slave  (inout scl, sda);
endinterface
```

When instantiating, use `.` to leave ports unconnected (they are
connected via pull-ups in the testbench):

```systemverilog
i2c_if bus ();                           // ports unconnected
```

---

## 3. Instantiating Interfaces

### Basic Instantiation

```systemverilog
// Default parameters
spi_if bus ();

// Override parameters
spi_if #(.CS_COUNT(1)) bus ();
qspi_if #(.CS_COUNT(1), .DATA_LINES(4)) bus ();
i2s_if #(.DATA_W(24)) bus ();
```

### Connecting to Modules

Connect using the **modport** syntax:

```systemverilog
spi_master u_mast (
  .clk, .rstn,
  .m    (bus.master),               // ← uses master modport
  .done (done)
);

spi_slave u_slav (
  .clk, .rstn,
  .s    (bus.slave)                 // ← uses slave modport
);
```

Both modules connect to the **same** interface instance `bus`, but
through different modports that define which signals are inputs vs
outputs for each module.

---

## 4. Modports in Module Ports

A module declares its interface port using the modport syntax:

```systemverilog
module spi_master (
  input  logic    clk,
  input  logic    rstn,
  spi_if.master   m,                // ← modport name after dot
  output logic    done
);
```

Inside the module, drive and read through the modport:

```systemverilog
always_ff @(posedge clk or negedge rstn) begin
  if (!rstn) begin
    m.sclk <= 0;
    m.mosi <= 0;
    m.cs   <= 1;
  end else begin
    m.sclk <= ~m.sclk;              // drive output
    if (m.miso) begin               // read input
      ...
    end
  end
end
```

### Inout Modport Access (I2C, MDIO)

For bidirectional signals, use `assign` to drive with tristate:

```systemverilog
module i2c_master (
  input  logic    clk,
  input  logic    rstn,
  i2c_if.master   m,
  output logic    done
);
  logic sda_drv;                    // 1 = pull low, 0 = release
  assign m.sda = sda_drv ? 1'b0 : 1'bz;

  logic sda_val;
  assign sda_val = m.sda;           // continuous read
```

---

## 5. Parameterised Interfaces

Interface parameters allow data widths, CS counts, and other
configuration to be set per instance:

```systemverilog
interface i2s_if #(
  parameter int DATA_W = 24         // audio sample width in bits
);
  logic [DATA_W-1:0] tx_data;
  logic [DATA_W-1:0] rx_data;
  ...
endinterface
```

Instantiation:

```systemverilog
i2s_if #(.DATA_W(24)) bus ();       // 24-bit audio
i2s_if #(.DATA_W(16)) bus2 ();      // 16-bit audio
```

### Comparing Parameter Types

| Type | Example | Use case |
|------|---------|----------|
| `int` | `parameter int CS_COUNT = 1` | Widths, sizes |
| `bit` | `parameter bit HAS_TRST = 0` | Boolean options |
| `type` | `parameter type PAYLOAD_T = logic [7:0]` | Generic payload (AXI-Stream) |

### Type-Generic Interfaces (AXI4-Stream)

For maximum reusability, use `parameter type`:

```systemverilog
interface axis_if #(
  parameter type PAYLOAD_T = logic [7:0],
  parameter int USER_W = 1
);
  logic                clk;
  logic                rstn;
  logic                valid;
  logic                ready;
  PAYLOAD_T            data;
  logic [USER_W-1:0]   user;
  ...
endinterface
```

Modules can then work with any payload type:

```systemverilog
// 32-bit pixel stream
axis_if #(.PAYLOAD_T(pixel_t)) pixel_bus ();

// 8-bit byte stream
axis_if #(.PAYLOAD_T(logic [7:0])) byte_bus ();
```

---

## 6. Interface Arrays

For multi-channel designs, use interface arrays:

```systemverilog
// Array of 4 AXI4-Stream interfaces
axis_if #(.PAYLOAD_T(pixel_t)) buses[4] ();

// Connect each channel
for (genvar i = 0; i < 4; i++) begin
  axis_fifo #(.PAYLOAD_T(pixel_t)) u_fifo (
    .axis_in  (buses[i]),             // no modport needed
    .axis_out (buses[i])
  );
end
```

A module can accept an interface array port:

```systemverilog
module pixel_mux (
  axis_if.master buses[4],          // array of 4 master modports
  axis_if.master m                  // single output
);
```

---

## 7. Multiple Modports Per Interface

Some protocols define **sub-channel modports** for finer-grained
access.  AXI4-Lite has split write/read channels:

```systemverilog
interface axilite_if #(int DATA_W = 32, int ADDR_W = 32);
  // Signals
  logic [ADDR_W-1:0] awaddr;
  logic              awvalid;
  logic              awready;
  logic [DATA_W-1:0] wdata;
  ...

  // Full master (all signals)
  modport master (
    output awaddr, awvalid, wdata, wstrb, bready,
    input  awready, wready, bvalid, bresp,
    output araddr, arvalid, rready,
    input  arready, rvalid, rdata, rresp
  );

  // Sub-channel modports
  modport aw_src (output awaddr, awvalid, input awready);
  modport w_src  (output wdata, wstrb, wvalid, input wready);
  modport b_sink (input bvalid, bresp, output bready);
  modport ar_src (output araddr, arvalid, input arready);
  modport r_sink (input rvalid, rdata, rresp, output rready);
  ...
endinterface
```

Modules can connect to individual sub-channels:

```systemverilog
axi_awchannel u_aw (.m(bus.aw_src));
axi_wchannel  u_w  (.m(bus.w_src));
```

---

## 8. Virtual Interfaces (Testbench Use)

In testbenches, `virtual interface` allows dynamic access to interface
signals without hierarchical paths:

```systemverilog
module top_tb;
  spi_if bus ();

  initial begin
    // Virtual interface for driver/monitor
    virtual spi_if.master vif = bus.master;
    // Drive through the virtual modport
    vif.sclk <= 1;
    #10 vif.sclk <= 0;
  end
endmodule
```

---

## 9. Resolving Modport Conflicts

When two modules connect to the same interface through different
modports, there is **no conflict** as long as they drive different
signals.  The interface wires are resolved naturally:

```systemverilog
// Both connect to bus.tap — both use the same modport
jtag_controller u_ctrl (.m(bus.tap));   // drives tck, tms, tdi; reads tdo
jtag_tap       u_tap  (.s(bus.tap));    // reads tck, tms, tdi; drives tdo
```

If two modules try to drive the same signal through the same modport,
a **multiple-driver** error occurs at compile time (for `logic` types)
or resolves via wired logic (for `wire`/`tri` types).

---

## 10. Interface Arrays vs. Modport Arrays

| Use case | Syntax | Example |
|----------|--------|---------|
| Multiple independent interfaces | `iface buses[N];` | Multi-channel AXI-Stream |
| One interface, multiple modports | `iface bus; modport A, B` | AXI4-Lite sub-channels |
| Both combined | `iface buses[N]; modport A` | Array of sub-channel ports |

---

## 11. Common Pitfalls

| Pitfall | Solution |
|---------|----------|
| Modport name mismatch | Ensure `.master` / `.slave` matches the declared `modport` name |
| `'0` vs `'0` | Use `'0` (tick-zero, no trailing quote) for fill literals |
| Driving `inout` with `1` | Use `'Z` or `'0` only — never drive high on a bidirectional line |
| Unconnected interface ports (I2C, MDIO) | Use `pullup()` in testbench or leave unconnected |
| Interface port direction confusion | Check the modport declaration — always from *module's* perspective |
| `logic` vs `wire` in interface | Use `logic` for internal signals, `wire` for top-level inout ports |

---

## 12. Comparison with VHDL-2019

| Feature | SystemVerilog | VHDL-2019 |
|---------|---------------|-----------|
| Signal bundle | `interface` | `record` |
| Role directions | `modport X` | `view X of rec` |
| Opposite role | Manual second `modport` | `alias Y is X'converse` |
| Width parameterisation | `parameter int` | Record constraints |
| Bidirectional | `inout` in modport | `inout` in view |
| Type-generic payloads | `parameter type PAYLOAD_T` | Not directly supported |
| Interface arrays | `buses[N]` | Use generate loops with record arrays |

---

## See Also

- All SystemVerilog interfaces: [`lib/sv/`](lib/sv/)
- Example projects: [`examples/`](examples/)
- [`VHDL2019_GUIDE.md`](VHDL2019_GUIDE.md) — the VHDL-2019 counterpart
