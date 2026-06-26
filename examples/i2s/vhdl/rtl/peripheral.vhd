-- =====================================================================
-- i2s_peripheral.vhd - I2S peripheral (CODEC) (VHDL-2019)
-- =====================================================================
-- Generates BCLK (clk/2) and LRCLK (BCLK/64); echoes received
-- tx_data/tx_valid back as rx_data/rx_valid.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.i2s_pkg.all;

entity i2s_peripheral is
  port (
    clk, rstn : in  std_logic;
    s         : view slave of i2s_t;
    done      : out std_logic
  );
end entity;

architecture rtl of i2s_peripheral is
  signal buf : std_logic_vector(23 downto 0);
  signal div : unsigned(5 downto 0);
begin

  done <= '0';

  -- Generate BCLK (clk/2) and LRCLK (BCLK/64)
  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        div     <= (others => '0');
        s.bclk  <= '0';
        s.lrclk <= '0';
      else
        s.bclk  <= div(0);
        s.lrclk <= div(5);
        div     <= div + 1;
      end if;
    end if;
  end process;

  -- Loopback: echo tx_data/tx_valid as rx_data/rx_valid
  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        buf        <= (others => '0');
        s.rx_valid <= '0';
      else
        s.rx_data  <= s.tx_data;
        s.rx_valid <= s.tx_valid;
      end if;
    end if;
  end process;

end architecture;
