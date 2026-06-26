-- =====================================================================
-- top_tb.vhd - APB testbench
-- =====================================================================
library ieee; use ieee.std_logic_1164.all; use ieee.numeric_std.all; use std.env.all;
entity top_tb is end entity;
architecture sim of top_tb is
  constant TCLK : time := 10 ns;
  signal pclk : std_logic := '0'; signal prstn : std_logic := '0';
  signal rd_data : std_logic_vector(31 downto 0); signal rd_valid, done : std_logic;
begin
  pclk <= not pclk after TCLK / 2;
  dut : entity work.top
    port map (pclk => pclk, prstn => prstn,
              rd_data => rd_data, rd_valid => rd_valid, done => done);
  stim : process begin
    prstn <= '0'; wait for 4 * TCLK; prstn <= '1';
    for i in 0 to 199 loop wait until rising_edge(pclk); exit when done = '1'; end loop;
    assert done = '1' report "APB: timeout" severity failure;
    assert rd_data = x"000000A5" report "APB: mismatch" severity failure;
    report "=== APB PASSED ===" severity note; stop; wait;
  end process;
end architecture;
