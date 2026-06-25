-- =====================================================================
-- top_m40.vhd - AXI4-Lite master + slave (axilite_m40_t composite)
-- =====================================================================
-- Top-level integration of axilite_master_m40 and axilite_slave_m40
-- connected via a single axilite_m40_t bus signal.  Demonstrates the
-- fully constrained composite bus view with 40-bit address and 32-bit
-- data for Zynq MPSoC M00_AXI...M07_AXI AXI4-Lite port compatibility.
--
-- Interface demo: `axilite_m40_t` is a fully constrained record whose
-- widths match the MPSoC wrapper ports (see common/wrappers/).  The
-- `slave_m40` view is `master_m40'converse` from axilite_pkg.  Because
-- all vector widths are fixed, this record compiles in both Questa and
-- Vivado without record-constraint issues.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.axilite_pkg.all;

entity top_m40 is
  generic (DEPTH: positive := 256);
  port (aclk, aresetn: in std_logic;
      rd_data: out std_logic_vector(31 downto 0); rd_valid, done: out std_logic);
end entity;

architecture rtl of top_m40 is
  -- Single axilite_m40_t bus connecting master and slave
  signal m40_bus: axilite_m40_t;
begin
  u_master: entity work.axilite_master_m40
    port map (aclk=>aclk, aresetn=>aresetn, bus_m=>m40_bus,
         rd_data=>rd_data, rd_valid=>rd_valid, done=>done);
  u_slave: entity work.axilite_slave_m40
    generic map (DEPTH=>DEPTH)
    port map (aclk=>aclk, aresetn=>aresetn, bus_s=>m40_bus);
end architecture;
