-- =====================================================================
-- apb_consumer.vhd - single-register APB slave (VHDL-2019)
-- =====================================================================
-- FSM: IDLE -> SETUP (PSEL seen) -> ACCESS (PENABLE seen) -> back
-- Single register at address 0.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.apb_pkg.all;

entity apb_slave is
  generic (DATA_W : positive := 32; ADDR_W : positive := 32);
  port (pclk, prstn : in std_logic; s : view slave of apb_t);
end entity;

architecture rtl of apb_slave is
  type s_t is (IDLE, SETUP, ACCESS_S);
  signal st   : s_t;
  signal reg0 : std_logic_vector(DATA_W - 1 downto 0);
begin
  process (pclk) begin
    if rising_edge(pclk) then
      if prstn = '0' then
        st <= IDLE; reg0 <= (others => '0');
        s.pready <= '0'; s.pslverr <= '0';
        s.prdata <= (s.prdata'range => '0');
      else
        case st is
          when IDLE =>                       -- Wait for PSEL (SETUP)
            s.pready <= '0';
            if s.psel = '1' and s.penable = '0' then st <= SETUP; end if;
          when SETUP =>                      -- Wait for PENABLE (ACCESS)
            if s.penable = '1' then
              st <= ACCESS_S; s.pready <= '1';
              if s.pwrite = '1' then reg0 <= s.pwdata;
              else s.prdata <= reg0; end if;
            end if;
          when ACCESS_S =>                     -- De-assert, back to IDLE
            s.pready <= '0'; st <= IDLE;
        end case;
      end if;
    end if;
  end process;
end architecture;
