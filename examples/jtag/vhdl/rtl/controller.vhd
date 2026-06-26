-- =====================================================================
-- jtag_controller.vhd - JTAG TAP controller (VHDL-2019)
-- =====================================================================
-- Generates TCK (clk/2), drives TMS/TDI to navigate the TAP through
-- a bypass-register test:
--   Reset → RTI → Select-DR → Capture-DR → Shift-DR → Exit1-DR →
--   Update-DR → RTI → DONE
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.jtag_pkg.all;

entity jtag_controller is
  port (
    clk, rstn : in  std_logic;            -- system clock / active-low reset
    m         : view controller of jtag_t; -- controller view (tck/tms/tdi=out, tdo=in)
    done      : out std_logic             -- high when test completes
  );
end entity;

architecture rtl of jtag_controller is

  -- TCK generation (clk/2)
  signal tck_reg  : std_logic := '0';
  signal tck_prev : std_logic := '0';
  signal tck_rise, tck_fall : std_logic;

  -- FSM
  type state_t is (
    RST1, RST2, RST3, RST4, RST5,
    GO_RTI, GO_SEL_DR, GO_CAP_DR, GO_SHIFT_DR,
    SHIFT_BIT, EXIT_SHIFT, GO_UPD_DR, GO_RTI2,
    DONE_S
  );
  signal state : state_t := RST1;

begin

  -- TCK generation
  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        tck_reg  <= '0';
        tck_prev <= '0';
      else
        tck_prev <= tck_reg;
        tck_reg  <= not tck_reg;
      end if;
    end if;
  end process;
  m.tck <= tck_reg;
  tck_rise <= tck_reg and not tck_prev;
  tck_fall <= not tck_reg and tck_prev;

  -- TMS/TDI sequencing on TCK falling edge
  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        state <= RST1;
        m.tms <= '0';
        m.tdi <= '0';
        done  <= '0';
      elsif tck_fall = '1' then
        case state is

          when RST1 | RST2 | RST3 | RST4 =>
            m.tms <= '1';
            state <= state_t'succ(state);

          when RST5 =>
            m.tms <= '1';
            state <= GO_RTI;

          when GO_RTI =>
            m.tms <= '0';
            state <= GO_SEL_DR;

          when GO_SEL_DR =>
            m.tms <= '1';
            state <= GO_CAP_DR;

          when GO_CAP_DR =>
            m.tms <= '0';
            state <= GO_SHIFT_DR;

          when GO_SHIFT_DR =>
            m.tms <= '0';
            state <= SHIFT_BIT;

          when SHIFT_BIT =>
            m.tms  <= '1';
            m.tdi  <= '1';
            state  <= EXIT_SHIFT;

          when EXIT_SHIFT =>
            m.tms <= '1';
            state <= GO_UPD_DR;

          when GO_UPD_DR =>
            m.tms <= '1';
            state <= GO_RTI2;

          when GO_RTI2 =>
            m.tms <= '0';
            state <= DONE_S;

          when DONE_S =>
            done <= '1';

        end case;
      end if;
    end if;
  end process;

end architecture;
