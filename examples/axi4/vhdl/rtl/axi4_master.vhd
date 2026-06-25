-- =====================================================================
-- axi4_master.vhd - full AXI4 master (per-channel ports)
-- =====================================================================
-- Drives a complete AXI4 write-then-read burst sequence autonomously.
-- Write phase: issues AW -> W beats -> waits for B response.
-- Read phase:  issues AR -> waits for R beats.
-- Exposes rd_data/rd_valid for external consumption and a done pulse on
-- completion. All fixed sideband signals are tied to constant defaults.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axi4_pkg.all;

entity axi4_master is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; ID_W: positive:=4; BURST_LEN: positive:=4);
  port (aclk, aresetn: in std_logic;
      -- Write address, write data, write response sub-channels
      aw: view master_aw of axi4_aw_t; w: view master_w of axi4_w_t; b: view master_b of axi4_b_t;
      -- Read address, read data sub-channels
      ar: view master_ar of axi4_ar_t; r: view master_r of axi4_r_t;
      rd_data: out std_logic_vector(DATA_W-1 downto 0); rd_valid, done: out std_logic);
end entity;

architecture rtl of axi4_master is
  -- AXLEN = total beats minus one (AXI burst length is zero-based)
  constant AXLEN: unsigned(7 downto 0) := to_unsigned(BURST_LEN - 1, 8);
  -- Main FSM: S_AW -> S_WRITE -> S_B -> S_AR -> S_READ -> S_DONE
  type state_t is (S_AW, S_WRITE, S_B, S_AR, S_READ, S_DONE);
  signal state: state_t := S_AW;
  signal beat_cnt: unsigned(7 downto 0);
begin
  -- ===================================================================
  -- Concurrent assignments: fixed AXI sideband signals
  -- ===================================================================
  -- Write address channel: ID=0, length=BURST_LEN-1, size=4B, burst=INCR,
  -- lock/cache/prot/QoS/region/user all driven to zero.
  aw.awid     <= (aw.awid'range => '0');
  aw.awlen    <= std_logic_vector(AXLEN);
  aw.awsize   <= "010"; aw.awburst <= "01"; aw.awlock <= '0';
  aw.awcache  <= "0000"; aw.awprot <= "000"; aw.awqos <= "0000"; aw.awregion <= "0000";
  aw.awuser   <= (aw.awuser'range => '0');
  -- Read address channel: same fixed defaults as write address
  ar.arid     <= (ar.arid'range => '0');
  ar.arlen    <= std_logic_vector(AXLEN);
  ar.arsize   <= "010"; ar.arburst <= "01"; ar.arlock <= '0';
  ar.arcache  <= "0000"; ar.arprot <= "000"; ar.arqos <= "0000"; ar.arregion <= "0000";
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
      state <= S_AW; done <= '0'; beat_cnt <= (others => '0');
      aw.awvalid <= '0'; w.wvalid <= '0'; b.bready <= '0';
      ar.arvalid <= '0'; r.rready <= '0';
      aw.awaddr  <= (aw.awaddr'range => '0');
      ar.araddr  <= (ar.araddr'range => '0');
      rd_data   <= (others => '0'); rd_valid <= '0';
    elsif rising_edge(aclk) then
      done <= '0'; rd_valid <= '0';
      case state is
        -- Write address: drive AW channel, transition to S_WRITE on handshake
        when S_AW =>
          aw.awaddr <= (aw.awaddr'range => '0');
          if aw.awvalid = '0' then aw.awvalid <= '1'; end if;
          if aw.awvalid = '1' and aw.awready = '1' then
            state <= S_WRITE; beat_cnt <= (others => '0'); end if;
        -- Write data: send BURST_LEN beats with incrementing pattern (0xA0+beat)
        when S_WRITE =>
          if w.wvalid = '0' then
            w.wvalid <= '1';
            w.wlast <= '1' when BURST_LEN = 1 else '0';
            w.wdata <= std_logic_vector(to_unsigned(16#A0#, 8) + beat_cnt) &
                   std_logic_vector(to_unsigned(to_integer(beat_cnt) + 1, 24));
          elsif w.wvalid = '1' and w.wready = '1' then
            if beat_cnt = AXLEN then state <= S_B;
            else beat_cnt <= beat_cnt + 1;
              w.wdata <= std_logic_vector(to_unsigned(16#A0#, 8) + beat_cnt + 1) &
                     std_logic_vector(to_unsigned(to_integer(beat_cnt) + 2, 24));
              w.wlast <= '1' when beat_cnt + 1 = AXLEN else '0'; end if; end if;
        -- Write response: wait for bvalid, then proceed to read phase
        when S_B =>
          if b.bready = '0' then b.bready <= '1'; end if;
          if b.bvalid = '1' and b.bready = '1' then
            w.wvalid <= '0'; aw.awvalid <= '0'; state <= S_AR; beat_cnt <= (others => '0'); end if;
        -- Read address: drive AR channel, transition to S_READ on handshake
        when S_AR =>
          ar.araddr <= (ar.araddr'range => '0');
          if ar.arvalid = '0' then ar.arvalid <= '1'; end if;
          if ar.arvalid = '1' and ar.arready = '1' then
            state <= S_READ; beat_cnt <= (others => '0'); end if;
        -- Read data: capture incoming R beats, forward to rd_data/rd_valid
        when S_READ =>
          if r.rready = '0' then r.rready <= '1'; end if;
          if r.rvalid = '1' and r.rready = '1' then
            rd_valid <= '1'; rd_data <= r.rdata;
            if beat_cnt = AXLEN then state <= S_DONE; else beat_cnt <= beat_cnt + 1; end if; end if;
        -- Done: assert done pulse and idle all handshakes
        when S_DONE =>
          done <= '1'; ar.arvalid <= '0'; r.rready <= '0';
      end case; end if; end process;
end architecture;
