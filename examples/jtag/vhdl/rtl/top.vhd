-- =====================================================================
-- top.vhd - JTAG demo: controller sequences TAP (VHDL-2019)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.jtag_pkg.all;

entity top is
  port (
    clk, rstn : in  std_logic;
    done      : out std_logic
  );
end entity;

architecture rtl of top is
  signal b : jtag_t;
begin

  u_ctrl : entity work.jtag_controller
    port map (clk => clk, rstn => rstn, m => b, done => done);

  u_tap : entity work.jtag_tap
    port map (clk => clk, rstn => rstn, s => b);

end architecture;
