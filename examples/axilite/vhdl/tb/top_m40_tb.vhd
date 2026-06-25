-- =====================================================================
-- top_m40_tb.vhd - AXI4-Lite M40 constrained bus testbench
-- =====================================================================
-- Generates clock + reset for the M40 (axilite_m40_t) design, waits
-- for the write-read sequence to complete, and verifies the read-back
-- matches 0xA5A5A5A5.  Since the M40 variant has observability ports,
-- data correctness is fully checked.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity top_m40_tb is
end entity top_m40_tb;

architecture sim of top_m40_tb is
  constant DEPTH : positive := 256;
  constant TCLK  : time := 10 ns;

  signal aclk    : std_logic := '0';
  signal aresetn : std_logic := '0';
  signal rd_data  : std_logic_vector(31 downto 0);
  signal rd_valid : std_logic;
  signal done     : std_logic;
begin
  -- Clock generator: 100 MHz
  aclk <= not aclk after TCLK/2;

  -- Device under test: M40 constrained bus top level
  dut : entity work.top_m40
    generic map (DEPTH => DEPTH)
    port map (aclk => aclk, aresetn => aresetn,
         rd_data => rd_data, rd_valid => rd_valid, done => done);

  -- Test sequence: apply reset, wait for done, check read-back
  stim : process
  begin
    report "=== AXI4-Lite M40 Constrained Bus Demo ===" severity note;
    aresetn <= '0';
    for i in 1 to 8 loop wait until rising_edge(aclk); end loop;
    aresetn <= '1';
    wait until rising_edge(aclk);

    for i in 1 to 100 loop
      wait until rising_edge(aclk);
      exit when done = '1';
    end loop;

    if rd_data = x"A5A5A5A5" then
      report "PASSED: readback = " & to_hstring(rd_data) severity note;
    else
      report "FAILED: readback = " & to_hstring(rd_data) & " (expected A5A5A5A5)" severity error;
    end if;

    report "Simulation finished." severity note;
    stop;
    wait;
  end process;
end architecture sim;
