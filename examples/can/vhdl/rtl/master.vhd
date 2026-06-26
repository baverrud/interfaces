-- =====================================================================
-- can_master.vhd - CAN controller test sequencer (VHDL-2019)
-- =====================================================================
-- Simulates a CAN frame start on TX:
--   1. IDLE:      TX = recessive (1)
--   2. DOMINANT:  TX = dominant (0) for 4 cycles
--   3. TOGGLE:    TX toggles for 4 cycles (data bits)
--   4. DONE:      back to recessive, assert done
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.can_pkg.all;

entity can_master is
  port (
    clk, rstn : in  std_logic;           -- system clock / active-low reset
    m         : view controller of can_t; -- CAN controller view (tx=out, rx=in)
    done      : out std_logic            -- high when test completes
  );
end entity;

architecture rtl of can_master is

  type state_t is (IDLE, DOMINANT, TOGGLE, DONE_S);
  signal state : state_t := IDLE;
  signal cnt   : unsigned(3 downto 0);   -- per-state counter

begin

  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        state <= IDLE;
        m.tx  <= '1';                    -- bus idle = recessive
        done  <= '0';
      else
        case state is

          when IDLE =>
            m.tx  <= '1';
            cnt   <= (others => '0');
            state <= DOMINANT;

          when DOMINANT =>
            m.tx <= '0';                 -- dominant (0) for 4 cycles
            if cnt = 3 then
              cnt   <= (others => '0');
              state <= TOGGLE;
            else
              cnt <= cnt + 1;
            end if;

          when TOGGLE =>
            m.tx <= not m.tx;            -- toggle each cycle
            if cnt = 3 then
              state <= DONE_S;
            else
              cnt <= cnt + 1;
            end if;

          when DONE_S =>
            m.tx <= '1';                 -- back to recessive
            done <= '1';

        end case;
      end if;
    end if;
  end process;

end architecture;
