-- =====================================================================
-- top_constrained_tb.vhd - testbench for the constrained record demo
-- =====================================================================
-- Sends 16 beats through the constrained bus, then checks done asserts.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity top_constrained_tb is
end entity;

architecture sim of top_constrained_tb is
  constant TCLK     : time := 10 ns;
  constant N_BEATS  : natural := 16;
  signal clk  : std_logic := '0';
  signal rst  : std_logic := '1';
  signal done : std_logic;
begin

  clk <= not clk after TCLK / 2;

  dut : entity work.top_constrained
    generic map (N_BEATS => N_BEATS)
    port map (clk => clk, rst => rst, done => done);

  stim : process
  begin
    rst <= '1';
    wait for 4 * TCLK;
    wait until rising_edge(clk);
    rst <= '0';

    -- Wait for done with timeout
    wait until rising_edge(clk);
    for i in 0 to N_BEATS * 10 loop
      exit when done = '1';
      wait until rising_edge(clk);
    end loop;

    assert done = '1'
      report "CONSTRAINED: done never asserted" severity failure;
    report "=== CONSTRAINED RECORD (axis_32b_t) PASSED ===" severity note;

    stop;
    wait;
  end process;

end architecture;
