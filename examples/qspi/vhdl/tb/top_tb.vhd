-- =====================================================================
-- top_tb.vhd - QSPI testbench (VHDL-2019)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity top_tb is end entity;

architecture sim of top_tb is
  constant TCLK : time := 10 ns;
  signal clk  : std_logic := '0';
  signal rstn : std_logic := '1';
  signal done : std_logic;
begin

  clk <= not clk after TCLK / 2;

  dut : entity work.top
    generic map (WR_DATA => x"A5")
    port map (clk => clk, rstn => rstn, done => done);

  stim : process begin
    rstn <= '0';
    wait for 4 * TCLK;
    rstn <= '1';
    for i in 0 to 499 loop
      wait until rising_edge(clk);
      exit when done = '1';
    end loop;
    assert done = '1' report "QSPI: timeout" severity failure;
    report "=== QSPI PASSED ===" severity note;
    stop;
    wait;
  end process;

end architecture;
