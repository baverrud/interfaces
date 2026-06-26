-- =====================================================================
-- jtag_tap.vhd - JTAG TAP with bypass register (VHDL-2019)
-- =====================================================================
-- Implements the IEEE 1149.1 TAP state machine (16 states) and a
-- 1-bit bypass register.
--   Capture-DR: loads 0 into bypass
--   Shift-DR:   shifts TDI → bypass → TDO
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.jtag_pkg.all;

entity jtag_tap is
  port (
    clk, rstn : in  std_logic;            -- system clock / active-low reset
    s         : view tap of jtag_t;       -- TAP view (tck/tms/tdi=in, tdo=out)
    done      : out std_logic             -- unused
  );
end entity;

architecture rtl of jtag_slave is

  -- TCK edge detection
  signal tck_prev : std_logic := '0';
  signal tck_rise, tck_fall : std_logic;

  -- TAP state machine (16 states, IEEE 1149.1)
  type tap_state_t is (
    TLR, RTI,
    SEL_DR, CAP_DR, SHIFT_DR, EXIT1_DR, PAUSE_DR, EXIT2_DR, UPD_DR,
    SEL_IR, CAP_IR, SHIFT_IR, EXIT1_IR, PAUSE_IR, EXIT2_IR, UPD_IR
  );
  signal tap_state : tap_state_t := TLR;

  signal bypass_reg : std_logic := '0';

begin

  done <= '0';

  tck_rise <= s.tck and not tck_prev;
  tck_fall <= not s.tck and tck_prev;

  -- TDO driven on TCK falling edge
  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        s.tdo <= '0';
      elsif tck_fall = '1' then
        case tap_state is
          when SHIFT_DR => s.tdo <= bypass_reg;
          when others   => s.tdo <= '0';
        end case;
      end if;
    end if;
  end process;

  -- TAP state transitions on TCK rising edge
  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        tap_state  <= TLR;
        bypass_reg <= '0';
        tck_prev   <= '0';
      else
        tck_prev <= s.tck;

        if tck_rise = '1' then
          case tap_state is

            when TLR =>
              tap_state <= RTI when s.tms = '0' else TLR;

            when RTI =>
              tap_state <= SEL_DR when s.tms = '1' else RTI;

            when SEL_DR =>
              tap_state <= CAP_DR when s.tms = '0' else SEL_IR;

            when CAP_DR =>
              bypass_reg <= '0';
              tap_state  <= SHIFT_DR when s.tms = '0' else EXIT1_DR;

            when SHIFT_DR =>
              bypass_reg <= s.tdi;
              tap_state  <= SHIFT_DR when s.tms = '0' else EXIT1_DR;

            when EXIT1_DR =>
              tap_state <= PAUSE_DR when s.tms = '0' else UPD_DR;

            when PAUSE_DR =>
              tap_state <= PAUSE_DR when s.tms = '0' else EXIT2_DR;

            when EXIT2_DR =>
              tap_state <= SHIFT_DR when s.tms = '0' else UPD_DR;

            when UPD_DR =>
              tap_state <= RTI when s.tms = '0' else SEL_DR;

            when SEL_IR =>
              tap_state <= CAP_IR when s.tms = '0' else TLR;

            when CAP_IR =>
              tap_state <= SHIFT_IR when s.tms = '0' else EXIT1_IR;

            when SHIFT_IR =>
              tap_state <= SHIFT_IR when s.tms = '0' else EXIT1_IR;

            when EXIT1_IR =>
              tap_state <= PAUSE_IR when s.tms = '0' else UPD_IR;

            when PAUSE_IR =>
              tap_state <= PAUSE_IR when s.tms = '0' else EXIT2_IR;

            when EXIT2_IR =>
              tap_state <= SHIFT_IR when s.tms = '0' else UPD_IR;

            when UPD_IR =>
              tap_state <= RTI when s.tms = '0' else SEL_DR;

          end case;
        end if;
      end if;
    end if;
  end process;

end architecture;
