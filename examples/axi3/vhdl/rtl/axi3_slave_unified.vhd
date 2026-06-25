-- =====================================================================
-- axi3_slave_unified.vhd - full AXI3 slave (unified axi3_t port)
-- =====================================================================
--
-- !!! INTENTIONALLY BROKEN -- kept as a test case for future tool versions. !!!
--
-- Companion to axi3_master_unified.vhd. See that file for details.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axi3_pkg.all;

entity axi3_slave_unified is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; ID_W: positive:=4; DEPTH: positive:=256);
  port (aclk, aresetn: in std_logic;
      s: view slave of axi3_t);
end entity;

architecture rtl of axi3_slave_unified is
  function clog2(n: positive) return natural is
    variable r: natural := 0; variable m: natural := n - 1;
  begin while m > 0 loop r := r + 1; m := m / 2; end loop; return r; end function;
  constant AW_BITS: natural := clog2(DEPTH);
  type mem_t is array (0 to DEPTH-1) of std_logic_vector(DATA_W-1 downto 0);
  signal mem: mem_t;
  type wstate_t is (W_IDLE, W_DATA, W_RESP);
  signal wstate: wstate_t := W_IDLE;
  signal waddr: unsigned(AW_BITS-1 downto 0); signal wcnt: unsigned(7 downto 0);
  signal wid: std_logic_vector(ID_W-1 downto 0);
  signal wdata_early: std_logic_vector(DATA_W-1 downto 0);
  signal wstrb_early: std_logic_vector(DATA_W/8-1 downto 0);
  signal wdata_pending, bvalid_r: std_logic;
  type rstate_t is (R_IDLE, R_DATA);
  signal rstate: rstate_t := R_IDLE; signal raddr: unsigned(AW_BITS-1 downto 0);
  signal rcnt: unsigned(7 downto 0); signal rid_latched: std_logic_vector(ID_W-1 downto 0);
  signal rlast_r, rvalid_r: std_logic;
begin
  s.awready <= '1' when wstate = W_IDLE else '0';
  s.wready  <= '1' when (wstate = W_IDLE or wstate = W_DATA) else '0';
  process (aclk, aresetn)
    variable wstrb_vec: std_logic_vector(DATA_W/8-1 downto 0);
  begin
    if aresetn = '0' then wstate <= W_IDLE; wdata_pending <= '0';
      waddr <= (others => '0'); wcnt <= (others => '0'); bvalid_r <= '0';
    elsif rising_edge(aclk) then
      case wstate is
        when W_IDLE =>
          if s.wvalid = '1' and s.wready = '1' and wdata_pending = '0' then
            wdata_early <= s.wdata; wstrb_early <= s.wstrb; wdata_pending <= '1'; end if;
          if s.awvalid = '1' and s.awready = '1' then
            wid <= s.awid; wcnt <= unsigned(s.awlen); waddr <= unsigned(s.awaddr(AW_BITS-1 downto 0));
            if wdata_pending = '1' then
              for i in 0 to DATA_W/8-1 loop
                if wstrb_early(i) = '1' then
                  mem(to_integer(unsigned(s.awaddr(AW_BITS-1 downto 0))))(8*i+7 downto 8*i)
                    <= wdata_early(8*i+7 downto 8*i); end if; end loop;
              waddr <= unsigned(s.awaddr(AW_BITS-1 downto 0)) + 1; wdata_pending <= '0'; end if;
            wstate <= W_RESP when unsigned(s.awlen) = 0 else W_DATA; end if;
        when W_DATA =>
          if s.wvalid = '1' and s.wready = '1' then
            for i in 0 to DATA_W/8-1 loop
              if s.wstrb(i) = '1' then mem(to_integer(waddr))(8*i+7 downto 8*i) <= s.wdata(8*i+7 downto 8*i); end if;
            end loop; waddr <= waddr + 1; if s.wlast = '1' then wstate <= W_RESP; end if; end if;
        when W_RESP => if bvalid_r = '1' and s.bready = '1' then wstate <= W_IDLE; end if;
      end case; end if; end process;
  process (aclk, aresetn) begin
    if aresetn = '0' then bvalid_r <= '0';
    elsif rising_edge(aclk) then
      if wstate = W_RESP and bvalid_r = '0' then bvalid_r <= '1';
      elsif s.bready = '1' then bvalid_r <= '0'; end if; end if; end process;
  s.bvalid <= bvalid_r; s.bid <= wid; s.bresp <= "00"; s.buser <= (s.buser'range => '0');
  s.arready <= '1' when rstate = R_IDLE else '0';
  process (aclk, aresetn) begin
    if aresetn = '0' then rstate <= R_IDLE; raddr <= (others => '0'); rcnt <= (others => '0');
    elsif rising_edge(aclk) then
      case rstate is
        when R_IDLE => if s.arvalid = '1' and s.arready = '1' then
            raddr <= unsigned(s.araddr(AW_BITS-1 downto 0)); rid_latched <= s.arid;
            rcnt <= unsigned(s.arlen); rstate <= R_DATA; end if;
        when R_DATA => if rvalid_r = '1' and s.rready = '1' then raddr <= raddr + 1; if rcnt > 0 then rcnt <= rcnt - 1; end if; end if;
          if rvalid_r = '1' and s.rready = '1' and rlast_r = '1' then rstate <= R_IDLE; end if;
      end case; end if; end process;
  rlast_r <= '1' when rcnt = 0 else '0';
  s.rdata <= mem(to_integer(raddr)); s.rid <= rid_latched; s.rresp <= "00"; s.ruser <= (s.ruser'range => '0');
  process (aclk, aresetn) begin
    if aresetn = '0' then rvalid_r <= '0';
    elsif rising_edge(aclk) then
      if rstate = R_DATA and rvalid_r = '0' then rvalid_r <= '1';
      elsif s.rready = '1' and rlast_r = '1' then rvalid_r <= '0'; end if; end if; end process;
  s.rvalid <= rvalid_r; s.rlast <= rlast_r;
end architecture;
