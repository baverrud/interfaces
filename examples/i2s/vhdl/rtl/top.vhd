-- =====================================================================
-- top.vhd - I2S demo: controller -> peripheral (VHDL-2019)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.i2s_pkg.all;

entity top is
  port (
    clk, rstn : in  std_logic;
    done      : out std_logic
  );
end entity;

architecture rtl of top is
  signal b : i2s_t(tx_data(23 downto 0), rx_data(23 downto 0));
begin

  u_ctrl : entity work.i2s_controller
    port map (clk => clk, rstn => rstn, m => b, done => done);

  u_per : entity work.i2s_peripheral
    port map (clk => clk, rstn => rstn, s => b);

end architecture;
