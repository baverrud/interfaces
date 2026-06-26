-- =====================================================================
-- top.vhd - I2C demo: master writes 0xA5, reads it back (VHDL-2019)
-- =====================================================================
-- Adds weak pull-up resistors ('H') to the I2C bus.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.i2c_pkg.all;

entity top is
  generic (
    DEV_ADDR : std_logic_vector(6 downto 0) := "1010000"
  );
  port (
    clk, rstn : in  std_logic;
    done      : out std_logic
  );
end entity;

architecture rtl of top is
  signal b : i2c_t;
begin

  -- I2C bus pull-up resistors (weak high)
  b.scl <= 'H';
  b.sda <= 'H';

  u_mast : entity work.i2c_master
    generic map (DEV_ADDR => DEV_ADDR)
    port map (clk => clk, rstn => rstn, m => b, done => done);

  u_slav : entity work.i2c_slave
    port map (clk => clk, rstn => rstn, s => b);

end architecture;
