-- =====================================================================
-- uart_tx.vhd - UART transmitter (VHDL-2019)
-- =====================================================================
-- Transmits byte 0xA5 via UART (start bit + 8 LSB-first data bits +
-- stop bit), then switches to RX mode to capture the receiver's echo.
-- Asserts done after receiving a full echo frame.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.uart_pkg.all;

entity uart_tx is
  generic (
    BAUD_DIV : positive := 8           -- system clocks per bit period
  );
  port (
    clk, rstn : in  std_logic;         -- system clock / active-low reset
    m         : view master of uart_t; -- UART master view (tx=out,rx=in)
    done      : out std_logic          -- high when TX+RX cycle completes
  );
end entity;

architecture rtl of uart_tx is

  -- FSM states
  type state_t is (
    IDLE,                              -- load test byte
    TX_START,                          -- drive start bit (TX = 0)
    TX_DATA,                           -- shift out 8 data bits, LSB first
    TX_STOP,                           -- drive stop bit (TX = 1)
    RX_WAIT,                           -- wait for receiver's start bit on RX
    RX_DATA,                           -- sample 8 data bits from RX
    RX_STOP,                           -- wait for stop bit on RX
    DONE_S                             -- transaction complete
  );
  signal state     : state_t := IDLE;

  signal bit_idx   : unsigned(3 downto 0);   -- bit index (0..7)
  signal tx_byte   : std_logic_vector(7 downto 0);  -- byte to transmit
  signal rx_shift  : std_logic_vector(7 downto 0);  -- receive shift reg
  signal baud_cnt  : integer range 0 to BAUD_DIV - 1;  -- baud counter
  signal rx_prev   : std_logic;               -- previous RX for edge detect

begin

  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        state    <= IDLE;
        m.tx     <= '1';
        done     <= '0';
        baud_cnt <= 0;
        bit_idx  <= (others => '0');
        rx_prev  <= '1';
      else
        case state is

          when IDLE =>
            tx_byte  <= x"A5";
            bit_idx  <= (others => '0');
            baud_cnt <= 0;
            state    <= TX_START;

          when TX_START =>
            m.tx <= '0';
            if baud_cnt = BAUD_DIV - 1 then
              baud_cnt <= 0;
              bit_idx  <= (others => '0');
              state    <= TX_DATA;
            else
              baud_cnt <= baud_cnt + 1;
            end if;

          when TX_DATA =>
            m.tx <= tx_byte(0);
            if baud_cnt = BAUD_DIV - 1 then
              baud_cnt <= 0;
              tx_byte  <= '0' & tx_byte(7 downto 1);
              if bit_idx = 7 then
                state <= TX_STOP;
              else
                bit_idx <= bit_idx + 1;
              end if;
            else
              baud_cnt <= baud_cnt + 1;
            end if;

          when TX_STOP =>
            m.tx <= '1';
            if baud_cnt = BAUD_DIV - 1 then
              baud_cnt <= 0;
              bit_idx  <= (others => '0');
              rx_shift <= (others => '0');
              state    <= RX_WAIT;
            else
              baud_cnt <= baud_cnt + 1;
            end if;

          when RX_WAIT =>
            rx_prev <= m.rx;
            if rx_prev = '1' and m.rx = '0' then
              baud_cnt <= 0;
              bit_idx  <= (others => '0');
              state    <= RX_DATA;
            end if;

          when RX_DATA =>
            if baud_cnt = BAUD_DIV / 2 then
              rx_shift <= m.rx & rx_shift(7 downto 1);
            end if;
            if baud_cnt = BAUD_DIV - 1 then
              baud_cnt <= 0;
              if bit_idx = 7 then
                state <= RX_STOP;
              else
                bit_idx <= bit_idx + 1;
              end if;
            else
              baud_cnt <= baud_cnt + 1;
            end if;

          when RX_STOP =>
            if baud_cnt = BAUD_DIV - 1 then
              state <= DONE_S;
            else
              baud_cnt <= baud_cnt + 1;
            end if;

          when DONE_S =>
            done <= '1';

        end case;
      end if;
    end if;
  end process;

end architecture;    -- of uart_tx
