-- =====================================================================
-- i2s_controller.vhd - I2S controller (CPU/DSP side) (VHDL-2019)
-- =====================================================================
-- Drives tx_data/tx_valid (CPU sends audio sample to codec), then
-- asserts done.  The controller receives BCLK/LRCLK from the
-- peripheral (codec).
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.i2s_pkg.all;

entity i2s_controller is
  port (
    clk, rstn : in  std_logic;
    m         : view master of i2s_t;
    done      : out std_logic
  );
end entity;

architecture rtl of i2s_controller is
  signal cnt : unsigned(3 downto 0);
begin

  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        cnt        <= (others => '0');
        m.tx_valid <= '0';
        m.tx_data  <= (m.tx_data'range => '0');
        done       <= '0';
      elsif cnt < 4 then
        m.tx_data  <= x"A5A5A5";
        m.tx_valid <= '1';
        cnt        <= cnt + 1;
      else
        m.tx_valid <= '0';
        done       <= '1';
      end if;
    end if;
  end process;

end architecture;
