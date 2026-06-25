-- =====================================================================
-- axi3_slave.vhd - full AXI3 slave (per-channel ports)
-- =====================================================================
-- Register-file memory slave handling both write and read burst
-- transactions.  AXI3-specific: wid on write data channel, 2-bit lock.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axi3_pkg.all;

entity axi3_slave is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; ID_W: positive:=4; DEPTH: positive:=256);
  port (aclk, aresetn: in std_logic;
      aw: view slave_aw of axi3_aw_t; w: view slave_w of axi3_w_t; b: view slave_b of axi3_b_t;
      ar: view slave_ar of axi3_ar_t; r: view slave_r of axi3_r_t);
end entity;

architecture rtl of axi3_slave is
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
  aw.awready <= '1' when wstate = W_IDLE else '0';
  w.wready   <= '1' when (wstate = W_IDLE or wstate = W_DATA) else '0';
  process (aclk, aresetn)
    variable wstrb_vec: std_logic_vector(DATA_W/8-1 downto 0);
  begin
    if aresetn = '0' then wstate <= W_IDLE; wdata_pending <= '0';
      waddr <= (others => '0'); wcnt <= (others => '0'); bvalid_r <= '0';
    elsif rising_edge(aclk) then
      case wstate is
        when W_IDLE =>
          if w.wvalid = '1' and w.wready = '1' and wdata_pending = '0' then
            wdata_early <= w.wdata; wstrb_early <= w.wstrb; wdata_pending <= '1'; end if;
          if aw.awvalid = '1' and aw.awready = '1' then
            wid <= aw.awid; wcnt <= unsigned(aw.awlen); waddr <= unsigned(aw.awaddr(AW_BITS-1 downto 0));
            if wdata_pending = '1' then
              for i in 0 to DATA_W/8-1 loop
                if wstrb_early(i) = '1' then
                  mem(to_integer(unsigned(aw.awaddr(AW_BITS-1 downto 0))))(8*i+7 downto 8*i)
                    <= wdata_early(8*i+7 downto 8*i); end if; end loop;
              waddr <= unsigned(aw.awaddr(AW_BITS-1 downto 0)) + 1; wdata_pending <= '0'; end if;
            wstate <= W_RESP when unsigned(aw.awlen) = 0 else W_DATA; end if;
        when W_DATA =>
          if w.wvalid = '1' and w.wready = '1' then
            for i in 0 to DATA_W/8-1 loop
              if w.wstrb(i) = '1' then mem(to_integer(waddr))(8*i+7 downto 8*i) <= w.wdata(8*i+7 downto 8*i); end if;
            end loop; waddr <= waddr + 1; if w.wlast = '1' then wstate <= W_RESP; end if; end if;
        when W_RESP => if bvalid_r = '1' and b.bready = '1' then wstate <= W_IDLE; end if;
      end case; end if; end process;
  process (aclk, aresetn) begin
    if aresetn = '0' then bvalid_r <= '0';
    elsif rising_edge(aclk) then
      if wstate = W_RESP and bvalid_r = '0' then bvalid_r <= '1';
      elsif b.bready = '1' then bvalid_r <= '0'; end if; end if; end process;
  b.bvalid <= bvalid_r; b.bid <= wid; b.bresp <= "00"; b.buser <= (b.buser'range => '0');
  ar.arready <= '1' when rstate = R_IDLE else '0';
  process (aclk, aresetn) begin
    if aresetn = '0' then rstate <= R_IDLE; raddr <= (others => '0'); rcnt <= (others => '0');
    elsif rising_edge(aclk) then
      case rstate is
        when R_IDLE => if ar.arvalid = '1' and ar.arready = '1' then
            raddr <= unsigned(ar.araddr(AW_BITS-1 downto 0)); rid_latched <= ar.arid;
            rcnt <= unsigned(ar.arlen); rstate <= R_DATA; end if;
        when R_DATA => if rvalid_r = '1' and r.rready = '1' then raddr <= raddr + 1; if rcnt > 0 then rcnt <= rcnt - 1; end if; end if;
          if rvalid_r = '1' and r.rready = '1' and rlast_r = '1' then rstate <= R_IDLE; end if;
      end case; end if; end process;
  rlast_r <= '1' when rcnt = 0 else '0';
  r.rdata <= mem(to_integer(raddr)); r.rid <= rid_latched; r.rresp <= "00"; r.ruser <= (r.ruser'range => '0');
  process (aclk, aresetn) begin
    if aresetn = '0' then rvalid_r <= '0';
    elsif rising_edge(aclk) then
      if rstate = R_DATA and rvalid_r = '0' then rvalid_r <= '1';
      elsif r.rready = '1' and rlast_r = '1' then rvalid_r <= '0'; end if; end if; end process;
  r.rvalid <= rvalid_r; r.rlast <= rlast_r;
end architecture;
