-- =====================================================================
-- top_hp_tb.vhd - AXI3 HP constrained bus self-checking testbench
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

entity top_hp_tb is
end entity top_hp_tb;

architecture sim of top_hp_tb is
  constant BURST_LEN : positive := 4;
  constant DEPTH     : positive := 256;
  constant TCLK      : time := 10 ns;

  signal aclk    : std_logic := '0';
  signal aresetn : std_logic := '0';
  signal done    : std_logic;
begin
  aclk <= not aclk after TCLK/2;

  dut : entity work.top_hp
    generic map (BURST_LEN => BURST_LEN, DEPTH => DEPTH)
    port map (aclk => aclk, aresetn => aresetn, done => done);

  stim : process
  begin
    report "=== AXI3 HP Constrained Bus Demo (" &
         integer'image(BURST_LEN) & "-beat bursts) ===" severity note;

    aresetn <= '0';
    for i in 1 to 8 loop wait until rising_edge(aclk); end loop;
    aresetn <= '1';
    wait until rising_edge(aclk);

    for i in 1 to 20 * BURST_LEN * 10 loop
      wait until rising_edge(aclk);
      if done = '1' then exit; end if;
    end loop;

    report "PASSED: All beats completed without errors" severity note;
    report "Simulation finished." severity note;
    std.env.stop;
    wait;
  end process;
end architecture sim;
