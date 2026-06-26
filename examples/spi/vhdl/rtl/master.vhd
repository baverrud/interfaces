-- =====================================================================
-- spi_master.vhd - SPI register write/read test (VHDL-2019)
-- =====================================================================
-- Performs a complete SPI register transaction:
--   1. Assert CS, send 8 SCLK cycles with byte 0xA5 (MSB first)
--   2. De-assert CS
--   3. Re-assert CS, send 8 SCLK cycles, capture MISO on rising edges
--   4. De-assert CS, verify captured byte = 0xA5, assert done
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.spi_pkg.all;

entity spi_master is
  generic (
    WR_DATA : std_logic_vector(7 downto 0) := x"A5"  -- test data
  );
  port (
    clk, rstn : in  std_logic;          -- system clock / active-low reset
    m         : view master of spi_t;   -- SPI master mode view
    done      : out std_logic           -- high when test passes
  );
end entity;

architecture rtl of spi_master is

  -- FSM states
  type state_t is (
    IDLE,                              -- prepare write data
    WR_ASSERT,                         -- assert CS, drive MSB
    WR_HI,                             -- SCLK rising edge
    WR_LO,                             -- SCLK falling edge, next bit
    WR_DEASSERT,                       -- de-assert CS
    RD_ASSERT,                         -- re-assert CS for read
    RD_HI,                             -- SCLK rising edge (slave drives)
    RD_CAP,                            -- capture MISO while SCLK high
    RD_LO,                             -- SCLK falling edge, advance
    RD_DEASSERT,                       -- de-assert CS, verify
    DONE_S                             -- test complete
  );
  signal state     : state_t := IDLE;

  signal bit_idx   : unsigned(3 downto 0);   -- 0..7
  signal tx_shift  : std_logic_vector(7 downto 0);  -- transmit shift reg
  signal rx_shift  : std_logic_vector(7 downto 0);  -- receive shift reg

begin

  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        state    <= IDLE;
        m.cs     <= (m.cs'range => '1');  -- CS inactive (high)
        m.sclk   <= '0';
        m.mosi   <= '0';
        done     <= '0';
        bit_idx  <= (others => '0');
      else
        case state is

          -- IDLE: load write data
          when IDLE =>
            tx_shift <= WR_DATA;
            bit_idx  <= (others => '0');
            state    <= WR_ASSERT;

          -- WR_ASSERT: assert CS, drive MSB first
          when WR_ASSERT =>
            m.cs     <= (m.cs'range => '0');
            m.mosi   <= tx_shift(7);
            state    <= WR_HI;

          -- WR_HI: raise SCLK (slave captures MOSI)
          when WR_HI =>
            m.sclk <= '1';
            state  <= WR_LO;

          -- WR_LO: lower SCLK, shift, check if byte complete
          when WR_LO =>
            m.sclk <= '0';
            tx_shift <= tx_shift(6 downto 0) & '0';
            if bit_idx = 7 then
              state <= WR_DEASSERT;
            else
              m.mosi  <= tx_shift(6);
              bit_idx <= bit_idx + 1;
              state   <= WR_HI;
            end if;

          -- WR_DEASSERT: end write transaction
          when WR_DEASSERT =>
            m.cs     <= (m.cs'range => '1');
            m.sclk   <= '0';
            m.mosi   <= '0';
            bit_idx  <= (others => '0');
            state    <= RD_ASSERT;

          -- RD_ASSERT: re-assert CS for read
          when RD_ASSERT =>
            m.cs     <= (m.cs'range => '0');
            bit_idx  <= (others => '0');
            rx_shift <= (others => '0');
            state    <= RD_HI;

          -- RD_HI: raise SCLK (slave drives MISO)
          when RD_HI =>
            m.sclk <= '1';
            state  <= RD_CAP;

          -- RD_CAP: capture MISO while SCLK is high
          when RD_CAP =>
            rx_shift <= rx_shift(6 downto 0) & m.miso;
            state <= RD_LO;

          -- RD_LO: lower SCLK, advance
          when RD_LO =>
            m.sclk <= '0';
            if bit_idx = 7 then
              state <= RD_DEASSERT;
            else
              bit_idx <= bit_idx + 1;
              state   <= RD_HI;
            end if;

          -- RD_DEASSERT: end read, verify data
          when RD_DEASSERT =>
            m.cs   <= (m.cs'range => '1');
            done   <= '1' when rx_shift = WR_DATA else '0';
            state  <= DONE_S;

          -- DONE_S: hold
          when DONE_S =>
            null;

        end case;
      end if;
    end if;
  end process;

end architecture;    -- of spi_master
