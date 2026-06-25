-- =====================================================================
-- top_split_tb.vhd - AXI4-Lite split master/slave testbench
-- =====================================================================
-- Tests top_split with both SPLIT_SLAVE=false and SPLIT_SLAVE=true.
-- Change the constant to test the other mode.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;

entity top_split_tb is
end entity;

architecture sim of top_split_tb is
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

  -- Toggle this constant to test split-slave mode
  dut : entity work.top_split
    generic map (DATA_W=>DATA_W, ADDR_W=>ADDR_W, USER_W=>USER_W,
          DEPTH=>DEPTH, SPLIT_SLAVE=>false)
    port map (aclk=>aclk, aresetn=>aresetn, rd_data=>rd_data, rd_valid=>rd_valid, done=>done);

  stim : process
    variable expected : std_logic_vector(DATA_W-1 downto 0);
  begin
    report "=== AXI4-Lite Split Demo (SPLIT_SLAVE=false) ===" severity note;
    expected := x"B0B0B0B0";
    aresetn <= '0';
    for i in 1 to 8 loop wait until rising_edge(aclk); end loop;
    aresetn <= '1';
    wait until rising_edge(aclk);

    for i in 1 to 100 loop
      wait until rising_edge(aclk);
      exit when done = '1';
    end loop;

    if rd_data = expected then
      report "PASSED: readback = " & to_hstring(rd_data) severity note;
    else
      report "FAILED: readback = " & to_hstring(rd_data) & " (expected " &
           to_hstring(expected) & ")" severity error;
    end if;
    stop;
    wait;
  end process;
end architecture;
