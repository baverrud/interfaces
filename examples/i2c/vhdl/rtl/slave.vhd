-- =====================================================================
-- i2c_slave.vhd - I2C slave at address 0x50 (VHDL-2019)
-- =====================================================================
-- Write: captures data byte into shadow register.
-- Read:  sends shadow register value back.
-- Uses SCL rising-edge detection for state transitions.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.i2c_pkg.all;

entity i2c_slave is
  port (
    clk, rstn : in  std_logic;
    s         : view slave of i2c_t;
    done      : out std_logic
  );
end entity;

architecture rtl of i2c_slave is

  signal sda_drv : std_logic := '0';
  signal scl_prev, sda_prev : std_logic;
  signal start, stop : std_logic;

  type state_t is (IDLE, GET_BYTE, DO_ACK, SEND_BYTE);
  signal state : state_t := IDLE;

  signal bit_cnt  : unsigned(3 downto 0);
  signal shift    : std_logic_vector(7 downto 0);
  signal shadow   : std_logic_vector(7 downto 0) := x"A5";
  signal addr_ok  : std_logic;
  signal rw       : std_logic;

begin

  done <= '0';

  s.sda <= '0' when sda_drv = '1' else 'Z';

  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        scl_prev <= '1';
        sda_prev <= '1';
        start    <= '0';
        stop     <= '0';
        state    <= IDLE;
        sda_drv  <= '0';
      else
        scl_prev <= s.scl;
        sda_prev <= s.sda;
start <= '1' when (s.scl = '1') and (sda_prev = '1') and (s.sda = '0') else '0';
    stop  <= '1' when (s.scl = '1') and (sda_prev = '0') and (s.sda = '1') else '0';

        case state is

          when IDLE =>
            sda_drv <= '0';
            if start = '1' then
              bit_cnt <= (others => '0');
              addr_ok <= '0';
              state   <= GET_BYTE;
            end if;

          when GET_BYTE =>
            if s.scl = '1' and scl_prev = '0' then
              if bit_cnt < 8 then
                shift   <= shift(6 downto 0) & s.sda;
                bit_cnt <= bit_cnt + 1;
              else
                if addr_ok = '0' then
                  addr_ok <= '1' when shift(7 downto 1) = "1010000" else '0';
                  rw      <= shift(0);
                elsif rw = '0' then
                  shadow <= shift;
                end if;
                if addr_ok = '1' or shift(7 downto 1) = "1010000" then
                  state <= DO_ACK;
                else
                  state <= IDLE;
                end if;
                bit_cnt <= (others => '0');
              end if;
            end if;
            if stop = '1' then
              state <= IDLE;
            end if;

          when DO_ACK =>
            if s.scl = '1' and scl_prev = '0' then
              sda_drv <= '1';
            end if;
            if s.scl = '0' and scl_prev = '1' then
              sda_drv <= '0';
              if rw = '0' then
                state <= GET_BYTE;
              else
                shift   <= shadow;
                bit_cnt <= (others => '0');
                state   <= SEND_BYTE;
              end if;
            end if;

          when SEND_BYTE =>
            if s.scl = '0' and scl_prev = '1' then
              sda_drv <= not shift(7);
              shift   <= shift(6 downto 0) & '0';
              bit_cnt <= bit_cnt + 1;
            end if;
            if stop = '1' then
              sda_drv <= '0';
              state   <= IDLE;
            end if;

        end case;
      end if;
    end if;
  end process;

end architecture;
