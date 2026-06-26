-- =====================================================================
-- qspi_master.vhd - QSPI register write/read test (VHDL-2019)
-- =====================================================================
-- Writes byte 0xA5 as two 4-bit nibbles (MSB first), then reads
-- them back via io_i. Uses dedicated RD_CAP state for safe capture.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qspi_pkg.all;

entity qspi_master is
  generic (
    WR_DATA : std_logic_vector(7 downto 0) := x"A5"
  );
  port (
    clk, rstn : in  std_logic;
    m         : view master of qspi_t;
    done      : out std_logic
  );
end entity;

architecture rtl of qspi_master is

  type state_t is (
    IDLE, WR_ASSERT, WR_HI, WR_LO, WR_DEASSERT,
    RD_ASSERT, RD_HI, RD_CAP, RD_LO, RD_DEASSERT, DONE_S
  );
  signal state      : state_t := IDLE;
  signal nibble_cnt : unsigned(3 downto 0);
  signal rx_data    : std_logic_vector(7 downto 0);

begin

  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        state      <= IDLE;
        m.cs       <= (m.cs'range => '1');
        m.sclk     <= '0';
        m.io_o     <= (m.io_o'range => '0');
        m.io_oe    <= (m.io_oe'range => '0');
        done       <= '0';
        nibble_cnt <= (others => '0');
      else
        case state is

          when IDLE =>
            nibble_cnt <= (others => '0');
            state <= WR_ASSERT;

          when WR_ASSERT =>
            m.cs    <= (m.cs'range => '0');
            m.io_o  <= WR_DATA(7 downto 4);
            m.io_oe <= (m.io_oe'range => '1');
            state   <= WR_HI;

          when WR_HI =>
            m.sclk <= '1';
            state  <= WR_LO;

          when WR_LO =>
            m.sclk <= '0';
            if nibble_cnt = 0 then
              m.io_o <= WR_DATA(3 downto 0);
              nibble_cnt <= nibble_cnt + 1;
              state <= WR_HI;
            else
              state <= WR_DEASSERT;
            end if;

          when WR_DEASSERT =>
            m.cs    <= (m.cs'range => '1');
            m.sclk  <= '0';
            m.io_o  <= (m.io_o'range => '0');
            m.io_oe <= (m.io_oe'range => '0');
            state   <= RD_ASSERT;

          when RD_ASSERT =>
            m.cs     <= (m.cs'range => '0');
            m.io_oe  <= (m.io_oe'range => '0');
            nibble_cnt <= (others => '0');
            rx_data    <= (others => '0');
            state      <= RD_HI;

          when RD_HI =>
            m.sclk <= '1';
            state  <= RD_CAP;

          when RD_CAP =>
            if nibble_cnt = 0 then
              rx_data(7 downto 4) <= m.io_i;
            else
              rx_data(3 downto 0) <= m.io_i;
            end if;
            state <= RD_LO;

          when RD_LO =>
            m.sclk <= '0';
            if nibble_cnt = 0 then
              nibble_cnt <= nibble_cnt + 1;
              state <= RD_HI;
            else
              state <= RD_DEASSERT;
            end if;

          when RD_DEASSERT =>
            m.cs   <= (m.cs'range => '1');
            done   <= '1' when rx_data = WR_DATA else '0';
            state  <= DONE_S;

          when DONE_S => null;

        end case;
      end if;
    end if;
  end process;

end architecture;
