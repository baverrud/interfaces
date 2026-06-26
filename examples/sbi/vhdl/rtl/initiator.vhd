-- =====================================================================
-- sbi_initiator.vhd - SBI test sequencer (VHDL-2019)
-- =====================================================================
-- Writes 0xA5 to address 0, reads it back, asserts done.
-- Uses per-channel constrained records with initiator/target views.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.sbi_pkg.all;

entity sbi_initiator is
  generic (DATA_W : positive := 32; ADDR_W : positive := 8);
  port (
    clk, rstn : in  std_logic;
    m         : view initiator of sbi_t;
    rd_data   : out std_logic_vector(DATA_W-1 downto 0);
    rd_valid  : out std_logic;
    done      : out std_logic
  );
end entity;

architecture rtl of sbi_initiator is
  type s_t is (IDLE, WR, RD, DONE_S);
  signal s     : s_t;
  signal rdata : std_logic_vector(DATA_W - 1 downto 0);
begin
  rd_data <= rdata;
  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        s <= IDLE; rd_valid <= '0'; done <= '0'; rdata <= (others => '0');
        m.cs <= '0'; m.addr <= (m.addr'range => '0');
        m.wr <= '0'; m.rd <= '0'; m.wdata <= (m.wdata'range => '0');
      else
        case s is
          when IDLE =>                              -- Write: CS + WR + data
            m.cs <= '1'; m.wr <= '1';
            m.wdata <= x"000000A5"; s <= WR;
          when WR =>                                 -- Wait for ready
            if m.ready = '1' then
              m.cs <= '0'; m.wr <= '0'; s <= RD;
            end if;
          when RD =>                                 -- Read: CS + RD
            m.cs <= '1'; m.rd <= '1';
            if m.ready = '1' then
              rdata <= m.rdata; rd_valid <= '1';
              m.cs <= '0'; m.rd <= '0'; s <= DONE_S;
            end if;
          when DONE_S => rd_valid <= '0'; done <= '1';
        end case;
      end if;
    end if;
  end process;
end architecture;
