-- =====================================================================
-- axi4_slave_hp.vhd - AXI4 HP slave (fully constrained axi4_hp_t)
-- =====================================================================
-- Handles both write and read transactions over the AXI4 HP port
-- (axi4_hp_t — 128-bit data, 49-bit address, 6-bit ID).  Uses a
-- register-file memory with separate write and read FSM paths.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axi4_pkg.all;

entity axi4_slave_hp is
  generic (DEPTH: positive := 256);
  port (aclk, aresetn: in std_logic;
      bus_s: view slave_hp of axi4_hp_t);
end entity;

architecture rtl of axi4_slave_hp is
  constant AW_BITS: natural := 8;  -- 256 entries (8-bit address)
  -- Register-file storage (128-bit wide for HP bus)
  type mem_t is array (0 to DEPTH-1) of std_logic_vector(127 downto 0);
  signal mem: mem_t;
  -- Write-path FSM
  type wstate_t is (W_IDLE, W_DATA, W_RESP);
  signal wstate: wstate_t := W_IDLE;
  signal waddr: unsigned(AW_BITS-1 downto 0);
  signal wcnt: unsigned(7 downto 0);
  signal wid: std_logic_vector(5 downto 0);
  signal bvalid_r: std_logic;
  -- Read-path FSM
  type rstate_t is (R_IDLE, R_DATA);
  signal rstate: rstate_t := R_IDLE;
  signal raddr: unsigned(AW_BITS-1 downto 0);
  signal rcnt: unsigned(7 downto 0);
  signal rid_latched: std_logic_vector(5 downto 0);
  signal rlast_r, rvalid_r: std_logic;
begin
  -- ===================================================================
  -- Write path
  -- ===================================================================
  bus_s.awready <= '1' when wstate = W_IDLE else '0';
  bus_s.wready  <= '1' when (wstate = W_IDLE or wstate = W_DATA) else '0';

  -- Write FSM: latch AW, store W beats, assert B response
  process (aclk, aresetn)
  begin
    if aresetn = '0' then
      wstate <= W_IDLE; waddr <= (others => '0');
      wcnt <= (others => '0'); bvalid_r <= '0';
    elsif rising_edge(aclk) then
      case wstate is
        when W_IDLE =>
          if bus_s.awvalid = '1' and bus_s.awready = '1' then
            wid <= bus_s.awid;
            wcnt <= unsigned(bus_s.awlen);
            waddr <= unsigned(bus_s.awaddr(AW_BITS-1 downto 0));
            wstate <= W_RESP when unsigned(bus_s.awlen) = 0 else W_DATA; end if;
        when W_DATA =>
          if bus_s.wvalid = '1' and bus_s.wready = '1' then
            mem(to_integer(waddr)) <= bus_s.wdata;
            waddr <= waddr + 1;
            if bus_s.wlast = '1' then wstate <= W_RESP; end if; end if;
        when W_RESP =>
          if bvalid_r = '1' and bus_s.bready = '1' then wstate <= W_IDLE; end if;
      end case; end if; end process;

  -- B valid generation
  process (aclk, aresetn) begin
    if aresetn = '0' then bvalid_r <= '0';
    elsif rising_edge(aclk) then
      if wstate = W_RESP and bvalid_r = '0' then bvalid_r <= '1';
      elsif bus_s.bready = '1' then bvalid_r <= '0'; end if; end if; end process;
  bus_s.bvalid <= bvalid_r;
  bus_s.bid <= wid;
  bus_s.bresp <= "00";

  -- ===================================================================
  -- Read path
  -- ===================================================================
  bus_s.arready <= '1' when rstate = R_IDLE else '0';

  -- Read FSM: latch AR request, stream data from memory
  process (aclk, aresetn) begin
    if aresetn = '0' then rstate <= R_IDLE; raddr <= (others => '0');
      rcnt <= (others => '0');
    elsif rising_edge(aclk) then
      case rstate is
        when R_IDLE =>
          if bus_s.arvalid = '1' and bus_s.arready = '1' then
            raddr <= unsigned(bus_s.araddr(AW_BITS-1 downto 0));
            rid_latched <= bus_s.arid;
            rcnt <= unsigned(bus_s.arlen);
            rstate <= R_DATA; end if;
        when R_DATA =>
          if rvalid_r = '1' and bus_s.rready = '1' then
            raddr <= raddr + 1;
            if rcnt > 0 then rcnt <= rcnt - 1; end if; end if;
          if rvalid_r = '1' and bus_s.rready = '1' and rlast_r = '1' then
            rstate <= R_IDLE; end if;
      end case; end if; end process;

  rlast_r <= '1' when rcnt = 0 else '0';
  bus_s.rdata <= mem(to_integer(raddr));
  bus_s.rid <= rid_latched;
  bus_s.rresp <= "00";

  -- R valid: asserted during R_DATA, cleared after last beat accepted
  process (aclk, aresetn) begin
    if aresetn = '0' then rvalid_r <= '0';
    elsif rising_edge(aclk) then
      if rstate = R_DATA and rvalid_r = '0' then rvalid_r <= '1';
      elsif bus_s.rready = '1' and rlast_r = '1' then rvalid_r <= '0'; end if; end if; end process;
  bus_s.rvalid <= rvalid_r;
  bus_s.rlast <= rlast_r;
end architecture;
