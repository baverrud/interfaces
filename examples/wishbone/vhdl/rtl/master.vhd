-- =====================================================================
-- wishbone_master.vhd - Wishbone test sequencer (VHDL-2019)
-- =====================================================================
-- Writes 0xA5 to address 0, then reads it back. Uses per-channel
-- constrained records with mode views (master/slave).
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.wishbone_pkg.all;

entity wishbone_master is
  generic (DATA_W : positive := 32; ADDR_W : positive := 32);
  port (
    clk, rstn : in  std_logic;
    m         : view master of wishbone_t;
    rd_data   : out std_logic_vector(DATA_W-1 downto 0);
    rd_valid  : out std_logic;
    done      : out std_logic
  );
end entity;

architecture rtl of wishbone_master is
  type s_t is (IDLE, WR, RD, DONE_S);
  signal s     : s_t;
  signal rdata : std_logic_vector(DATA_W - 1 downto 0);
begin
  rd_data <= rdata;
  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        s <= IDLE; rd_valid <= '0'; done <= '0'; rdata <= (others => '0');
        m.adr <= (m.adr'range => '0'); m.dat_o <= (m.dat_o'range => '0');
        m.we <= '0'; m.sel <= (m.sel'range => '0'); m.stb <= '0'; m.cyc <= '0';
      else
        case s is
          when IDLE =>                              -- Write: drive addr, data, strobes
            m.adr <= (m.adr'range => '0'); m.dat_o <= x"000000A5";
            m.we <= '1'; m.sel <= (m.sel'range => '1');
            m.stb <= '1'; m.cyc <= '1'; s <= WR;
          when WR =>                                 -- Wait for acknowledge
            if m.ack = '1' then
              m.stb <= '0'; m.cyc <= '0'; m.we <= '0'; s <= RD;
            end if;
          when RD =>                                 -- Read: address, strobes, no WE
            m.adr <= (m.adr'range => '0'); m.we <= '0';
            m.stb <= '1'; m.cyc <= '1';
            if m.ack = '1' then
              rdata <= m.dat_i; rd_valid <= '1';
              m.stb <= '0'; m.cyc <= '0'; s <= DONE_S;
            end if;
          when DONE_S => rd_valid <= '0'; done <= '1';
        end case;
      end if;
    end if;
  end process;
end architecture;
