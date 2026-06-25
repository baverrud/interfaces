-- =====================================================================
-- top_hp.vhd - AXI4 HP master + slave (fully constrained axi4_hp_t)
-- =====================================================================
-- Top-level integration of axi4_master_hp and axi4_slave_hp connected
-- via a single axi4_hp_t bus signal.  Demonstrates the fully
-- constrained composite bus view with 128-bit data, 49-bit address,
-- and 6-bit ID for Zynq HP port compatibility.
--
-- Interface demo: `axi4_hp_t` is a fully constrained record whose widths
-- match the Zynq MPSoC HP wrapper ports (see common/wrappers/).  The
-- `slave_hp` view is `master_hp'converse` from axi4_pkg.  Because all
-- vector widths are fixed, this record compiles in both Questa and Vivado
-- without record-constraint issues.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.axi4_pkg.all;

entity top_hp is
  generic (BURST_LEN: positive := 4; DEPTH: positive := 256);
  port (aclk, aresetn: in std_logic; done: out std_logic);
end entity;

architecture rtl of top_hp is
  -- Single axi4_hp_t bus connecting master and slave
  signal hp_bus: axi4_hp_t;
begin
  u_master: entity work.axi4_master_hp
    generic map (BURST_LEN => BURST_LEN)
    port map (aclk => aclk, aresetn => aresetn, bus_m => hp_bus, done => done);
  u_slave: entity work.axi4_slave_hp
    generic map (DEPTH => DEPTH)
    port map (aclk => aclk, aresetn => aresetn, bus_s => hp_bus);
end architecture;
