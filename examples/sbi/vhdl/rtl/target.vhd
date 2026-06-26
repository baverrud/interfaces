-- =====================================================================
-- sbi_target.vhd - single-register SBI target (VHDL-2019)
-- =====================================================================
-- Responds to write/read at address 0. rdata registered continuously
-- from reg0 so it's available when ready pulses.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sbi_pkg.all;

entity sbi_target is
  generic (DATA_W : positive := 32; ADDR_W : positive := 8);
  port (clk, rstn : in std_logic; s : view target of sbi_t);
end entity;

architecture rtl of sbi_target is
  signal reg0 : std_logic_vector(DATA_W - 1 downto 0);
begin
  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        reg0    <= (others => '0');
        s.rdata <= (s.rdata'range => '0');
        s.ready <= '0';
      else
        s.ready <= '0';          -- one-cycle pulse
        s.rdata <= reg0;         -- always reflect register
        if s.cs = '1' then
          s.ready <= '1';
          if s.wr = '1' then
            reg0 <= s.wdata;     -- write: capture data
          end if;
        end if;
      end if;
    end if;
  end process;
end architecture;
