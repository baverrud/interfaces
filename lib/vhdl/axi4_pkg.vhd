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

  -- Write Address (3 unconstrained)
  type axi4_aw_t is record
    awid     : std_logic_vector;
    awaddr   : std_logic_vector;
    awlen    : std_logic_vector(7  downto 0);
    awsize   : std_logic_vector(2  downto 0);
    awburst  : std_logic_vector(1  downto 0);
    awlock   : std_logic;
    awcache  : std_logic_vector(3  downto 0);
    awprot   : std_logic_vector(2  downto 0);
    awqos    : std_logic_vector(3  downto 0);
    awregion : std_logic_vector(3  downto 0);
    awuser   : std_logic_vector;
    awvalid  : std_logic;
    awready  : std_logic;
  end record;

  -- Write Data (3 unconstrained)
  type axi4_w_t is record
    wdata  : std_logic_vector;
    wstrb  : std_logic_vector;
    wlast  : std_logic;
    wuser  : std_logic_vector;
    wvalid : std_logic;
    wready : std_logic;
  end record;

  -- Write Response (2 unconstrained)
  type axi4_b_t is record
    bid    : std_logic_vector;
    bresp  : std_logic_vector(1  downto 0);
    buser  : std_logic_vector;
    bvalid : std_logic;
    bready : std_logic;
  end record;

  -- Read Address (3 unconstrained)
  type axi4_ar_t is record
    arid     : std_logic_vector;
    araddr   : std_logic_vector;
    arlen    : std_logic_vector(7  downto 0);
    arsize   : std_logic_vector(2  downto 0);
    arburst  : std_logic_vector(1  downto 0);
    arlock   : std_logic;
    arcache  : std_logic_vector(3  downto 0);
    arprot   : std_logic_vector(2  downto 0);
    arqos    : std_logic_vector(3  downto 0);
    arregion : std_logic_vector(3  downto 0);
    aruser   : std_logic_vector;
    arvalid  : std_logic;
    arready  : std_logic;
  end record;

  -- Read Data (3 unconstrained)
  type axi4_r_t is record
    rid    : std_logic_vector;
    rdata  : std_logic_vector;
    rresp  : std_logic_vector(1  downto 0);
    rlast  : std_logic;
    ruser  : std_logic_vector;
    rvalid : std_logic;
    rready : std_logic;
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
    -- Write Address
    awid     : std_logic_vector;
    awaddr   : std_logic_vector;
    awlen    : std_logic_vector(7  downto 0);
    awsize   : std_logic_vector(2  downto 0);
    awburst  : std_logic_vector(1  downto 0);
    awlock   : std_logic;
    awcache  : std_logic_vector(3  downto 0);
    awprot   : std_logic_vector(2  downto 0);
    awqos    : std_logic_vector(3  downto 0);
    awregion : std_logic_vector(3  downto 0);
    awuser   : std_logic_vector;
    awvalid  : std_logic;
    awready  : std_logic;
    -- Write Data
    wdata    : std_logic_vector;
    wstrb    : std_logic_vector;
    wlast    : std_logic;
    wuser    : std_logic_vector;
    wvalid   : std_logic;
    wready   : std_logic;
    -- Write Response
    bid      : std_logic_vector;
    bresp    : std_logic_vector(1  downto 0);
    buser    : std_logic_vector;
    bvalid   : std_logic;
    bready   : std_logic;
    -- Read Address
    arid     : std_logic_vector;
    araddr   : std_logic_vector;
    arlen    : std_logic_vector(7  downto 0);
    arsize   : std_logic_vector(2  downto 0);
    arburst  : std_logic_vector(1  downto 0);
    arlock   : std_logic;
    arcache  : std_logic_vector(3  downto 0);
    arprot   : std_logic_vector(2  downto 0);
    arqos    : std_logic_vector(3  downto 0);
    arregion : std_logic_vector(3  downto 0);
    aruser   : std_logic_vector;
    arvalid  : std_logic;
    arready  : std_logic;
    -- Read Data
    rid      : std_logic_vector;
    rdata    : std_logic_vector;
    rresp    : std_logic_vector(1  downto 0);
    rlast    : std_logic;
    ruser    : std_logic_vector;
    rvalid   : std_logic;
    rready   : std_logic;
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
    -- Write Address
    awid    : std_logic_vector(5  downto 0);
    awaddr  : std_logic_vector(48 downto 0);
    awlen   : std_logic_vector(7  downto 0);
    awsize  : std_logic_vector(2  downto 0);
    awburst : std_logic_vector(1  downto 0);
    awlock  : std_logic;
    awcache : std_logic_vector(3  downto 0);
    awprot  : std_logic_vector(2  downto 0);
    awqos   : std_logic_vector(3  downto 0);
    awuser  : std_logic;
    awvalid : std_logic;
    awready : std_logic;
    -- Write Data
    wdata   : std_logic_vector(127 downto 0);
    wstrb   : std_logic_vector(15 downto 0);
    wlast   : std_logic;
    wvalid  : std_logic;
    wready  : std_logic;
    -- Write Response
    bid     : std_logic_vector(5  downto 0);
    bresp   : std_logic_vector(1  downto 0);
    bvalid  : std_logic;
    bready  : std_logic;
    -- Read Address
    arid    : std_logic_vector(5  downto 0);
    araddr  : std_logic_vector(48 downto 0);
    arlen   : std_logic_vector(7  downto 0);
    arsize  : std_logic_vector(2  downto 0);
    arburst : std_logic_vector(1  downto 0);
    arlock  : std_logic;
    arcache : std_logic_vector(3  downto 0);
    arprot  : std_logic_vector(2  downto 0);
    arqos   : std_logic_vector(3  downto 0);
    aruser  : std_logic;
    arvalid : std_logic;
    arready : std_logic;
    -- Read Data
    rid     : std_logic_vector(5  downto 0);
    rdata   : std_logic_vector(127 downto 0);
    rresp   : std_logic_vector(1  downto 0);
    rlast   : std_logic;
    rvalid  : std_logic;
    rready  : std_logic;
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
    -- Write Address
    awid    : std_logic_vector(15 downto 0);
    awaddr  : std_logic_vector(39 downto 0);
    awlen   : std_logic_vector(7  downto 0);
    awsize  : std_logic_vector(2  downto 0);
    awburst : std_logic_vector(1  downto 0);
    awlock  : std_logic;
    awcache : std_logic_vector(3  downto 0);
    awprot  : std_logic_vector(2  downto 0);
    awqos   : std_logic_vector(3  downto 0);
    awuser  : std_logic_vector(15 downto 0);
    awvalid : std_logic;
    awready : std_logic;
    -- Write Data
    wdata   : std_logic_vector(127 downto 0);
    wstrb   : std_logic_vector(15 downto 0);
    wlast   : std_logic;
    wvalid  : std_logic;
    wready  : std_logic;
    -- Write Response
    bid     : std_logic_vector(15 downto 0);
    bresp   : std_logic_vector(1  downto 0);
    bvalid  : std_logic;
    bready  : std_logic;
    -- Read Address
    arid    : std_logic_vector(15 downto 0);
    araddr  : std_logic_vector(39 downto 0);
    arlen   : std_logic_vector(7  downto 0);
    arsize  : std_logic_vector(2  downto 0);
    arburst : std_logic_vector(1  downto 0);
    arlock  : std_logic;
    arcache : std_logic_vector(3  downto 0);
    arprot  : std_logic_vector(2  downto 0);
    arqos   : std_logic_vector(3  downto 0);
    aruser  : std_logic_vector(15 downto 0);
    arvalid : std_logic;
    arready : std_logic;
    -- Read Data
    rid     : std_logic_vector(15 downto 0);
    rdata   : std_logic_vector(127 downto 0);
    rresp   : std_logic_vector(1  downto 0);
    rlast   : std_logic;
    rvalid  : std_logic;
    rready  : std_logic;
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
    -- Write Address
    awid    : std_logic_vector(15 downto 0);
    awaddr  : std_logic_vector(39 downto 0);
    awlen   : std_logic_vector(7  downto 0);
    awsize  : std_logic_vector(2  downto 0);
    awburst : std_logic_vector(1  downto 0);
    awlock  : std_logic;
    awcache : std_logic_vector(3  downto 0);
    awprot  : std_logic_vector(2  downto 0);
    awqos   : std_logic_vector(3  downto 0);
    awuser  : std_logic_vector(15 downto 0);
    awvalid : std_logic;
    awready : std_logic;
    -- Write Data
    wdata   : std_logic_vector(31 downto 0);
    wstrb   : std_logic_vector(3  downto 0);
    wlast   : std_logic;
    wvalid  : std_logic;
    wready  : std_logic;
    -- Write Response
    bid     : std_logic_vector(15 downto 0);
    bresp   : std_logic_vector(1  downto 0);
    bvalid  : std_logic;
    bready  : std_logic;
    -- Read Address
    arid    : std_logic_vector(15 downto 0);
    araddr  : std_logic_vector(39 downto 0);
    arlen   : std_logic_vector(7  downto 0);
    arsize  : std_logic_vector(2  downto 0);
    arburst : std_logic_vector(1  downto 0);
    arlock  : std_logic;
    arcache : std_logic_vector(3  downto 0);
    arprot  : std_logic_vector(2  downto 0);
    arqos   : std_logic_vector(3  downto 0);
    aruser  : std_logic_vector(15 downto 0);
    arvalid : std_logic;
    arready : std_logic;
    -- Read Data
    rid     : std_logic_vector(15 downto 0);
    rdata   : std_logic_vector(31 downto 0);
    rresp   : std_logic_vector(1  downto 0);
    rlast   : std_logic;
    rvalid  : std_logic;
    rready  : std_logic;
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
