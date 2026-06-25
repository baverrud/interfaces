-- =====================================================================
-- top_unified.vhd - full AXI3 master + slave (unified axi3_t bus)
-- =====================================================================
--
-- !!! INTENTIONALLY BROKEN -- kept as a test case for future tool versions. !!!
--
-- Instantiates axi3_master_unified and axi3_slave_unified, which use
-- `view master of axi3_t` / `view slave of axi3_t` on the unconstrained
-- axi3_t record.  Both Questa and Vivado reject this because the record
-- has too many unconstrained std_logic_vector elements (>6).
--
-- When a future tool version lifts this limit, this design should compile
-- and simulate identically to the per-channel `top.vhd`.
--
-- For a WORKING unified-record example, see `top_hp.vhd` (fully
-- constrained axi3_hp_t record modeled on the Zynq-7000 HP port).
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.axi3_pkg.all;

entity top_unified is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; ID_W: positive:=4; BURST_LEN: positive:=4; DEPTH: positive:=256);
  port (aclk, aresetn: in std_logic; rd_data: out std_logic_vector(DATA_W-1 downto 0); rd_valid, done: out std_logic);
end entity;

architecture rtl of top_unified is
  signal axi_bus: axi3_t(
    awid(ID_W-1 downto 0),
    awaddr(ADDR_W-1 downto 0),
    awuser(0 downto 0),
    wid(ID_W-1 downto 0),
    wdata(DATA_W-1 downto 0),
    wstrb(DATA_W/8-1 downto 0),
    wuser(0 downto 0),
    bid(ID_W-1 downto 0),
    buser(0 downto 0),
    arid(ID_W-1 downto 0),
    araddr(ADDR_W-1 downto 0),
    aruser(0 downto 0),
    rid(ID_W-1 downto 0),
    rdata(DATA_W-1 downto 0),
    ruser(0 downto 0)
  );
begin
  u_master: entity work.axi3_master_unified
    generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,BURST_LEN=>BURST_LEN)
    port map(aclk=>aclk,aresetn=>aresetn,m=>axi_bus,
         rd_data=>rd_data,rd_valid=>rd_valid,done=>done);
  u_slave: entity work.axi3_slave_unified
    generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,DEPTH=>DEPTH)
    port map(aclk=>aclk,aresetn=>aresetn,s=>axi_bus);
end architecture;
