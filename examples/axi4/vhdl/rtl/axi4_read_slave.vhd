-- =====================================================================
-- axi4_read_slave.vhd - read-only AXI4 slave (per-channel, C0 pattern)
-- =====================================================================
-- Handles AXI4 read transactions only (no write path).  Memory is
-- pre-initialized with an incrementing pattern (0xC0+addr) so read
-- data is always deterministic without a preceding write.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axi4_pkg.all;

entity axi4_read_slave is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; ID_W: positive:=4; DEPTH: positive:=256);
  port (aclk, aresetn: in std_logic;
      -- Read sub-channels: address + data
      ar: view slave_ar of axi4_ar_t; r: view slave_r of axi4_r_t);
end entity;

architecture rtl of axi4_read_slave is
  -- Ceiling-log2 for address width from depth
  function clog2(n: positive) return natural is
    variable r: natural := 0; variable m: natural := n - 1;
  begin while m > 0 loop r := r + 1; m := m / 2; end loop; return r; end function;
  -- Memory initialization: each word = {8'hC0+addr, 24'(addr+1)}
  function init_pattern(i: integer) return std_logic_vector is
  begin return std_logic_vector(to_unsigned(16#C0# + i, 8)) & std_logic_vector(to_unsigned(i + 1, 24)); end function;
  constant AW_BITS: natural := clog2(DEPTH);
  type mem_t is array (0 to DEPTH-1) of std_logic_vector(DATA_W-1 downto 0);
  function init_mem return mem_t is variable m: mem_t;
  begin for i in 0 to DEPTH-1 loop m(i) := init_pattern(i); end loop; return m; end function;
  -- Pre-initialized read-only memory
  signal mem: mem_t := init_mem;
  -- Read-path FSM
  type rstate_t is (R_IDLE, R_DATA);
  signal rstate: rstate_t := R_IDLE; signal raddr: unsigned(AW_BITS-1 downto 0);
  signal rcnt: unsigned(7 downto 0); signal rid_latched: std_logic_vector(ID_W-1 downto 0);
  signal rlast_r, rvalid_r: std_logic;
begin
  -- ===================================================================
  -- Read path
  -- ===================================================================
  ar.arready <= '1' when rstate = R_IDLE else '0';
  -- Read FSM: latch AR request, stream pre-initialized data from memory
  process (aclk, aresetn) begin
    if aresetn = '0' then rstate <= R_IDLE; raddr <= (others => '0'); rcnt <= (others => '0');
    elsif rising_edge(aclk) then
      case rstate is
        -- R_IDLE: accept AR, latch address + burst length + ID
        when R_IDLE => if ar.arvalid = '1' and ar.arready = '1' then
            raddr <= unsigned(ar.araddr(AW_BITS-1 downto 0)); rid_latched <= ar.arid;
            rcnt <= unsigned(ar.arlen); rstate <= R_DATA; end if;
        -- R_DATA: output memory data, advance address per accepted beat
        when R_DATA => if rvalid_r = '1' and r.rready = '1' then raddr <= raddr + 1; if rcnt > 0 then rcnt <= rcnt - 1; end if; end if;
          if rvalid_r = '1' and r.rready = '1' and rlast_r = '1' then rstate <= R_IDLE; end if;
      end case; end if; end process;
  rlast_r <= '1' when rcnt = 0 else '0';
  r.rdata <= mem(to_integer(raddr)); r.rid <= rid_latched; r.rresp <= "00"; r.ruser <= (r.ruser'range => '0');
  -- R valid: asserted during R_DATA, cleared after last beat accepted
  process (aclk, aresetn) begin
    if aresetn = '0' then rvalid_r <= '0';
    elsif rising_edge(aclk) then
      if rstate = R_DATA and rvalid_r = '0' then rvalid_r <= '1';
      elsif r.rready = '1' and rlast_r = '1' then rvalid_r <= '0'; end if; end if; end process;
  r.rvalid <= rvalid_r; r.rlast <= rlast_r;
end architecture;
