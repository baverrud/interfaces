-- =====================================================================
-- top_unified_tb.vhd - AXI3 unified bus testbench (intentionally broken)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_unified_tb is
end entity top_unified_tb;

architecture sim of top_unified_tb is
  constant DATA_W    : positive := 32;
  constant ADDR_W    : positive := 32;
  constant ID_W      : positive := 4;
  constant BURST_LEN : positive := 4;
  constant DEPTH     : positive := 256;
  constant TCLK      : time := 10 ns;

  signal aclk    : std_logic := '0';
  signal aresetn : std_logic := '0';
  signal rd_data  : std_logic_vector(DATA_W-1 downto 0);
  signal rd_valid : std_logic;
  signal done     : std_logic;
begin
  aclk <= not aclk after TCLK/2;

  dut : entity work.top_unified
    generic map (DATA_W=>DATA_W, ADDR_W=>ADDR_W, ID_W=>ID_W,
          BURST_LEN=>BURST_LEN, DEPTH=>DEPTH)
    port map (aclk=>aclk, aresetn=>aresetn, rd_data=>rd_data,
         rd_valid=>rd_valid, done=>done);

  stim : process
    variable beat_count : integer := 0;
    variable errors     : integer := 0;
    variable expected   : std_logic_vector(DATA_W-1 downto 0);
  begin
    errors := 0; beat_count := 0;
    report "=== AXI3 Unified Bus Demo ===" severity note;
    aresetn <= '0';
    for i in 1 to 8 loop wait until rising_edge(aclk); end loop;
    aresetn <= '1';
    wait until rising_edge(aclk);
    for i in 1 to 20 * BURST_LEN * 10 loop
      wait until rising_edge(aclk);
      if rd_valid = '1' then
        expected := std_logic_vector(to_unsigned(16#A0# + beat_count, 8)) &
              std_logic_vector(to_unsigned(beat_count + 1, 24));
        beat_count := beat_count + 1;
      end if;
      if done = '1' then exit; end if;
    end loop;
    report "Simulation finished." severity note;
    wait;
  end process;
end architecture sim;
