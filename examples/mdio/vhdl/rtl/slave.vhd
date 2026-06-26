-- =====================================================================
-- mdio_phy.vhd - MDIO PHY with shadow register (VHDL-2019)
-- =====================================================================
-- IEEE 802.3 Clause 22 MDIO PHY.
-- Write: captures 16 data bits into shadow register.
-- Read:  drives shadow register onto MDIO after TA.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mdio_pkg.all;

entity mdio_phy is
  port (
    clk, rstn : in  std_logic;
    s         : view phy of mdio_t;
    done      : out std_logic
  );
end entity;

architecture rtl of mdio_phy is

  signal mdio_drv : std_logic := '0';
  signal mdc_prev : std_logic := '0';
  signal mdc_rise, mdc_fall : std_logic;
  signal mdio_val : std_logic;

  type state_t is (
    IDLE, PRE, ST, OP, PHYAD, REGAD, TA,
    DATA_CAP, TA_READY, DATA_SEND
  );
  signal state    : state_t := IDLE;
  signal bit_cnt  : unsigned(5 downto 0);
  signal shadow   : std_logic_vector(15 downto 0) := x"A5A5";
  signal is_write : std_logic;

begin

  done <= '0';

  mdc_rise <= s.mdc and not mdc_prev;
  mdc_fall <= not s.mdc and mdc_prev;
  mdio_val <= to_x01(s.mdio);
  s.mdio <= '0' when mdio_drv = '1' else 'Z';

  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        state    <= IDLE;
        mdio_drv <= '0';
        mdc_prev <= '0';
      else
        mdc_prev <= s.mdc;

        case state is

          when IDLE =>
            mdio_drv <= '0';
            bit_cnt  <= (others => '0');
            if mdc_rise = '1' and mdio_val = '1' then
              state <= PRE;
            end if;

          when PRE =>
            if mdc_rise = '1' then
              if bit_cnt < 32 then
                bit_cnt <= bit_cnt + 1;
              end if;
              if mdio_val = '0' and bit_cnt >= 2 then
                bit_cnt <= to_unsigned(1, 6);
                state   <= ST;
              end if;
            end if;

          when ST =>
            if mdc_rise = '1' then
              if bit_cnt = 0 then
                bit_cnt <= to_unsigned(1, 6);
              else
                bit_cnt <= (others => '0');
                state   <= OP;
              end if;
            end if;

          when OP =>
            if mdc_rise = '1' then
              is_write <= mdio_val;
              if bit_cnt = 0 then
                bit_cnt <= to_unsigned(1, 6);
              else
                bit_cnt <= (others => '0');
                state   <= PHYAD;
              end if;
            end if;

          when PHYAD =>
            if mdc_rise = '1' then
              if bit_cnt < 5 then
                bit_cnt <= bit_cnt + 1;
              else
                bit_cnt <= (others => '0');
                state   <= REGAD;
              end if;
            end if;

          when REGAD =>
            if mdc_rise = '1' then
              if bit_cnt < 5 then
                bit_cnt <= bit_cnt + 1;
              else
                bit_cnt <= (others => '0');
                state   <= TA;
              end if;
            end if;

          when TA =>
            if mdc_rise = '1' then
              if bit_cnt = 0 then
                bit_cnt <= to_unsigned(1, 6);
              else
                bit_cnt <= (others => '0');
                if is_write = '1' then
                  state <= DATA_CAP;
                else
                  state <= TA_READY;
                end if;
              end if;
            end if;

          when DATA_CAP =>
            if mdc_rise = '1' then
              shadow <= shadow(14 downto 0) & mdio_val;
              if bit_cnt = 15 then
                state <= IDLE;
              else
                bit_cnt <= bit_cnt + 1;
              end if;
            end if;

          when TA_READY =>
            if mdc_fall = '1' then
              bit_cnt <= (others => '0');
              state   <= DATA_SEND;
            end if;

          when DATA_SEND =>
            if mdc_fall = '1' then
              mdio_drv <= not shadow(15 - to_integer(bit_cnt));
              if bit_cnt = 15 then
                state <= IDLE;
              else
                bit_cnt <= bit_cnt + 1;
              end if;
            end if;

        end case;
      end if;
    end if;
  end process;

end architecture;
