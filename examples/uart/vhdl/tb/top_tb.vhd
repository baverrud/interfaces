-- =====================================================================
-- top_tb.vhd - UART testbench (VHDL-2019)
-- =====================================================================
-- Clock generator and reset sequence.  The UART test uses BAUD_DIV=8
-- for fast simulation (each bit period = 8 clock cycles).
-- With 8 data bits + start + stop = 10 bits, a full TX+RX cycle
-- takes roughly 160 clock cycles; timeout set to 500 for safety.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity top_tb is
end entity;

architecture sim of top_tb is

  -- baud divider (must match DUT)
  constant BAUD_DIV : positive := 8;

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
    generic map (
      BAUD_DIV => BAUD_DIV
    )
    port map (
      clk  => clk,
      rstn => rstn,
      done => done
    );

  -- stimulus
  stim : process begin
    rstn <= '0';                        -- assert reset
    wait for 4 * TCLK;                  -- hold for 4 cycles
    rstn <= '1';                        -- release reset

    -- wait up to 500 clock cycles for completion
    for i in 0 to 499 loop
      wait until rising_edge(clk);
      exit when done = '1';
    end loop;

    -- check result
    assert done = '1' report "UART: timeout" severity failure;
    report "=== UART PASSED ===" severity note;
    stop;
    wait;
  end process;

end architecture;    -- of top_tb
