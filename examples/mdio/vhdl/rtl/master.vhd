-- =====================================================================
-- mdio_manager.vhd - MDIO manager test (VHDL-2019)
-- =====================================================================
-- IEEE 802.3 Clause 22 MDIO write+read:
-- Write: PREAMBLE+ST+OP_WR+PHYAD+REGAD+TA+DATA
-- Read:  PREAMBLE+ST+OP_RD+PHYAD+REGAD+TA + receive DATA
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.mdio_pkg.all;

entity mdio_manager is
  generic (
    PHY_ADDR : std_logic_vector(4 downto 0) := "00001";
    REG_ADDR : std_logic_vector(4 downto 0) := "00001";
    WR_DATA  : std_logic_vector(15 downto 0) := x"A5A5"
  );
  port (
    clk, rstn : in  std_logic;
    m         : view manager of mdio_t;
    done      : out std_logic
  );
end entity;

architecture rtl of mdio_manager is

  signal mdc_reg : std_logic := '0';
  signal mdc_prev : std_logic := '0';
  signal mdc_rise, mdc_fall : std_logic;

  signal mdio_drv : std_logic := '0';
  signal mdio_val : std_logic;

  type state_t is (
    IDLE,
    PRE_W, ST_W, OP_W, PHYAD_W, REGAD_W, TA_W, DATA_W,
    PRE_R, ST_R, OP_R, PHYAD_R, REGAD_R, TA_R, DATA_R,
    DONE_S
  );
  signal state   : state_t := IDLE;
  signal bit_cnt : unsigned(5 downto 0);
  signal rx_data : std_logic_vector(15 downto 0);

begin

  -- MDC generation (clk/2) and edge detection
  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        mdc_reg  <= '0';
        mdc_prev <= '0';
      else
        mdc_prev <= mdc_reg;
        mdc_reg  <= not mdc_reg;
      end if;
    end if;
  end process;
  m.mdc <= mdc_reg;
  mdc_rise <= mdc_reg and not mdc_prev;
  mdc_fall <= not mdc_reg and mdc_prev;

  -- MDIO open-drain driver
  m.mdio <= '0' when mdio_drv = '1' else 'Z';
  mdio_val <= to_x01(m.mdio);

  -- Main FSM
  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        state    <= IDLE;
        mdio_drv <= '0';
        done     <= '0';
      else
        case state is

          when IDLE =>
            bit_cnt <= (others => '0');
            state   <= PRE_W;

          -- Write: PREAMBLE (32 x 1)
          when PRE_W =>
            if mdc_fall = '1' then
              mdio_drv <= '0';
              if bit_cnt = 31 then
                bit_cnt <= (others => '0');
                state   <= ST_W;
              else
                bit_cnt <= bit_cnt + 1;
              end if;
            end if;

          when ST_W =>
            if mdc_fall = '1' then
              mdio_drv <= '1' when bit_cnt = 0 else '0';
              if bit_cnt = 1 then
                bit_cnt <= (others => '0');
                state   <= OP_W;
              else
                bit_cnt <= bit_cnt + 1;
              end if;
            end if;

          when OP_W =>
            if mdc_fall = '1' then
              mdio_drv <= '1' when bit_cnt = 0 else '0';
              if bit_cnt = 1 then
                bit_cnt <= (others => '0');
                state   <= PHYAD_W;
              else
                bit_cnt <= bit_cnt + 1;
              end if;
            end if;

          when PHYAD_W =>
            if mdc_fall = '1' then
              mdio_drv <= not PHY_ADDR(4 - to_integer(bit_cnt));
              if bit_cnt = 4 then
                bit_cnt <= (others => '0');
                state   <= REGAD_W;
              else
                bit_cnt <= bit_cnt + 1;
              end if;
            end if;

          when REGAD_W =>
            if mdc_fall = '1' then
              mdio_drv <= not REG_ADDR(4 - to_integer(bit_cnt));
              if bit_cnt = 4 then
                bit_cnt <= (others => '0');
                state   <= TA_W;
              else
                bit_cnt <= bit_cnt + 1;
              end if;
            end if;

          when TA_W =>
            if mdc_fall = '1' then
              mdio_drv <= '0' when bit_cnt = 0 else '1';
              if bit_cnt = 1 then
                bit_cnt <= (others => '0');
                state   <= DATA_W;
              else
                bit_cnt <= bit_cnt + 1;
              end if;
            end if;

          when DATA_W =>
            if mdc_fall = '1' then
              mdio_drv <= not WR_DATA(15 - to_integer(bit_cnt));
              if bit_cnt = 15 then
                bit_cnt <= (others => '0');
                state   <= PRE_R;
              else
                bit_cnt <= bit_cnt + 1;
              end if;
            end if;

          -- Read: PREAMBLE
          when PRE_R =>
            if mdc_fall = '1' then
              mdio_drv <= '0';
              if bit_cnt = 31 then
                bit_cnt <= (others => '0');
                state   <= ST_R;
              else
                bit_cnt <= bit_cnt + 1;
              end if;
            end if;

          when ST_R =>
            if mdc_fall = '1' then
              mdio_drv <= '1' when bit_cnt = 0 else '0';
              if bit_cnt = 1 then
                bit_cnt <= (others => '0');
                state   <= OP_R;
              else
                bit_cnt <= bit_cnt + 1;
              end if;
            end if;

          when OP_R =>
            if mdc_fall = '1' then
              mdio_drv <= '0' when bit_cnt = 0 else '1';
              if bit_cnt = 1 then
                bit_cnt <= (others => '0');
                state   <= PHYAD_R;
              else
                bit_cnt <= bit_cnt + 1;
              end if;
            end if;

          when PHYAD_R =>
            if mdc_fall = '1' then
              mdio_drv <= not PHY_ADDR(4 - to_integer(bit_cnt));
              if bit_cnt = 4 then
                bit_cnt <= (others => '0');
                state   <= REGAD_R;
              else
                bit_cnt <= bit_cnt + 1;
              end if;
            end if;

          when REGAD_R =>
            if mdc_fall = '1' then
              mdio_drv <= not REG_ADDR(4 - to_integer(bit_cnt));
              if bit_cnt = 4 then
                bit_cnt <= (others => '0');
                state   <= TA_R;
              else
                bit_cnt <= bit_cnt + 1;
              end if;
            end if;

          when TA_R =>
            if mdc_fall = '1' then
              if bit_cnt = 0 then
                mdio_drv <= '0';  -- release (Z)
                bit_cnt <= to_unsigned(1, 6);
              else
                bit_cnt <= (others => '0');
                state   <= DATA_R;
              end if;
            end if;

          when DATA_R =>
            if mdc_rise = '1' then
              rx_data <= rx_data(14 downto 0) & mdio_val;
              if bit_cnt = 15 then
                state <= DONE_S;
              else
                bit_cnt <= bit_cnt + 1;
              end if;
            end if;

          when DONE_S =>
            done <= '1';

        end case;
      end if;
    end if;
  end process;

end architecture;
