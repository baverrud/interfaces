-- =====================================================================
-- axilite_write_slave.vhd - write-only AXI4-Lite slave
-- =====================================================================
-- Handles AXI4-Lite write transactions only (AW -> W -> B).  Stores
-- incoming data into a register file with byte-strobe gating.
-- AXI4-Lite: single-beat writes, no burst.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axilite_pkg.all;

entity axilite_write_slave is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; USER_W: positive:=1; DEPTH: positive:=256);
  port (aclk, aresetn: in std_logic;
        aw: view slave_aw of axilite_aw_t;
        w:  view slave_w  of axilite_w_t;
        b:  view slave_b  of axilite_b_t);
end entity;

architecture rtl of axilite_write_slave is
  function clog2(n: positive) return natural is
    variable r: natural := 0; variable m: natural := n - 1;
  begin while m > 0 loop r := r + 1; m := m / 2; end loop; return r; end function;
  constant AW_BITS: natural := clog2(DEPTH);
  type mem_t is array (0 to DEPTH-1) of std_logic_vector(DATA_W-1 downto 0);
  signal mem: mem_t;
  type wstate_t is (W_IDLE, W_RESP);
  signal wstate: wstate_t := W_IDLE;
  signal waddr: unsigned(AW_BITS-1 downto 0);
  signal aw_seen, bvalid_r: std_logic;
begin
  aw.awready <= '1' when wstate = W_IDLE and aw_seen = '0' else '0';
  w.wready   <= '1' when wstate = W_IDLE else '0';
  process (aclk, aresetn)
  begin
    if aresetn = '0' then
      wstate <= W_IDLE; waddr <= (others => '0'); aw_seen <= '0'; bvalid_r <= '0';
    elsif rising_edge(aclk) then
      case wstate is
        when W_IDLE =>
          if aw.awvalid = '1' and aw.awready = '1' then
            aw_seen <= '1'; waddr <= unsigned(aw.awaddr(AW_BITS-1 downto 0)); end if;
          if w.wvalid = '1' and w.wready = '1' then
            for i in 0 to DATA_W/8-1 loop
              if w.wstrb(i) = '1' then mem(to_integer(waddr))(8*i+7 downto 8*i)
                <= w.wdata(8*i+7 downto 8*i); end if; end loop;
            if aw_seen = '1' then wstate <= W_RESP; end if; end if;
        when W_RESP =>
          if bvalid_r = '1' and b.bready = '1' then wstate <= W_IDLE; aw_seen <= '0'; end if;
      end case; end if; end process;
  process (aclk, aresetn) begin
    if aresetn = '0' then bvalid_r <= '0';
    elsif rising_edge(aclk) then
      if wstate = W_RESP and bvalid_r = '0' then bvalid_r <= '1';
      elsif b.bready = '1' then bvalid_r <= '0'; end if; end if; end process;
  b.bvalid <= bvalid_r; b.bresp <= "00"; b.buser <= (b.buser'range => '0');
end architecture;
