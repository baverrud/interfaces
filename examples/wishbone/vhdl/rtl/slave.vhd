-- =====================================================================
-- wishbone_slave.vhd - single-register Wishbone slave (VHDL-2019)
-- =====================================================================
-- Responds to write/read at address 0 with single-cycle ack.
-- Read data is combinatorial from the register.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wishbone_pkg.all;

entity wishbone_slave is
  generic (DATA_W : positive := 32; ADDR_W : positive := 32);
  port (clk, rstn : in std_logic; s : view slave of wishbone_t);
end entity;

architecture rtl of wishbone_slave is
  signal reg0 : std_logic_vector(DATA_W - 1 downto 0);
begin
  s.dat_i <= reg0;                -- combinatorial: always valid
  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        reg0 <= (others => '0');
        s.ack <= '0'; s.err <= '0';
      else
        s.ack <= '0';             -- default: one-cycle pulse
        if s.stb = '1' and s.cyc = '1' then
          s.ack <= '1';
          if s.we = '1' then
            reg0 <= s.dat_o;      -- write: capture data
          end if;
        end if;
      end if;
    end if;
  end process;
end architecture;
