-- =====================================================================
-- axilite_pkg.vhd - AXI4-Lite records + VHDL-2019 mode views
-- =====================================================================
-- Both a unified axilite_t record and per-channel sub-records are
-- provided.  Per-channel records each have <=3 unconstrained elements,
-- avoiding VHDL-2019 record constraint parser limits in current EDA
-- tools (~6 unconstrained vectors).
--
-- AXI4-Lite is a single-beat subset of AXI4:
--   - No burst (awlen/arlen fixed to 0)
--   - No wlast (single-beat only)
--   - No awsize/arsize (always 32-bit transfers)
--   - No awburst/arburst, awlock/arlock
--   - No awcache/arcache, awqos/arqos, awregion/arregion
--   - No ID tags (single transaction only)
--   - awprot/arprot and wstrb are present
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package axilite_pkg is

  -- ===================================================================
  -- Per-channel records (<=3 unconstrained elements each)
  -- ===================================================================

  -- Write Address channel (3 unconstrained: awaddr, awprot, awuser)
  type axilite_aw_t is record
    awaddr   : std_logic_vector;           -- address of the register
    awprot   : std_logic_vector(2 downto 0); -- protection: privilege/security/instruction
    awuser   : std_logic_vector;           -- user-defined sideband (per-transaction)
    awvalid  : std_logic;                  -- address+control valid
    awready  : std_logic;                  -- slave: address accepted
  end record;

  -- Write Data channel (3 unconstrained: wdata, wstrb, wuser)
  type axilite_w_t is record
    wdata  : std_logic_vector;             -- write data (one beat, always 32-bit nominal)
    wstrb  : std_logic_vector;             -- byte enables: wstrb[i] qualifies byte lane i
    wuser  : std_logic_vector;             -- user-defined sideband (per-beat)
    wvalid : std_logic;                    -- data+strobe valid
    wready : std_logic;                    -- slave: data accepted
  end record;

  -- Write Response channel (1 unconstrained: buser)
  type axilite_b_t is record
    bresp  : std_logic_vector(1 downto 0); -- response: OKAY/SLVERR/DECERR
    buser  : std_logic_vector;             -- user-defined sideband (per-response)
    bvalid : std_logic;                    -- slave: response valid
    bready : std_logic;                    -- master: response accepted
  end record;

  -- Read Address channel (3 unconstrained: araddr, arprot, aruser)
  type axilite_ar_t is record
    araddr   : std_logic_vector;           -- address of the register
    arprot   : std_logic_vector(2 downto 0); -- protection: privilege/security/instruction
    aruser   : std_logic_vector;           -- user-defined sideband (per-transaction)
    arvalid  : std_logic;                  -- address+control valid
    arready  : std_logic;                  -- slave: address accepted
  end record;

  -- Read Data channel (2 unconstrained: rdata, ruser)
  type axilite_r_t is record
    rdata  : std_logic_vector;             -- read data (one beat)
    rresp  : std_logic_vector(1 downto 0); -- response: OKAY/SLVERR/DECERR
    ruser  : std_logic_vector;             -- user-defined sideband (per-beat)
    rvalid : std_logic;                    -- slave: data+response valid
    rready : std_logic;                    -- master: data accepted
  end record;

  -- ===================================================================
  -- Per-channel mode views
  -- ===================================================================

  view master_aw of axilite_aw_t is
    awaddr, awprot, awuser, awvalid : out;
    awready : in;
  end view;
  alias slave_aw is master_aw'converse;

  view master_w of axilite_w_t is
    wdata, wstrb, wuser, wvalid : out;
    wready : in;
  end view;
  alias slave_w is master_w'converse;

  view master_b of axilite_b_t is
    bresp, buser, bvalid : in;
    bready : out;
  end view;
  alias slave_b is master_b'converse;

  view master_ar of axilite_ar_t is
    araddr, arprot, aruser, arvalid : out;
    arready : in;
  end view;
  alias slave_ar is master_ar'converse;

  view master_r of axilite_r_t is
    rdata, rresp, ruser, rvalid : in;
    rready : out;
  end view;
  alias slave_r is master_r'converse;

  -- ===================================================================
  -- Unified record -- INTENTIONALLY BROKEN for unconstrained use
  -- (too many unconstrained elements for Questa / Vivado parsers)
  -- ===================================================================

  type axilite_t is record
    -- Write Address channel
    awaddr   : std_logic_vector;           -- address of the register
    awprot   : std_logic_vector(2 downto 0); -- protection: privilege/security/instruction
    awuser   : std_logic_vector;           -- user-defined sideband (per-transaction)
    awvalid  : std_logic;                  -- address+control valid
    awready  : std_logic;                  -- slave: address accepted
    -- Write Data channel
    wdata    : std_logic_vector;           -- write data (one beat)
    wstrb    : std_logic_vector;           -- byte enables
    wuser    : std_logic_vector;           -- user-defined sideband (per-beat)
    wvalid   : std_logic;                  -- data+strobe valid
    wready   : std_logic;                  -- slave: data accepted
    -- Write Response channel
    bresp    : std_logic_vector(1 downto 0); -- response code
    buser    : std_logic_vector;           -- user-defined sideband (per-response)
    bvalid   : std_logic;                  -- slave: response valid
    bready   : std_logic;                  -- master: response accepted
    -- Read Address channel
    araddr   : std_logic_vector;           -- address of the register
    arprot   : std_logic_vector(2 downto 0); -- protection: privilege/security/instruction
    aruser   : std_logic_vector;           -- user-defined sideband (per-transaction)
    arvalid  : std_logic;                  -- address+control valid
    arready  : std_logic;                  -- slave: address accepted
    -- Read Data channel
    rdata    : std_logic_vector;           -- read data (one beat)
    rresp    : std_logic_vector(1 downto 0); -- response code
    ruser    : std_logic_vector;           -- user-defined sideband (per-beat)
    rvalid   : std_logic;                  -- slave: data+response valid
    rready   : std_logic;                  -- master: data accepted
  end record;

  view master of axilite_t is
    -- AW channel
    awaddr, awprot, awuser, awvalid : out;
    awready : in;
    -- W channel
    wdata, wstrb, wuser, wvalid : out;
    wready : in;
    -- B channel
    bresp, buser, bvalid : in;
    bready : out;
    -- AR channel
    araddr, arprot, aruser, arvalid : out;
    arready : in;
    -- R channel
    rdata, rresp, ruser, rvalid : in;
    rready : out;
  end view;
  alias slave is master'converse;

  -- ===================================================================
  -- Fully constrained wrapper AXI4-Lite records
  -- ===================================================================
  -- These model the actual port widths found in
  -- common/wrappers/zynq-7000-wrapper.vhd and zynq-mpsoc-wrapper.vhd.
  -- All std_logic_vector elements have fixed widths, so Questa and
  -- Vivado accept the view declarations.
  -- ===================================================================

  -- ----------------------------------------------------------------
  --  M00_AXI, M01_AXI  (2x master, Zynq-7000)
  --  ADDR=32, DATA=32, user absent in wrapper (stubbed to 1-bit)
  -- ----------------------------------------------------------------
  type axilite_m_t is record
    -- Write Address channel
    awaddr  : std_logic_vector(31 downto 0); -- register address (32-bit)
    awprot  : std_logic_vector(2  downto 0); -- protection: privilege/security/instruction
    awuser  : std_logic;                      -- user sideband (1-bit stub)
    awvalid : std_logic;                      -- master: address+control valid
    awready : std_logic;                      -- slave: address accepted
    -- Write Data channel (32-bit data)
    wdata   : std_logic_vector(31 downto 0); -- write data (one beat, 32-bit)
    wstrb   : std_logic_vector(3  downto 0); -- byte enables (4 lanes)
    wuser   : std_logic;                      -- user sideband (1-bit stub)
    wvalid  : std_logic;                      -- master: data+strobe valid
    wready  : std_logic;                      -- slave: data accepted
    -- Write Response channel
    bresp   : std_logic_vector(1  downto 0); -- response: OKAY/SLVERR/DECERR
    buser   : std_logic;                      -- user sideband (1-bit stub)
    bvalid  : std_logic;                      -- slave: response valid
    bready  : std_logic;                      -- master: response accepted
    -- Read Address channel
    araddr  : std_logic_vector(31 downto 0); -- register address (32-bit)
    arprot  : std_logic_vector(2  downto 0); -- protection: privilege/security/instruction
    aruser  : std_logic;                      -- user sideband (1-bit stub)
    arvalid : std_logic;                      -- master: address+control valid
    arready : std_logic;                      -- slave: address accepted
    -- Read Data channel (32-bit data)
    rdata   : std_logic_vector(31 downto 0); -- read data (one beat, 32-bit)
    rresp   : std_logic_vector(1  downto 0); -- response: OKAY/SLVERR/DECERR
    ruser   : std_logic;                      -- user sideband (1-bit stub)
    rvalid  : std_logic;                      -- slave: data+response valid
    rready  : std_logic;                      -- master: data accepted
  end record;

  view master_m of axilite_m_t is
    -- AW channel
    awaddr, awprot, awuser, awvalid : out;
    awready : in;
    -- W channel
    wdata, wstrb, wuser, wvalid : out;
    wready : in;
    -- B channel
    bresp, buser, bvalid : in;
    bready : out;
    -- AR channel
    araddr, arprot, aruser, arvalid : out;
    arready : in;
    -- R channel
    rdata, rresp, ruser, rvalid : in;
    rready : out;
  end view;
  alias slave_m is master_m'converse;

  -- ----------------------------------------------------------------
  --  M00_AXI .. M07_AXI  (8x master, Zynq MPSoC)
  --  ADDR=40, DATA=32, user absent in wrapper (stubbed to 1-bit)
  -- ----------------------------------------------------------------
  type axilite_m40_t is record
    -- Write Address channel
    awaddr  : std_logic_vector(39 downto 0); -- register address (40-bit MPSoC)
    awprot  : std_logic_vector(2  downto 0); -- protection: privilege/security/instruction
    awuser  : std_logic;                      -- user sideband (1-bit stub)
    awvalid : std_logic;                      -- master: address+control valid
    awready : std_logic;                      -- slave: address accepted
    -- Write Data channel (32-bit data)
    wdata   : std_logic_vector(31 downto 0); -- write data (one beat, 32-bit)
    wstrb   : std_logic_vector(3  downto 0); -- byte enables (4 lanes)
    wuser   : std_logic;                      -- user sideband (1-bit stub)
    wvalid  : std_logic;                      -- master: data+strobe valid
    wready  : std_logic;                      -- slave: data accepted
    -- Write Response channel
    bresp   : std_logic_vector(1  downto 0); -- response: OKAY/SLVERR/DECERR
    buser   : std_logic;                      -- user sideband (1-bit stub)
    bvalid  : std_logic;                      -- slave: response valid
    bready  : std_logic;                      -- master: response accepted
    -- Read Address channel
    araddr  : std_logic_vector(39 downto 0); -- register address (40-bit MPSoC)
    arprot  : std_logic_vector(2  downto 0); -- protection: privilege/security/instruction
    aruser  : std_logic;                      -- user sideband (1-bit stub)
    arvalid : std_logic;                      -- master: address+control valid
    arready : std_logic;                      -- slave: address accepted
    -- Read Data channel (32-bit data)
    rdata   : std_logic_vector(31 downto 0); -- read data (one beat, 32-bit)
    rresp   : std_logic_vector(1  downto 0); -- response: OKAY/SLVERR/DECERR
    ruser   : std_logic;                      -- user sideband (1-bit stub)
    rvalid  : std_logic;                      -- slave: data+response valid
    rready  : std_logic;                      -- master: data accepted
  end record;

  view master_m40 of axilite_m40_t is
    -- AW channel
    awaddr, awprot, awuser, awvalid : out;
    awready : in;
    -- W channel
    wdata, wstrb, wuser, wvalid : out;
    wready : in;
    -- B channel
    bresp, buser, bvalid : in;
    bready : out;
    -- AR channel
    araddr, arprot, aruser, arvalid : out;
    arready : in;
    -- R channel
    rdata, rresp, ruser, rvalid : in;
    rready : out;
  end view;
  alias slave_m40 is master_m40'converse;

end package;
