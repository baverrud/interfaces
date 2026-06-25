-- =====================================================================
-- top_hp.vhd - AXI3 HP master + slave (fully constrained axi3_hp_t)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.axi3_pkg.all;

entity top_hp is
  generic (BURST_LEN: positive := 4; DEPTH: positive := 256);
  port (aclk, aresetn: in std_logic; done: out std_logic);
end entity;

architecture rtl of top_hp is
  signal hp_bus: axi3_hp_t;
begin
  u_master: entity work.axi3_master_hp
    generic map (BURST_LEN => BURST_LEN)
    port map (aclk => aclk, aresetn => aresetn, bus_m => hp_bus, done => done);
  u_slave: entity work.axi3_slave_hp
    generic map (DEPTH => DEPTH)
    port map (aclk => aclk, aresetn => aresetn, bus_s => hp_bus);
end architecture;
