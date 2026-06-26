-- =====================================================================
-- top.vhd - MDIO demo: manager writes, PHY reads back (VHDL-2019)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.mdio_pkg.all;

entity top is
  generic (
    PHY_ADDR : std_logic_vector(4 downto 0) := "00001";
    REG_ADDR : std_logic_vector(4 downto 0) := "00001";
    WR_DATA  : std_logic_vector(15 downto 0) := x"A5A5"
  );
  port (
    clk, rstn : in  std_logic;
    done      : out std_logic
  );
end entity;

architecture rtl of top is
  signal b : mdio_t;
begin

  -- MDIO bus pull-up (weak high)
  b.mdio <= 'H';

  u_mast : entity work.mdio_manager
    generic map (
      PHY_ADDR => PHY_ADDR,
      REG_ADDR => REG_ADDR,
      WR_DATA  => WR_DATA
    )
    port map (clk => clk, rstn => rstn, m => b, done => done);

  u_phy : entity work.mdio_phy
    port map (clk => clk, rstn => rstn, s => b);

end architecture;
