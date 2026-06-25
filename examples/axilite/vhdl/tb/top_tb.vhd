-- =====================================================================
-- top_tb.vhd - AXI4-Lite self-checking testbench
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use std.env.all;

entity top_tb is
end entity;

architecture sim of top_tb is
  constant TCLK : time := 10 ns;
  signal aclk    : std_logic := '0';
  signal aresetn : std_logic := '0';
  signal done    : boolean   := false;
  signal reg_readout : std_logic_vector(31 downto 0);
begin
  aclk <= not aclk after TCLK/2 when not done else '0';

  dut : entity work.top
    port map (aclk => aclk, aresetn => aresetn, reg_readout => reg_readout);

  process
  begin
    aresetn <= '0';
    wait for 4 * TCLK;
    wait until rising_edge(aclk);
    aresetn <= '1';

    wait for 40 * TCLK;
    assert reg_readout = x"DEADBEEF"
      report "FAILED: register readback mismatch" severity failure;
    report "PASSED: register readback = " & to_hstring(reg_readout) severity note;

    done <= true;
    stop;
    wait;
  end process;
end architecture;
