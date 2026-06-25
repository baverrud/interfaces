-- =====================================================================
-- axi4_write_slave.vhd - write-only AXI4 slave (per-channel)
-- =====================================================================
-- Handles AXI4 write transactions only (no read path).  Captures AW
-- address + burst length, stores incoming W data into a register file
-- with byte-strobe gating, and responds with BRESP=OKAY.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axi4_pkg.all;

entity axi4_write_slave is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; ID_W: positive:=4; DEPTH: positive:=256);
  port (aclk, aresetn: in std_logic;
      -- Write sub-channels: address, data, response
      aw: view slave_aw of axi4_aw_t; w: view slave_w of axi4_w_t; b: view slave_b of axi4_b_t);
end entity;

architecture rtl of axi4_write_slave is
  -- Ceiling-log2 for address width from depth
  function clog2(n: positive) return natural is
    variable r: natural := 0; variable m: natural := n - 1;
  begin while m > 0 loop r := r + 1; m := m / 2; end loop; return r; end function;
  constant AW_BITS: natural := clog2(DEPTH);
  -- Register-file storage
  type mem_t is array (0 to DEPTH-1) of std_logic_vector(DATA_W-1 downto 0);
  signal mem: mem_t;
  -- Write-path FSM
  type wstate_t is (W_IDLE, W_DATA, W_RESP);
  signal wstate: wstate_t := W_IDLE;
  signal waddr: unsigned(AW_BITS-1 downto 0); signal wcnt: unsigned(7 downto 0);
  signal wid: std_logic_vector(ID_W-1 downto 0); signal bvalid_r: std_logic;
begin
  -- ===================================================================
  -- Write path control
  -- ===================================================================
  aw.awready <= '1' when wstate = W_IDLE else '0';
  w.wready   <= '1' when (wstate = W_IDLE or wstate = W_DATA) else '0';
  -- Write FSM: capture AW, store W beats with byte strobe, assert B response
  process (aclk, aresetn)
    variable wstrb_vec: std_logic_vector(DATA_W/8-1 downto 0);
  begin
    if aresetn = '0' then wstate <= W_IDLE; waddr <= (others => '0'); wcnt <= (others => '0'); bvalid_r <= '0';
    elsif rising_edge(aclk) then
      case wstate is
        -- W_IDLE: latch AW address/burst info, determine if burst or single-beat
        when W_IDLE => if aw.awvalid = '1' and aw.awready = '1' then
            wid <= aw.awid; wcnt <= unsigned(aw.awlen); waddr <= unsigned(aw.awaddr(AW_BITS-1 downto 0));
            wstate <= W_RESP when unsigned(aw.awlen) = 0 else W_DATA; end if;
        -- W_DATA: store each W beat with byte-lane write strobe gating
        when W_DATA => if w.wvalid = '1' and w.wready = '1' then wstrb_vec := w.wstrb;
            for i in 0 to DATA_W/8-1 loop
              if wstrb_vec(i) = '1' then mem(to_integer(waddr))(8*i+7 downto 8*i) <= w.wdata(8*i+7 downto 8*i); end if;
            end loop; waddr <= waddr + 1; if w.wlast = '1' then wstate <= W_RESP; end if; end if;
        -- W_RESP: hold bvalid until master acknowledges
        when W_RESP => if bvalid_r = '1' and b.bready = '1' then wstate <= W_IDLE; end if;
      end case; end if; end process;
  -- B valid generation: start when entering W_RESP, clear on handshake
  process (aclk, aresetn) begin
    if aresetn = '0' then bvalid_r <= '0';
    elsif rising_edge(aclk) then
      if wstate = W_RESP and bvalid_r = '0' then bvalid_r <= '1';
      elsif b.bready = '1' then bvalid_r <= '0'; end if; end if; end process;
  b.bvalid <= bvalid_r; b.bid <= wid; b.bresp <= "00"; b.buser <= (b.buser'range => '0');
end architecture;
