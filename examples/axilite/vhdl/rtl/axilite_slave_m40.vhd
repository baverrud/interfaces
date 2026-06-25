-- =====================================================================
-- axilite_slave_m40.vhd - AXI4-Lite slave (axilite_m40_t composite)
-- =====================================================================
-- Implements a register-file memory slave responding on the AXI4-Lite
-- bus via a single axilite_m40_t port (40-bit address, 32-bit data).
-- Handles single-beat writes and reads with byte-strobe gating.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axilite_pkg.all;

entity axilite_slave_m40 is
  generic (DEPTH: positive := 256);
  port (aclk, aresetn: in std_logic;
      bus_s: view slave_m40 of axilite_m40_t);
end entity;

architecture rtl of axilite_slave_m40 is
  function clog2(n: positive) return natural is
    variable r: natural := 0; variable m: natural := n - 1;
  begin while m > 0 loop r := r + 1; m := m / 2; end loop; return r; end function;
  constant AW_BITS: natural := clog2(DEPTH);
  type mem_t is array (0 to DEPTH-1) of std_logic_vector(31 downto 0);
  signal mem: mem_t;
  -- Write-path FSM (AXI4 proven pattern, single-beat)
  type wstate_t is (W_IDLE, W_DATA, W_RESP);
  signal wstate: wstate_t := W_IDLE;
  signal waddr: unsigned(AW_BITS-1 downto 0); signal wdata_pending: std_logic;
  signal wdata_early: std_logic_vector(31 downto 0);
  signal wstrb_early: std_logic_vector(3 downto 0);
  -- Read-path
  signal rvalid_r: std_logic;
begin
  bus_s.awready <= '1' when wstate = W_IDLE else '0';
  bus_s.wready  <= '1' when (wstate = W_IDLE or wstate = W_DATA) else '0';

  process (aclk, aresetn)
    variable i: integer;
  begin
    if aresetn = '0' then
      wstate <= W_IDLE; waddr <= (others => '0');
      wdata_pending <= '0'; bus_s.bvalid <= '0';
    elsif rising_edge(aclk) then
      case wstate is
        when W_IDLE =>
          -- W-before-AW
          if bus_s.wvalid = '1' and bus_s.wready = '1' and wdata_pending = '0' then
            wdata_early <= bus_s.wdata; wstrb_early <= bus_s.wstrb; wdata_pending <= '1'; end if;
          -- AW arrival
          if bus_s.awvalid = '1' and bus_s.awready = '1' then
            waddr <= unsigned(bus_s.awaddr(AW_BITS-1 downto 0));
            if wdata_pending = '1' then
              for i in 0 to 3 loop
                if wstrb_early(i) = '1' then
                  mem(to_integer(unsigned(bus_s.awaddr(AW_BITS-1 downto 0))))(8*i+7 downto 8*i)
                    <= wdata_early(8*i+7 downto 8*i); end if; end loop;
              wdata_pending <= '0'; wstate <= W_RESP;
            else
              wstate <= W_DATA; end if; end if;
        when W_DATA =>
          if bus_s.wvalid = '1' and bus_s.wready = '1' then
            for i in 0 to 3 loop
              if bus_s.wstrb(i) = '1' then
                mem(to_integer(waddr))(8*i+7 downto 8*i) <= bus_s.wdata(8*i+7 downto 8*i);
              end if; end loop;
            wdata_pending <= '0'; wstate <= W_RESP; end if;
        when W_RESP =>
          bus_s.bvalid <= '1';
          if bus_s.bready = '1' then
            bus_s.bvalid <= '0';
            wstate <= W_IDLE; end if;
      end case; end if; end process;

  bus_s.bresp <= "00"; bus_s.buser <= '0';

  -- ===================================================================
  -- Read path
  -- ===================================================================
  bus_s.arready <= '1';
  process (aclk, aresetn) begin
    if aresetn = '0' then rvalid_r <= '0';
    elsif rising_edge(aclk) then
      if bus_s.arvalid = '1' and bus_s.arready = '1' then rvalid_r <= '1';
      elsif bus_s.rready = '1' then rvalid_r <= '0'; end if; end if; end process;
  bus_s.rvalid <= rvalid_r; bus_s.rresp <= "00"; bus_s.ruser <= '0';
  bus_s.rdata <= mem(to_integer(unsigned(bus_s.araddr(AW_BITS-1 downto 0))));
end architecture;
