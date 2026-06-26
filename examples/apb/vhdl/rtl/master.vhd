-- =====================================================================
-- apb_producer.vhd - APB test sequencer (VHDL-2019)
-- =====================================================================
-- Walks through APB write then read handshake:
--   IDLE -> WR_SETUP -> WR_ACCESS -> RD_SETUP -> RD_ACCESS -> DONE
-- APB protocol: SETUP phase (PSEL=1, PENABLE=0) then ACCESS (PENABLE=1)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.apb_pkg.all;

entity apb_master is
  generic (DATA_W : positive := 32; ADDR_W : positive := 32);
  port (
    pclk, prstn : in  std_logic;                            -- APB clock/reset
    m           : view master of apb_t;                     -- APB master view
    rd_data     : out std_logic_vector(DATA_W-1 downto 0);  -- read data
    rd_valid    : out std_logic;                             -- rd_data strobe
    done        : out std_logic                              -- sequence done
  );
end entity;

architecture rtl of apb_master is
  type s_t is (IDLE, WS, WA, RS, RA, DS);
  signal s     : s_t;
  signal rdata : std_logic_vector(DATA_W - 1 downto 0);
begin
  rd_data <= rdata;
  process (pclk) begin
    if rising_edge(pclk) then
      if prstn = '0' then
        s <= IDLE; rdata <= (others => '0');
        m.psel <= '0'; m.penable <= '0'; m.pwrite <= '0';
        m.paddr <= (m.paddr'range => '0'); m.pwdata <= (m.pwdata'range => '0');
        m.pprot <= (others => '0'); m.pstrb <= (m.pstrb'range => '0');
        rd_valid <= '0'; done <= '0';
      else
        case s is
          when IDLE =>                       -- Write SETUP: address, data, write
            m.psel <= '1'; m.paddr <= (m.paddr'range => '0');
            m.pwdata <= x"000000A5"; m.pwrite <= '1'; s <= WS;
          when WS =>                         -- Write ACCESS: assert PENABLE
            m.penable <= '1'; s <= WA;
          when WA =>                         -- Wait for PREADY
            if m.pready = '1' then
              m.psel <= '0'; m.penable <= '0'; m.pwrite <= '0'; s <= RS;
            end if;
          when RS =>                         -- Read SETUP: address, read strobe
            m.psel <= '1'; m.paddr <= (m.paddr'range => '0');
            m.pwrite <= '0'; s <= RA;
          when RA =>                         -- Read ACCESS: assert PENABLE
            m.penable <= '1';
            if m.pready = '1' then
              rdata <= m.prdata; rd_valid <= '1';
              m.psel <= '0'; m.penable <= '0'; s <= DS;
            end if;
          when DS =>                         -- Done
            rd_valid <= '0'; done <= '1';
        end case;
      end if;
    end if;
  end process;
end architecture;
