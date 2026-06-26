-- =====================================================================
-- uart_rx.vhd - UART receiver (VHDL-2019)
-- =====================================================================
-- Waits for a start bit on s.tx (the transmitter's TX line), samples
-- 8 data bits at the baud rate, then re-transmits the received byte
-- back on s.rx.  Implements a full UART frame echo.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.uart_pkg.all;

entity uart_rx is
  generic (
    BAUD_DIV : positive := 8           -- system clocks per bit period
  );
  port (
    clk, rstn : in  std_logic;         -- system clock / active-low reset
    s         : view slave of uart_t;  -- UART slave view (tx=input,rx=output)
    done      : out std_logic          -- unused (continuously active)
  );
end entity;

architecture rtl of uart_rx is

  -- FSM states
  type state_t is (
    IDLE,                              -- wait for start bit on s.tx
    RX_START,                          -- wait for start bit to complete
    RX_DATA,                           -- sample 8 data bits at midpoint
    RX_STOP,                           -- wait for stop bit
    TX_START,                          -- drive start bit on s.rx
    TX_DATA,                           -- shift out received byte
    TX_STOP                            -- drive stop bit, return to IDLE
  );
  signal state     : state_t := IDLE;

  signal bit_idx   : unsigned(3 downto 0);   -- bit index (0..7)
  signal rx_byte   : std_logic_vector(7 downto 0);  -- received byte
  signal tx_shift  : std_logic_vector(7 downto 0);  -- transmit shift reg
  signal baud_cnt  : integer range 0 to BAUD_DIV - 1;  -- baud counter
  signal rx_prev   : std_logic;               -- previous s.tx for edge detect

begin

  done <= '0';

  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        state    <= IDLE;
        s.rx     <= '1';
        baud_cnt <= 0;
        bit_idx  <= (others => '0');
        rx_prev  <= '1';
      else
        case state is

          when IDLE =>
            rx_prev <= s.tx;
            if rx_prev = '1' and s.tx = '0' then
              baud_cnt <= 0;
              bit_idx  <= (others => '0');
              rx_byte  <= (others => '0');
              state    <= RX_START;
            end if;

          when RX_START =>
            if baud_cnt = BAUD_DIV - 1 then
              baud_cnt <= 0;
              state    <= RX_DATA;
            else
              baud_cnt <= baud_cnt + 1;
            end if;

          when RX_DATA =>
            if baud_cnt = BAUD_DIV / 2 then
              rx_byte <= s.tx & rx_byte(7 downto 1);
            end if;
            if baud_cnt = BAUD_DIV - 1 then
              baud_cnt <= 0;
              if bit_idx = 7 then
                bit_idx <= (others => '0');
                state   <= RX_STOP;
              else
                bit_idx <= bit_idx + 1;
              end if;
            else
              baud_cnt <= baud_cnt + 1;
            end if;

          when RX_STOP =>
            if baud_cnt = BAUD_DIV - 1 then
              tx_shift <= rx_byte;
              bit_idx  <= (others => '0');
              baud_cnt <= 0;
              state    <= TX_START;
            else
              baud_cnt <= baud_cnt + 1;
            end if;

          when TX_START =>
            s.rx <= '0';
            if baud_cnt = BAUD_DIV - 1 then
              baud_cnt <= 0;
              state    <= TX_DATA;
            else
              baud_cnt <= baud_cnt + 1;
            end if;

          when TX_DATA =>
            s.rx <= tx_shift(0);
            if baud_cnt = BAUD_DIV - 1 then
              baud_cnt <= 0;
              tx_shift <= '0' & tx_shift(7 downto 1);
              if bit_idx = 7 then
                state <= TX_STOP;
              else
                bit_idx <= bit_idx + 1;
              end if;
            else
              baud_cnt <= baud_cnt + 1;
            end if;

          when TX_STOP =>
            s.rx <= '1';
            if baud_cnt = BAUD_DIV - 1 then
              state <= IDLE;
            else
              baud_cnt <= baud_cnt + 1;
            end if;

        end case;
      end if;
    end if;
  end process;

end architecture;    -- of uart_rx
