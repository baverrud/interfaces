-- =====================================================================
-- top.vhd - full AXI4 master + slave (per-channel signals)
-- =====================================================================
-- Top-level integration of axi4_master (full master) and axi4_slave
-- (full register-file slave) connected via per-channel record signals.
-- The master autonomously runs a write burst then a read burst; the
-- slave stores and returns the data.
--
-- Interface demo: examine the port connections below.  Each sub-module
-- receives only the channel views it needs (master_aw, slave_aw, etc.),
-- which are aliased via `'converse` in axi4_pkg.  The internal FSM logic
-- is a simple test sequencer — the main lesson is the signal routing.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.axi4_pkg.all;

entity top is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; ID_W: positive:=4; BURST_LEN: positive:=4; DEPTH: positive:=256);
  port (aclk, aresetn: in std_logic; rd_data: out std_logic_vector(DATA_W-1 downto 0); rd_valid, done: out std_logic);
end entity;

architecture rtl of top is
  -- Per-channel AXI4 bus signals with constrained vector widths
  signal aw_bus: axi4_aw_t(awid(ID_W-1 downto 0),awaddr(ADDR_W-1 downto 0),awuser(0 downto 0));
  signal w_bus:  axi4_w_t(wdata(DATA_W-1 downto 0),wstrb(DATA_W/8-1 downto 0),wuser(0 downto 0));
  signal b_bus:  axi4_b_t(bid(ID_W-1 downto 0),buser(0 downto 0));
  signal ar_bus: axi4_ar_t(arid(ID_W-1 downto 0),araddr(ADDR_W-1 downto 0),aruser(0 downto 0));
  signal r_bus:  axi4_r_t(rid(ID_W-1 downto 0),rdata(DATA_W-1 downto 0),ruser(0 downto 0));
begin
  -- AXI4 master: write burst then read burst, outputs read data
  u_master: entity work.axi4_master
    generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,BURST_LEN=>BURST_LEN)
    port map(aclk=>aclk,aresetn=>aresetn,aw=>aw_bus,w=>w_bus,b=>b_bus,ar=>ar_bus,r=>r_bus,
         rd_data=>rd_data,rd_valid=>rd_valid,done=>done);
  -- AXI4 slave: register-file memory responding to both write and read bursts
  u_slave: entity work.axi4_slave
    generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,DEPTH=>DEPTH)
    port map(aclk=>aclk,aresetn=>aresetn,aw=>aw_bus,w=>w_bus,b=>b_bus,ar=>ar_bus,r=>r_bus);
end architecture;
