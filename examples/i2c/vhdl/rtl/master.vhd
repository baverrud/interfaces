-- =====================================================================
-- i2c_master.vhd - I2C master test (VHDL-2019)
-- =====================================================================
-- Bit-banged I2C master: write 0xA5 to slave, read it back.
-- SCL/SDA drive '0' for low, 'Z' for release; external 'H' pull-up.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.i2c_pkg.all;

entity i2c_master is
  generic (
    DEV_ADDR : std_logic_vector(6 downto 0) := "1010000"
  );
  port (
    clk, rstn : in  std_logic;
    m         : view master of i2c_t;
    done      : out std_logic
  );
end entity;

architecture rtl of i2c_master is

  type state_t is (
    IDLE, START, SEND_BIT, SEND_HIGH, SEND_LOW,
    GET_ACK_HIGH, GET_ACK_LOW,
    READ_HIGH, READ_LOW,
    NACK_HIGH, NACK_LOW,
    STOP1, DONE_S
  );
  signal state   : state_t := IDLE;

  signal scl_drv : std_logic := '0';
  signal sda_drv : std_logic := '0';
  signal bit_cnt : unsigned(3 downto 0);
  signal tx_byte : std_logic_vector(7 downto 0);
  signal rx_byte : std_logic_vector(7 downto 0);
  signal rw      : std_logic;

begin

  m.scl <= '0' when scl_drv = '1' else 'Z';
  m.sda <= '0' when sda_drv = '1' else 'Z';

  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        state   <= IDLE;
        scl_drv <= '0';
        sda_drv <= '0';
        done    <= '0';
      else
        case state is

          when IDLE =>
            tx_byte <= DEV_ADDR & "0";
            bit_cnt <= (others => '0');
            rw      <= '0';
            state   <= START;

          when START =>
            sda_drv <= '1';
            state   <= SEND_BIT;

          when SEND_BIT =>
            sda_drv <= not tx_byte(7);
            scl_drv <= '0';
            state   <= SEND_HIGH;

          when SEND_HIGH =>
            state <= SEND_LOW;

          when SEND_LOW =>
            scl_drv   <= '1';
            tx_byte   <= tx_byte(6 downto 0) & '0';
            if bit_cnt = 7 then
              bit_cnt <= (others => '0');
              state   <= GET_ACK_HIGH;
            else
              bit_cnt <= bit_cnt + 1;
              state   <= SEND_BIT;
            end if;

          when GET_ACK_HIGH =>
            sda_drv <= '0';
            scl_drv <= '0';
            state   <= GET_ACK_LOW;

          when GET_ACK_LOW =>
            scl_drv <= '1';
            if m.sda = '0' then
              if rw = '0' then
                tx_byte <= x"A5";
                bit_cnt <= (others => '0');
                state   <= SEND_BIT;
              else
                rx_byte <= (others => '0');
                bit_cnt <= (others => '0');
                state   <= READ_HIGH;
              end if;
            else
              state <= STOP1;
            end if;

          when READ_HIGH =>
            scl_drv <= '0';
            rx_byte <= rx_byte(6 downto 0) & m.sda;
            state   <= READ_LOW;

          when READ_LOW =>
            scl_drv <= '1';
            if bit_cnt = 7 then
              state <= NACK_HIGH;
            else
              bit_cnt <= bit_cnt + 1;
              state   <= READ_HIGH;
            end if;

          when NACK_HIGH =>
            sda_drv <= '1';
            scl_drv <= '0';
            state   <= NACK_LOW;

          when NACK_LOW =>
            scl_drv <= '1';
            state   <= STOP1;

          when STOP1 =>
            sda_drv <= '0';
            scl_drv <= '0';
            done    <= '1';
            state   <= DONE_S;

          when DONE_S => null;

        end case;
      end if;
    end if;
  end process;

end architecture;
