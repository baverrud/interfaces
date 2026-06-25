-- =====================================================================
-- axi4_master_unified.vhd - full AXI4 master (unified axi4_t port)
-- =====================================================================
--
-- !!! INTENTIONALLY BROKEN -- kept as a test case for future tool versions. !!!
--
-- VHDL-2019 `view master of axi4_t` requires a record with more than 6
-- unconstrained std_logic_vector elements, which exceeds the parser limit
-- in both Questa 2025.3 and Vivado 2026.1.
--
-- Use `top_hp.vhd` (fully constrained `axi4_hp_t`) for a working example
-- of the unified-record approach.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axi4_pkg.all;

entity axi4_master_unified is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; ID_W: positive:=4; BURST_LEN: positive:=4);
  port (aclk, aresetn: in std_logic;
      -- Unified AXI4 master view: all 5 channels in one record
      m: view master of axi4_t;
      rd_data: out std_logic_vector(DATA_W-1 downto 0); rd_valid, done: out std_logic);
end entity;

architecture rtl of axi4_master_unified is
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
  -- Write address channel: ID=0, size=4B, burst=INCR, all others zero
  m.awid     <= (m.awid'range => '0');
  m.awlen    <= std_logic_vector(AXLEN);
  m.awsize   <= "010"; m.awburst <= "01"; m.awlock <= '0';
  m.awcache  <= "0000"; m.awprot <= "000"; m.awqos <= "0000"; m.awregion <= "0000";
  m.awuser   <= (m.awuser'range => '0');
  -- Read address channel: same fixed defaults as write address
  m.arid     <= (m.arid'range => '0');
  m.arlen    <= std_logic_vector(AXLEN);
  m.arsize   <= "010"; m.arburst <= "01"; m.arlock <= '0';
  m.arcache  <= "0000"; m.arprot <= "000"; m.arqos <= "0000"; m.arregion <= "0000";
  m.aruser   <= (m.aruser'range => '0');
  -- Write data: all byte lanes enabled, user=0
  m.wstrb    <= (m.wstrb'range => '1');
  m.wuser    <= (m.wuser'range => '0');

  -- ===================================================================
  -- Main FSM: write phase -> read phase -> done
  -- ===================================================================
  process (aclk, aresetn)
  begin
    if aresetn = '0' then
      state <= S_AW; done <= '0'; beat_cnt <= (others => '0');
      m.awvalid <= '0'; m.wvalid <= '0'; m.bready <= '0';
      m.arvalid <= '0'; m.rready <= '0';
      m.awaddr  <= (m.awaddr'range => '0');
      m.araddr  <= (m.araddr'range => '0');
      rd_data   <= (others => '0'); rd_valid <= '0';
    elsif rising_edge(aclk) then
      done <= '0'; rd_valid <= '0';
      case state is
        -- Write address: drive AW channel, transition to S_WRITE on handshake
        when S_AW =>
          m.awaddr <= (m.awaddr'range => '0');
          if m.awvalid = '0' then m.awvalid <= '1'; end if;
          if m.awvalid = '1' and m.awready = '1' then
            state <= S_WRITE; beat_cnt <= (others => '0'); end if;
        -- Write data: send BURST_LEN beats with incrementing pattern (0xA0+beat)
        when S_WRITE =>
          if m.wvalid = '0' then
            m.wvalid <= '1';
            m.wlast <= '1' when BURST_LEN = 1 else '0';
            m.wdata <= std_logic_vector(to_unsigned(16#A0#, 8) + beat_cnt) &
                   std_logic_vector(to_unsigned(to_integer(beat_cnt) + 1, 24));
          elsif m.wvalid = '1' and m.wready = '1' then
            if beat_cnt = AXLEN then state <= S_B;
            else beat_cnt <= beat_cnt + 1;
              m.wdata <= std_logic_vector(to_unsigned(16#A0#, 8) + beat_cnt + 1) &
                     std_logic_vector(to_unsigned(to_integer(beat_cnt) + 2, 24));
              m.wlast <= '1' when beat_cnt + 1 = AXLEN else '0'; end if; end if;
        -- Write response: wait for bvalid, then proceed to read phase
        when S_B =>
          if m.bready = '0' then m.bready <= '1'; end if;
          if m.bvalid = '1' and m.bready = '1' then
            m.wvalid <= '0'; m.awvalid <= '0'; state <= S_AR; beat_cnt <= (others => '0'); end if;
        -- Read address: drive AR channel, transition to S_READ on handshake
        when S_AR =>
          m.araddr <= (m.araddr'range => '0');
          if m.arvalid = '0' then m.arvalid <= '1'; end if;
          if m.arvalid = '1' and m.arready = '1' then
            state <= S_READ; beat_cnt <= (others => '0'); end if;
        -- Read data: capture incoming R beats, forward to rd_data/rd_valid
        when S_READ =>
          if m.rready = '0' then m.rready <= '1'; end if;
          if m.rvalid = '1' and m.rready = '1' then
            rd_valid <= '1'; rd_data <= m.rdata;
            if beat_cnt = AXLEN then state <= S_DONE; else beat_cnt <= beat_cnt + 1; end if; end if;
        -- Done: assert done pulse and idle all handshakes
        when S_DONE =>
          done <= '1'; m.arvalid <= '0'; m.rready <= '0';
      end case; end if; end process;
end architecture;
