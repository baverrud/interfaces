-- =====================================================================
-- axilite_slave.vhd - full AXI4-Lite slave (per-channel ports)
-- =====================================================================
-- Implements a register-file memory slave that handles both write and
-- read transactions over the AXI4-Lite bus.
--
-- Write path: captures AW address + W data (with byte strobe gating),
--   then asserts bvalid with BRESP=OKAY.  Handles W-before-AW ordering.
-- Read path:  captures AR address, reads memory, returns R data.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axilite_pkg.all;

entity axilite_slave is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; USER_W: positive:=1; DEPTH: positive:=256);
  port (aclk, aresetn: in std_logic;
      -- Write channels: address + data + response
      aw: view slave_aw of axilite_aw_t; w: view slave_w of axilite_w_t; b: view slave_b of axilite_b_t;
      -- Read channels: address + data
      ar: view slave_ar of axilite_ar_t; r: view slave_r of axilite_r_t);
end entity;

architecture rtl of axilite_slave is
  function clog2(n: positive) return natural is
    variable r: natural := 0; variable m: natural := n - 1;
  begin while m > 0 loop r := r + 1; m := m / 2; end loop; return r; end function;
  constant AW_BITS: natural := clog2(DEPTH);
  type mem_t is array (0 to DEPTH-1) of std_logic_vector(DATA_W-1 downto 0);
  signal mem: mem_t;
  -- Write-path FSM
  type wstate_t is (W_IDLE, W_DATA, W_RESP);
  signal wstate: wstate_t := W_IDLE;
  signal waddr: unsigned(AW_BITS-1 downto 0); signal wdata_pending: std_logic;
  signal wdata_early: std_logic_vector(DATA_W-1 downto 0);
  signal wstrb_early: std_logic_vector(DATA_W/8-1 downto 0);
  -- Read-path
  signal rvalid_r: std_logic;
begin
  -- Write address ready: accept only when idle
  aw.awready <= '1' when wstate = W_IDLE else '0';
  -- Write data ready: accept in both W_IDLE (W-before-AW) and W_DATA
  w.wready   <= '1' when (wstate = W_IDLE or wstate = W_DATA) else '0';

  process (aclk, aresetn)
    variable i: integer;
  begin
    if aresetn = '0' then
      wstate <= W_IDLE; waddr <= (others => '0');
      wdata_pending <= '0'; b.bvalid <= '0';
    elsif rising_edge(aclk) then
      case wstate is
        when W_IDLE =>
          -- Capture W-before-AW
          if w.wvalid = '1' and w.wready = '1' and wdata_pending = '0' then
            wdata_early <= w.wdata; wstrb_early <= w.wstrb; wdata_pending <= '1'; end if;
          -- AW arrival
          if aw.awvalid = '1' and aw.awready = '1' then
            waddr <= unsigned(aw.awaddr(AW_BITS-1 downto 0));
            if wdata_pending = '1' then
              for i in 0 to DATA_W/8-1 loop
                if wstrb_early(i) = '1' then
                  mem(to_integer(unsigned(aw.awaddr(AW_BITS-1 downto 0))))(8*i+7 downto 8*i)
                    <= wdata_early(8*i+7 downto 8*i); end if; end loop;
              wdata_pending <= '0'; wstate <= W_RESP;
            else
              wstate <= W_DATA; end if; end if;
        when W_DATA =>
          if w.wvalid = '1' and w.wready = '1' then
            for i in 0 to DATA_W/8-1 loop
              if w.wstrb(i) = '1' then
                mem(to_integer(waddr))(8*i+7 downto 8*i) <= w.wdata(8*i+7 downto 8*i);
              end if; end loop;
            wdata_pending <= '0'; wstate <= W_RESP; end if;
        when W_RESP =>
          b.bvalid <= '1';
          if b.bready = '1' then
            b.bvalid <= '0';
            wstate <= W_IDLE; end if;
      end case; end if; end process;

  b.bresp <= "00"; b.buser <= (b.buser'range => '0');

  -- ===================================================================
  -- Read path (single-beat: AR -> R)
  -- ===================================================================
  ar.arready <= '1';
  process (aclk, aresetn) begin
    if aresetn = '0' then rvalid_r <= '0';
    elsif rising_edge(aclk) then
      if ar.arvalid = '1' and ar.arready = '1' then rvalid_r <= '1';
      elsif r.rready = '1' then rvalid_r <= '0'; end if; end if; end process;
  r.rvalid <= rvalid_r; r.rresp <= "00"; r.ruser <= (r.ruser'range => '0');
  r.rdata <= mem(to_integer(unsigned(ar.araddr(AW_BITS-1 downto 0))));
end architecture;
