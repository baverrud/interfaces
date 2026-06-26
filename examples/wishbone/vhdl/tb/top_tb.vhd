-- =====================================================================
-- top_tb.vhd - Wishbone testbench
-- =====================================================================
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all; use std.env.all;
entity top_tb is end entity;
architecture sim of top_tb is
  constant TCLK : time := 10 ns;
  signal clk : std_logic := '0'; signal rstn : std_logic := '0';
  signal rd_data : std_logic_vector(31 downto 0); signal rd_valid, done : std_logic;
begin
  clk <= not clk after TCLK / 2;
  dut : entity work.top
    port map (clk => clk, rstn => rstn, rd_data => rd_data, rd_valid => rd_valid, done => done);
  stim : process begin
    rstn <= '0'; wait for 4 * TCLK; rstn <= '1';
    for i in 0 to 199 loop wait until rising_edge(clk); exit when done = '1'; end loop;
    assert done = '1' report "WISHBONE: timeout" severity failure;
    assert rd_data = x"000000A5" report "WISHBONE: mismatch" severity failure;
    report "=== WISHBONE PASSED ===" severity note; stop; wait;
  end process;
end architecture;
