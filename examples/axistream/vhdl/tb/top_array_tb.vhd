-- =====================================================================
-- top_array_tb.vhd - testbench for the array-of-streams demo
-- =====================================================================
-- Checks that both pixel lanes produce data and done asserts.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity top_array_tb is
end entity;

architecture sim of top_array_tb is
  constant TCLK : time := 10 ns;
  constant N_LANES : natural := 2;
  constant LINE    : natural := 8;
  signal clk  : std_logic := '0';
  signal rst  : std_logic := '1';
  signal beats : std_logic_vector(15 downto 0);
  signal done  : std_logic;
begin

  clk <= not clk after TCLK / 2;

  dut : entity work.top_array
    generic map (N_LANES => N_LANES, FIFO_DEPTH => 16, LINE => LINE)
    port map (clk => clk, rst => rst, beats => beats, done => done);

  stim : process
  begin
    rst <= '1';
    wait for 4 * TCLK;
    wait until rising_edge(clk);
    rst <= '0';

    -- Wait for done with generous timeout
    wait until rising_edge(clk);
    for i in 0 to 500 loop
      exit when done = '1';
      wait until rising_edge(clk);
    end loop;

    assert done = '1'
      report "ARRAY: done never asserted" severity failure;
    assert unsigned(beats) >= N_LANES * LINE
      report "ARRAY: too few beats (" & integer'image(to_integer(unsigned(beats)))
         & " < " & integer'image(N_LANES * LINE) & ")"
      severity failure;

    report "INFO: total beats = " & integer'image(to_integer(unsigned(beats)));
    report "=== ARRAY OF STREAMS (axis_array_t) PASSED ===" severity note;

    stop;
    wait;
  end process;

end architecture;
