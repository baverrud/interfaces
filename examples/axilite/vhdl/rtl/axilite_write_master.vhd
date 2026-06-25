-- =====================================================================
-- axilite_write_master.vhd - write-only AXI4-Lite master
-- =====================================================================
-- Demonstrates the sub-channel view paradigm: this module uses only
-- the write-side views (master_aw, master_w, master_b) and has zero
-- read-channel logic or signals.
--
-- Ports:
--   aw    — Write Address channel (master_aw) — Tx
--   w     — Write Data channel    (master_w)   — Tx
--   b     — Write Response channel (master_b)  — Rx
--   start — begin the write transaction
--   done  — asserted when write completes
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axilite_pkg.all;

entity axilite_write_master is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; USER_W: positive:=1);
  port (aclk, aresetn: in std_logic;
        aw: view master_aw of axilite_aw_t;
        w:  view master_w  of axilite_w_t;
        b:  view master_b  of axilite_b_t;
        start: in std_logic; done: out std_logic);
end entity;

architecture rtl of axilite_write_master is
  type state_t is (S_IDLE, S_AW, S_WRITE, S_B, S_DONE);
  signal state: state_t := S_IDLE;
begin
  aw.awprot <= "000";
  aw.awuser <= (aw.awuser'range => '0');
  w.wstrb   <= (w.wstrb'range => '1');
  w.wuser   <= (w.wuser'range => '0');

  process (aclk, aresetn)
  begin
    if aresetn = '0' then
      state <= S_IDLE; done <= '0';
      aw.awvalid <= '0'; w.wvalid <= '0'; b.bready <= '0';
    elsif rising_edge(aclk) then
      done <= '0';
      case state is
        when S_IDLE => if start = '1' then state <= S_AW; end if;
        when S_AW =>
          aw.awaddr <= std_logic_vector(to_unsigned(16#1000#, ADDR_W));
          if aw.awvalid = '0' then aw.awvalid <= '1'; end if;
          if aw.awvalid = '1' and aw.awready = '1' then state <= S_WRITE; end if;
        when S_WRITE =>
          if w.wvalid = '0' then
            w.wvalid <= '1';
            w.wdata  <= x"B0B0B0B0";
          elsif w.wvalid = '1' and w.wready = '1' then
            state <= S_B; end if;
        when S_B =>
          if b.bready = '0' then b.bready <= '1'; end if;
          if b.bvalid = '1' and b.bready = '1' then
            w.wvalid <= '0'; aw.awvalid <= '0'; state <= S_DONE; end if;
        when S_DONE =>
          done <= '1'; aw.awvalid <= '0'; w.wvalid <= '0'; b.bready <= '0';
      end case; end if; end process;
end architecture;
