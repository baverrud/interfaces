-- =====================================================================
-- top_tb.vhd - AXI4-Lite self-checking testbench (full master+slave)
-- =====================================================================
-- Generates clock + reset for the top (axilite_master + axilite_slave)
-- design, waits for the write-read sequence to complete, and verifies
-- that the read-back data matches the expected 0xA5A5A5A5 pattern.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity top_tb is
end entity;

architecture sim of top_tb is
  constant DATA_W : positive := 32;
  constant ADDR_W : positive := 32;
  constant USER_W : positive := 1;
  constant DEPTH  : positive := 256;
  constant TCLK   : time := 10 ns;

  signal aclk    : std_logic := '0';
  signal aresetn : std_logic := '0';
  signal rd_data  : std_logic_vector(DATA_W-1 downto 0);
  signal rd_valid : std_logic;
  signal done     : std_logic;
begin
  aclk <= not aclk after TCLK/2;

  dut : entity work.top
    generic map (DATA_W=>DATA_W, ADDR_W=>ADDR_W, USER_W=>USER_W, DEPTH=>DEPTH)
    port map (aclk=>aclk, aresetn=>aresetn, rd_data=>rd_data, rd_valid=>rd_valid, done=>done);

  stim : process
    variable errors : integer := 0;
  begin
    errors := 0;
    report "=== AXI4-Lite Write/Read Demo ===" severity note;
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
      errors := errors + 1;
    end if;

    if errors = 0 then
      report "PASSED" severity note;
    else
      report "FAILED with errors" severity error;
    end if;
    stop;
    wait;
  end process;
end architecture;
