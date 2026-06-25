-- =====================================================================
-- axi4_pkg.vhd - AXI4 records + VHDL-2019 mode views
-- =====================================================================
-- Both a unified axi4_t record (works in Vivado) and per-channel
-- sub-records (works in Questa 2025.2) are provided.
--
-- Per-channel records each have <=3 unconstrained elements, avoiding
-- Questa 2025.2's VHDL-2019 record constraint parser limit (~6).
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package axi4_pkg is

  -- ===================================================================
  -- Per-channel records (<=3 unconstrained elements each)
  -- ===================================================================

  -- Write Address channel (3 unconstrained: awid, awaddr, awuser)
  -- AXI4: awlen=8-bit (1-256 beats), awlock=1-bit, awregion present
  type axi4_aw_t is record
    awid     : std_logic_vector;              -- transaction ID
    awaddr   : std_logic_vector;              -- address of first transfer
    awlen    : std_logic_vector(7  downto 0); -- burst length: beats = awlen+1
    awsize   : std_logic_vector(2  downto 0); -- bytes per beat: 2^awsize
    awburst  : std_logic_vector(1  downto 0); -- burst type: FIXED/INCR/WRAP
    awlock   : std_logic;                     -- atomic access: 0=normal, 1=exclusive
    awcache  : std_logic_vector(3  downto 0); -- memory type hints
    awprot   : std_logic_vector(2  downto 0); -- protection: privilege/security/instruction
    awqos    : std_logic_vector(3  downto 0); -- Quality of Service
    awregion : std_logic_vector(3  downto 0); -- address region (AXI4 only)
    awuser   : std_logic_vector;              -- user-defined sideband (per-transaction)
    awvalid  : std_logic;                     -- address+control valid
    awready  : std_logic;                     -- slave: address accepted
  end record;

  -- Write Data channel (3 unconstrained: wdata, wstrb, wuser)
  -- AXI4: wid removed (unlike AXI3); write data only
  type axi4_w_t is record
    wdata  : std_logic_vector;             -- write data (one beat)
    wstrb  : std_logic_vector;             -- byte enables: wstrb[i] qualifies byte lane i
    wlast  : std_logic;                    -- last beat indicator
    wuser  : std_logic_vector;             -- user-defined sideband (per-beat)
    wvalid : std_logic;                    -- data+strobe valid
    wready : std_logic;                    -- slave: data accepted
  end record;

  -- Write Response channel (2 unconstrained: bid, buser)
  type axi4_b_t is record
    bid    : std_logic_vector;                -- response ID (echoed from awid)
    bresp  : std_logic_vector(1  downto 0);   -- response: OKAY/EXOKAY/SLVERR/DECERR
    buser  : std_logic_vector;                -- user-defined sideband (per-response)
    bvalid : std_logic;                       -- slave: response valid
    bready : std_logic;                       -- master: response accepted
  end record;

  -- Read Address channel (3 unconstrained: arid, araddr, aruser)
  type axi4_ar_t is record
    arid     : std_logic_vector;              -- transaction ID (tags read transaction)
    araddr   : std_logic_vector;              -- address of first transfer
    arlen    : std_logic_vector(7  downto 0); -- burst length: beats = arlen+1
    arsize   : std_logic_vector(2  downto 0); -- bytes per beat: 2^arsize
    arburst  : std_logic_vector(1  downto 0); -- burst type: FIXED/INCR/WRAP
    arlock   : std_logic;                     -- atomic access: 0=normal, 1=exclusive
    arcache  : std_logic_vector(3  downto 0); -- memory type hints
    arprot   : std_logic_vector(2  downto 0); -- protection: privilege/security/instruction
    arqos    : std_logic_vector(3  downto 0); -- Quality of Service
    arregion : std_logic_vector(3  downto 0); -- address region (AXI4 only)
    aruser   : std_logic_vector;              -- user-defined sideband (per-transaction)
    arvalid  : std_logic;                     -- address+control valid
    arready  : std_logic;                     -- slave: address accepted
  end record;

  -- Read Data channel (3 unconstrained: rid, rdata, ruser)
  type axi4_r_t is record
    rid    : std_logic_vector;                -- read ID (echoed from arid)
    rdata  : std_logic_vector;                -- read data (one beat)
    rresp  : std_logic_vector(1  downto 0);   -- response: OKAY/EXOKAY/SLVERR/DECERR
    rlast  : std_logic;                       -- last beat indicator
    ruser  : std_logic_vector;                -- user-defined sideband (per-beat)
    rvalid : std_logic;                       -- slave: data+response valid
    rready : std_logic;                       -- master: data accepted
  end record;

  -- ===================================================================
  -- Per-channel mode views
  -- ===================================================================

  view master_aw of axi4_aw_t is
    awid, awaddr, awlen, awsize, awburst, awlock,
    awcache, awprot, awqos, awregion, awuser,
    awvalid : out;
    awready : in;
  end view;
  alias slave_aw is master_aw'converse;

  view master_w of axi4_w_t is
    wdata, wstrb, wlast, wuser, wvalid : out;
    wready : in;
  end view;
  alias slave_w is master_w'converse;

  view master_b of axi4_b_t is
    bid, bresp, buser, bvalid : in;
    bready : out;
  end view;
  alias slave_b is master_b'converse;

  view master_ar of axi4_ar_t is
    arid, araddr, arlen, arsize, arburst, arlock,
    arcache, arprot, arqos, arregion, aruser,
    arvalid : out;
    arready : in;
  end view;
  alias slave_ar is master_ar'converse;

  view master_r of axi4_r_t is
    rid, rdata, rresp, rlast, ruser, rvalid : in;
    rready : out;
  end view;
  alias slave_r is master_r'converse;

  -- ===================================================================
  -- Unified record -- UNCONSTRAINED vectors, intentionally broken
  -- (too many unconstrained elements for Questa / Vivado parsers)
  -- ===================================================================

  type axi4_t is record
    -- Write Address channel
    awid     : std_logic_vector;              -- transaction ID
    awaddr   : std_logic_vector;              -- address of first transfer
    awlen    : std_logic_vector(7  downto 0); -- burst length: beats = awlen+1
    awsize   : std_logic_vector(2  downto 0); -- bytes per beat: 2^awsize
    awburst  : std_logic_vector(1  downto 0); -- burst type: FIXED/INCR/WRAP
    awlock   : std_logic;                     -- atomic access: 0=normal, 1=exclusive
    awcache  : std_logic_vector(3  downto 0); -- memory type hints
    awprot   : std_logic_vector(2  downto 0); -- protection: privilege/security/instruction
    awqos    : std_logic_vector(3  downto 0); -- Quality of Service
    awregion : std_logic_vector(3  downto 0); -- address region (AXI4 only)
    awuser   : std_logic_vector;              -- user-defined sideband (per-transaction)
    awvalid  : std_logic;                     -- address+control valid
    awready  : std_logic;                     -- slave: address accepted
    -- Write Data channel
    wdata    : std_logic_vector;              -- write data (one beat)
    wstrb    : std_logic_vector;              -- byte enables
    wlast    : std_logic;                     -- last beat indicator
    wuser    : std_logic_vector;              -- user-defined sideband (per-beat)
    wvalid   : std_logic;                     -- data+strobe valid
    wready   : std_logic;                     -- slave: data accepted
    -- Write Response channel
    bid      : std_logic_vector;              -- response ID (echoed from awid)
    bresp    : std_logic_vector(1  downto 0); -- response code
    buser    : std_logic_vector;              -- user-defined sideband (per-response)
    bvalid   : std_logic;                     -- slave: response valid
    bready   : std_logic;                     -- master: response accepted
    -- Read Address channel
    arid     : std_logic_vector;              -- transaction ID
    araddr   : std_logic_vector;              -- address of first transfer
    arlen    : std_logic_vector(7  downto 0); -- burst length: beats = arlen+1
    arsize   : std_logic_vector(2  downto 0); -- bytes per beat: 2^arsize
    arburst  : std_logic_vector(1  downto 0); -- burst type: FIXED/INCR/WRAP
    arlock   : std_logic;                     -- atomic access
    arcache  : std_logic_vector(3  downto 0); -- memory type hints
    arprot   : std_logic_vector(2  downto 0); -- protection
    arqos    : std_logic_vector(3  downto 0); -- Quality of Service
    arregion : std_logic_vector(3  downto 0); -- address region (AXI4 only)
    aruser   : std_logic_vector;              -- user-defined sideband
    arvalid  : std_logic;                     -- address+control valid
    arready  : std_logic;                     -- slave: address accepted
    -- Read Data channel
    rid      : std_logic_vector;              -- read ID (echoed from arid)
    rdata    : std_logic_vector;              -- read data (one beat)
    rresp    : std_logic_vector(1  downto 0); -- response code
    rlast    : std_logic;                     -- last beat indicator
    ruser    : std_logic_vector;              -- user-defined sideband (per-beat)
    rvalid   : std_logic;                     -- slave: data+response valid
    rready   : std_logic;                     -- master: data accepted
  end record;

  view master of axi4_t is
    -- AW channel
    awid, awaddr, awlen, awsize, awburst, awlock,
    awcache, awprot, awqos, awregion, awuser,
    awvalid : out;
    awready : in;
    -- W channel
    wdata, wstrb, wlast, wuser, wvalid : out;
    wready : in;
    -- B channel
    bid, bresp, buser, bvalid : in;
    bready : out;
    -- AR channel
    arid, araddr, arlen, arsize, arburst, arlock,
    arcache, arprot, arqos, arregion, aruser,
    arvalid : out;
    arready : in;
    -- R channel
    rid, rdata, rresp, rlast, ruser, rvalid : in;
    rready : out;
  end view;
  alias slave is master'converse;

  -- ===================================================================
  -- Fully constrained Zynq MPSoC wrapper AXI4 records
  -- ===================================================================
  -- These model the actual port widths found in
  -- common/wrappers/zynq-mpsoc-wrapper.vhd.  All std_logic_vector
  -- elements have fixed widths, so Questa and Vivado accept the view
  -- declarations.
  -- ===================================================================

  -- ----------------------------------------------------------------
  --  S_AXI_HP0_FPD .. S_AXI_HP3_FPD  (4x HP slave, FPD domain)
  --  S_AXI_HPC0_FPD, S_AXI_HPC1_FPD  (2x HPC slave, FPD domain)
  --  S_AXI_LPD                         (1x LPD slave)
  --  ID=6, ADDR=49, DATA=128, awuser/aruser=std_logic
  -- ----------------------------------------------------------------
  type axi4_hp_t is record
    -- Write Address channel
    awid    : std_logic_vector(5  downto 0);  -- transaction ID
    awaddr  : std_logic_vector(48 downto 0);  -- address of first transfer (49-bit)
    awlen   : std_logic_vector(7  downto 0);  -- burst length: beats = awlen+1
    awsize  : std_logic_vector(2  downto 0);  -- bytes per beat: 2^awsize
    awburst : std_logic_vector(1  downto 0);  -- burst type: FIXED/INCR/WRAP
    awlock  : std_logic;                       -- atomic access: 0=normal, 1=exclusive
    awcache : std_logic_vector(3  downto 0);  -- memory type hints
    awprot  : std_logic_vector(2  downto 0);  -- protection: privilege/security/instruction
    awqos   : std_logic_vector(3  downto 0);  -- Quality of Service
    awuser  : std_logic;                       -- user sideband (1-bit in MPSoC HP)
    awvalid : std_logic;                       -- address+control valid
    awready : std_logic;                       -- slave: address accepted
    -- Write Data channel (128-bit for HP port)
    wdata   : std_logic_vector(127 downto 0); -- write data (one beat, 128-bit)
    wstrb   : std_logic_vector(15 downto 0);  -- byte enables (16 lanes)
    wlast   : std_logic;                       -- last beat indicator
    wvalid  : std_logic;                       -- data+strobe valid
    wready  : std_logic;                       -- slave: data accepted
    -- Write Response channel
    bid     : std_logic_vector(5  downto 0);  -- response ID
    bresp   : std_logic_vector(1  downto 0);  -- response: OKAY/EXOKAY/SLVERR/DECERR
    bvalid  : std_logic;                       -- slave: response valid
    bready  : std_logic;                       -- master: response accepted
    -- Read Address channel
    arid    : std_logic_vector(5  downto 0);  -- transaction ID
    araddr  : std_logic_vector(48 downto 0);  -- address of first transfer (49-bit)
    arlen   : std_logic_vector(7  downto 0);  -- burst length: beats = arlen+1
    arsize  : std_logic_vector(2  downto 0);  -- bytes per beat: 2^arsize
    arburst : std_logic_vector(1  downto 0);  -- burst type: FIXED/INCR/WRAP
    arlock  : std_logic;                       -- atomic access
    arcache : std_logic_vector(3  downto 0);  -- memory type hints
    arprot  : std_logic_vector(2  downto 0);  -- protection
    arqos   : std_logic_vector(3  downto 0);  -- Quality of Service
    aruser  : std_logic;                       -- user sideband (1-bit)
    arvalid : std_logic;                       -- address+control valid
    arready : std_logic;                       -- slave: address accepted
    -- Read Data channel (128-bit for HP port)
    rid     : std_logic_vector(5  downto 0);  -- read ID
    rdata   : std_logic_vector(127 downto 0); -- read data (one beat, 128-bit)
    rresp   : std_logic_vector(1  downto 0);  -- response: OKAY/EXOKAY/SLVERR/DECERR
    rlast   : std_logic;                       -- last beat indicator
    rvalid  : std_logic;                       -- slave: data+response valid
    rready  : std_logic;                       -- master: data accepted
  end record;

  view master_hp of axi4_hp_t is
    -- AW channel
    awid, awaddr, awlen, awsize, awburst, awlock,
    awcache, awprot, awqos, awuser, awvalid : out;
    awready : in;
    -- W channel
    wdata, wstrb, wlast, wvalid : out;
    wready : in;
    -- B channel
    bid, bresp, bvalid : in;
    bready : out;
    -- AR channel
    arid, araddr, arlen, arsize, arburst, arlock,
    arcache, arprot, arqos, aruser, arvalid : out;
    arready : in;
    -- R channel
    rid, rdata, rresp, rlast, rvalid : in;
    rready : out;
  end view;
  alias slave_hp is master_hp'converse;

  -- ----------------------------------------------------------------
  --  M_AXI_HPM0_FPD  (1x master, FPD domain)
  --  ID=16, ADDR=40, DATA=128, awuser/aruser=16
  -- ----------------------------------------------------------------
  type axi4_hpm_fpd_t is record
    -- Write Address channel
    awid    : std_logic_vector(15 downto 0); -- transaction ID (16-bit for HPM)
    awaddr  : std_logic_vector(39 downto 0); -- address of first transfer (40-bit)
    awlen   : std_logic_vector(7  downto 0); -- burst length: beats = awlen+1
    awsize  : std_logic_vector(2  downto 0); -- bytes per beat: 2^awsize
    awburst : std_logic_vector(1  downto 0); -- burst type: FIXED/INCR/WRAP
    awlock  : std_logic;                      -- atomic access: 0=normal, 1=exclusive
    awcache : std_logic_vector(3  downto 0); -- memory type hints
    awprot  : std_logic_vector(2  downto 0); -- protection: privilege/security/instruction
    awqos   : std_logic_vector(3  downto 0); -- Quality of Service
    awuser  : std_logic_vector(15 downto 0); -- user sideband (16-bit on HPM)
    awvalid : std_logic;                      -- address+control valid
    awready : std_logic;                      -- slave: address accepted
    -- Write Data channel (128-bit for FPD master)
    wdata   : std_logic_vector(127 downto 0);-- write data (one beat, 128-bit)
    wstrb   : std_logic_vector(15 downto 0); -- byte enables (16 lanes)
    wlast   : std_logic;                      -- last beat indicator
    wvalid  : std_logic;                      -- data+strobe valid
    wready  : std_logic;                      -- slave: data accepted
    -- Write Response channel
    bid     : std_logic_vector(15 downto 0); -- response ID (16-bit)
    bresp   : std_logic_vector(1  downto 0); -- response: OKAY/EXOKAY/SLVERR/DECERR
    bvalid  : std_logic;                      -- slave: response valid
    bready  : std_logic;                      -- master: response accepted
    -- Read Address channel
    arid    : std_logic_vector(15 downto 0); -- transaction ID (16-bit)
    araddr  : std_logic_vector(39 downto 0); -- address of first transfer (40-bit)
    arlen   : std_logic_vector(7  downto 0); -- burst length: beats = arlen+1
    arsize  : std_logic_vector(2  downto 0); -- bytes per beat: 2^arsize
    arburst : std_logic_vector(1  downto 0); -- burst type: FIXED/INCR/WRAP
    arlock  : std_logic;                      -- atomic access
    arcache : std_logic_vector(3  downto 0); -- memory type hints
    arprot  : std_logic_vector(2  downto 0); -- protection
    arqos   : std_logic_vector(3  downto 0); -- Quality of Service
    aruser  : std_logic_vector(15 downto 0); -- user sideband (16-bit on HPM)
    arvalid : std_logic;                      -- address+control valid
    arready : std_logic;                      -- slave: address accepted
    -- Read Data channel (128-bit for FPD master)
    rid     : std_logic_vector(15 downto 0); -- read ID (16-bit)
    rdata   : std_logic_vector(127 downto 0);-- read data (one beat, 128-bit)
    rresp   : std_logic_vector(1  downto 0); -- response: OKAY/EXOKAY/SLVERR/DECERR
    rlast   : std_logic;                      -- last beat indicator
    rvalid  : std_logic;                      -- slave: data+response valid
    rready  : std_logic;                      -- master: data accepted
  end record;

  view master_hpm_fpd of axi4_hpm_fpd_t is
    -- AW channel
    awid, awaddr, awlen, awsize, awburst, awlock,
    awcache, awprot, awqos, awuser, awvalid : out;
    awready : in;
    -- W channel
    wdata, wstrb, wlast, wvalid : out;
    wready : in;
    -- B channel
    bid, bresp, bvalid : in;
    bready : out;
    -- AR channel
    arid, araddr, arlen, arsize, arburst, arlock,
    arcache, arprot, arqos, aruser, arvalid : out;
    arready : in;
    -- R channel
    rid, rdata, rresp, rlast, rvalid : in;
    rready : out;
  end view;
  alias slave_hpm_fpd is master_hpm_fpd'converse;

  -- ----------------------------------------------------------------
  --  M_AXI_HPM0_LPD  (1x master, LPD domain)
  --  ID=16, ADDR=40, DATA=32, awuser/aruser=16, wstrb=4
  -- ----------------------------------------------------------------
  type axi4_hpm_lpd_t is record
    -- Write Address channel
    awid    : std_logic_vector(15 downto 0); -- transaction ID (16-bit for HPM)
    awaddr  : std_logic_vector(39 downto 0); -- address of first transfer (40-bit)
    awlen   : std_logic_vector(7  downto 0); -- burst length: beats = awlen+1
    awsize  : std_logic_vector(2  downto 0); -- bytes per beat: 2^awsize
    awburst : std_logic_vector(1  downto 0); -- burst type: FIXED/INCR/WRAP
    awlock  : std_logic;                      -- atomic access: 0=normal, 1=exclusive
    awcache : std_logic_vector(3  downto 0); -- memory type hints
    awprot  : std_logic_vector(2  downto 0); -- protection: privilege/security/instruction
    awqos   : std_logic_vector(3  downto 0); -- Quality of Service
    awuser  : std_logic_vector(15 downto 0); -- user sideband (16-bit on HPM)
    awvalid : std_logic;                      -- address+control valid
    awready : std_logic;                      -- slave: address accepted
    -- Write Data channel (32-bit for LPD master)
    wdata   : std_logic_vector(31 downto 0); -- write data (one beat, 32-bit)
    wstrb   : std_logic_vector(3  downto 0); -- byte enables (4 lanes)
    wlast   : std_logic;                      -- last beat indicator
    wvalid  : std_logic;                      -- data+strobe valid
    wready  : std_logic;                      -- slave: data accepted
    -- Write Response channel
    bid     : std_logic_vector(15 downto 0); -- response ID (16-bit)
    bresp   : std_logic_vector(1  downto 0); -- response: OKAY/EXOKAY/SLVERR/DECERR
    bvalid  : std_logic;                      -- slave: response valid
    bready  : std_logic;                      -- master: response accepted
    -- Read Address channel
    arid    : std_logic_vector(15 downto 0); -- transaction ID (16-bit)
    araddr  : std_logic_vector(39 downto 0); -- address of first transfer (40-bit)
    arlen   : std_logic_vector(7  downto 0); -- burst length: beats = arlen+1
    arsize  : std_logic_vector(2  downto 0); -- bytes per beat: 2^arsize
    arburst : std_logic_vector(1  downto 0); -- burst type: FIXED/INCR/WRAP
    arlock  : std_logic;                      -- atomic access
    arcache : std_logic_vector(3  downto 0); -- memory type hints
    arprot  : std_logic_vector(2  downto 0); -- protection
    arqos   : std_logic_vector(3  downto 0); -- Quality of Service
    aruser  : std_logic_vector(15 downto 0); -- user sideband (16-bit on HPM)
    arvalid : std_logic;                      -- address+control valid
    arready : std_logic;                      -- slave: address accepted
    -- Read Data channel (32-bit for LPD master)
    rid     : std_logic_vector(15 downto 0); -- read ID (16-bit)
    rdata   : std_logic_vector(31 downto 0); -- read data (one beat, 32-bit)
    rresp   : std_logic_vector(1  downto 0); -- response: OKAY/EXOKAY/SLVERR/DECERR
    rlast   : std_logic;                      -- last beat indicator
    rvalid  : std_logic;                      -- slave: data+response valid
    rready  : std_logic;                      -- master: data accepted
  end record;

  view master_hpm_lpd of axi4_hpm_lpd_t is
    -- AW channel
    awid, awaddr, awlen, awsize, awburst, awlock,
    awcache, awprot, awqos, awuser, awvalid : out;
    awready : in;
    -- W channel
    wdata, wstrb, wlast, wvalid : out;
    wready : in;
    -- B channel
    bid, bresp, bvalid : in;
    bready : out;
    -- AR channel
    arid, araddr, arlen, arsize, arburst, arlock,
    arcache, arprot, arqos, aruser, arvalid : out;
    arready : in;
    -- R channel
    rid, rdata, rresp, rlast, rvalid : in;
    rready : out;
  end view;
  alias slave_hpm_lpd is master_hpm_lpd'converse;

end package;
