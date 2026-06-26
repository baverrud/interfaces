-- =====================================================================
-- top_tb.vhd - SPI testbench (VHDL-2019)
-- =====================================================================
-- Clock generator and reset sequence.  Asserts done at end of test.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity top_tb is
end entity;

architecture sim of top_tb is

  -- clock period
  constant TCLK : time := 10 ns;

  -- testbench signals
  signal clk  : std_logic := '0';       -- 100 MHz clock
  signal rstn : std_logic := '1';       -- active-low reset
  signal done : std_logic;              -- test-complete flag

begin

  -- clock: 50% duty cycle
  clk <= not clk after TCLK / 2;

  -- instantiate design under test
  dut : entity work.top
    port map (
      clk  => clk,
      rstn => rstn,
      done => done
    );

  -- stimulus: assert reset, release, wait for done or timeout
  stim : process begin
    rstn <= '0';                        -- assert reset
    wait for 4 * TCLK;                  -- hold for 4 cycles
    rstn <= '1';                        -- release reset

    -- wait up to 200 clock cycles for completion
    for i in 0 to 199 loop
      wait until rising_edge(clk);
      exit when done = '1';
    end loop;

    -- check result
    assert done = '1' report "SPI: timeout" severity failure;
    report "=== SPI PASSED ===" severity note;
    stop;
    wait;
  end process;

end architecture;    -- of top_tb
