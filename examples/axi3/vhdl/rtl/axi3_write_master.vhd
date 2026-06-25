-- =====================================================================
-- axi3_write_master.vhd - write-only AXI3 master (per-channel)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axi3_pkg.all;

entity axi3_write_master is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; ID_W: positive:=4; BURST_LEN: positive:=4);
  port (aclk, aresetn: in std_logic;
      aw: view master_aw of axi3_aw_t; w: view master_w of axi3_w_t; b: view master_b of axi3_b_t;
      start: in std_logic; done: out std_logic);
end entity;

architecture rtl of axi3_write_master is
  constant AXLEN: unsigned(3 downto 0) := to_unsigned(BURST_LEN - 1, 4);
  type state_t is (S_IDLE, S_AW, S_WRITE, S_B, S_DONE);
  signal state: state_t := S_IDLE;
  signal beat_cnt: unsigned(3 downto 0);
begin
  aw.awid    <= (aw.awid'range => '0');
  aw.awlen   <= std_logic_vector(AXLEN);
  aw.awsize  <= "010"; aw.awburst <= "01"; aw.awlock <= "00";
  aw.awcache <= "0000"; aw.awprot <= "000"; aw.awqos <= "0000";
  aw.awuser  <= (aw.awuser'range => '0');
  w.wstrb    <= (w.wstrb'range => '1');
  w.wuser    <= (w.wuser'range => '0');
  w.wid      <= (w.wid'range => '0');

  process (aclk, aresetn)
  begin
    if aresetn = '0' then
      state <= S_IDLE; done <= '0'; beat_cnt <= (others => '0');
      aw.awvalid <= '0'; w.wvalid <= '0'; b.bready <= '0';
      aw.awaddr  <= (aw.awaddr'range => '0');
    elsif rising_edge(aclk) then
      done <= '0';
      case state is
        when S_IDLE => if start = '1' then state <= S_AW; beat_cnt <= (others => '0'); end if;
        when S_AW =>
          aw.awaddr <= X"00001000";
          if aw.awvalid = '0' then aw.awvalid <= '1'; end if;
          if aw.awvalid = '1' and aw.awready = '1' then
            state <= S_WRITE; beat_cnt <= (others => '0'); end if;
        when S_WRITE =>
          if w.wvalid = '0' then
            w.wvalid <= '1'; w.wlast <= '1' when BURST_LEN = 1 else '0';
            w.wdata <= std_logic_vector(to_unsigned(16#B0#, 8) + beat_cnt) &
                   std_logic_vector(to_unsigned(to_integer(beat_cnt) + 1, 24));
          elsif w.wvalid = '1' and w.wready = '1' then
            if beat_cnt = AXLEN then state <= S_B;
            else beat_cnt <= beat_cnt + 1;
              w.wdata <= std_logic_vector(to_unsigned(16#B0#, 8) + beat_cnt + 1) &
                     std_logic_vector(to_unsigned(to_integer(beat_cnt) + 2, 24));
              w.wlast <= '1' when beat_cnt + 1 = AXLEN else '0'; end if; end if;
        when S_B =>
          if b.bready = '0' then b.bready <= '1'; end if;
          if b.bvalid = '1' and b.bready = '1' then
            w.wvalid <= '0'; aw.awvalid <= '0'; state <= S_DONE; end if;
        when S_DONE =>
          done <= '1'; aw.awvalid <= '0'; w.wvalid <= '0'; b.bready <= '0';
      end case; end if; end process;
end architecture;
