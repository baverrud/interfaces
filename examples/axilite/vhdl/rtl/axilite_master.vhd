-- =====================================================================
-- axilite_master.vhd - full AXI4-Lite master (per-channel ports)
-- =====================================================================
-- Drives a complete AXI4-Lite write-then-read sequence autonomously.
-- AXI4-Lite is single-beat: writes are AW -> W -> B; reads are
-- AR -> R.  There is no burst logic.
--
-- Write phase: issues AW, drives W data (0xA5A5A5A5), waits for B.
-- Read phase:  issues AR, captures R data.
-- Exposes rd_data/rd_valid for external consumption and a done pulse on
-- completion.  All fixed sideband signals are tied to constant defaults.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axilite_pkg.all;

entity axilite_master is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; USER_W: positive:=1);
  port (aclk, aresetn: in std_logic;
      -- Write address, write data, write response sub-channels
      aw: view master_aw of axilite_aw_t; w: view master_w of axilite_w_t; b: view master_b of axilite_b_t;
      -- Read address, read data sub-channels
      ar: view master_ar of axilite_ar_t; r: view master_r of axilite_r_t;
      rd_data: out std_logic_vector(DATA_W-1 downto 0); rd_valid, done: out std_logic);
end entity;

architecture rtl of axilite_master is
  -- Main FSM: S_AW -> S_WRITE -> S_B -> S_AR -> S_READ -> S_DONE
  type state_t is (S_AW, S_WRITE, S_B, S_AR, S_READ, S_DONE);
  signal state: state_t := S_AW;
begin
  -- ===================================================================
  -- Concurrent assignments: fixed AXI4-Lite sideband signals
  -- ===================================================================
  -- Write address channel: prot=normal secure data, user=0, addr driven
  -- by FSM.
  aw.awprot   <= "000";               -- normal secure data access
  aw.awuser   <= (aw.awuser'range => '0');
  -- Read address channel: same defaults
  ar.arprot   <= "000";
  ar.aruser   <= (ar.aruser'range => '0');
  -- Write data: all byte lanes enabled, user sideband = 0
  w.wstrb     <= (w.wstrb'range => '1');
  w.wuser     <= (w.wuser'range => '0');

  -- ===================================================================
  -- Main FSM: write phase -> read phase -> done
  -- ===================================================================
  process (aclk, aresetn)
  begin
    if aresetn = '0' then
      state <= S_AW; done <= '0'; rd_valid <= '0';
      aw.awvalid <= '0'; w.wvalid <= '0'; b.bready <= '0';
      ar.arvalid <= '0'; r.rready <= '0';
      aw.awaddr  <= (aw.awaddr'range => '0');
      ar.araddr  <= (ar.araddr'range => '0');
      rd_data   <= (others => '0');
    elsif rising_edge(aclk) then
      done <= '0'; rd_valid <= '0';
      case state is
        -- Write address: drive AW channel, transition to S_WRITE on handshake
        when S_AW =>
          aw.awaddr <= (aw.awaddr'range => '0');
          if aw.awvalid = '0' then aw.awvalid <= '1'; end if;
          if aw.awvalid = '1' and aw.awready = '1' then
            state <= S_WRITE; end if;
        -- Write data: send single beat with pattern 0xA5A5A5A5
        when S_WRITE =>
          if w.wvalid = '0' then
            w.wvalid <= '1';
            w.wdata  <= x"A5A5A5A5";
          elsif w.wvalid = '1' and w.wready = '1' then
            state <= S_B; end if;
        -- Write response: wait for bvalid, then proceed to read phase
        when S_B =>
          if b.bready = '0' then b.bready <= '1'; end if;
          if b.bvalid = '1' and b.bready = '1' then
            w.wvalid <= '0'; aw.awvalid <= '0'; state <= S_AR; end if;
        -- Read address: drive AR channel, transition to S_READ on handshake
        when S_AR =>
          ar.araddr <= (ar.araddr'range => '0');
          if ar.arvalid = '0' then ar.arvalid <= '1'; end if;
          if ar.arvalid = '1' and ar.arready = '1' then
            state <= S_READ; end if;
        -- Read data: capture incoming R beat, forward to rd_data/rd_valid
        when S_READ =>
          if r.rready = '0' then r.rready <= '1'; end if;
          if r.rvalid = '1' and r.rready = '1' then
            rd_valid <= '1'; rd_data <= r.rdata;
            state <= S_DONE; end if;
        -- Done: assert done pulse and idle all handshakes
        when S_DONE =>
          done <= '1'; ar.arvalid <= '0'; r.rready <= '0';
      end case; end if; end process;
end architecture;
