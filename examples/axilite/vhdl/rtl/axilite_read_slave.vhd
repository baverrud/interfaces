-- =====================================================================
-- axilite_read_slave.vhd - read-only AXI4-Lite slave
-- =====================================================================
-- Handles AXI4-Lite read transactions only (AR -> R).  Returns the
-- addressed word from a pre-loaded register file.
-- AXI4-Lite: single-beat reads, no burst.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axilite_pkg.all;

entity axilite_read_slave is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; USER_W: positive:=1;
           DEPTH: positive:=256; INIT_DATA: std_logic_vector := x"C0C0C0C0");
  port (aclk, aresetn: in std_logic;
        ar: view slave_ar of axilite_ar_t;
        r:  view slave_r  of axilite_r_t);
end entity;

architecture rtl of axilite_read_slave is
  function clog2(n: positive) return natural is
    variable r: natural := 0; variable m: natural := n - 1;
  begin while m > 0 loop r := r + 1; m := m / 2; end loop; return r; end function;
  constant AW_BITS: natural := clog2(DEPTH);
  type mem_t is array (0 to DEPTH-1) of std_logic_vector(DATA_W-1 downto 0);
  signal mem: mem_t;
  signal rvalid_r: std_logic;
begin
  -- Pre-initialize memory with pattern during reset
  process (aclk, aresetn)
  begin
    if aresetn = '0' then
      for i in 0 to DEPTH-1 loop
        mem(i) <= INIT_DATA(DATA_W-1 downto 0);
      end loop;
    end if;
  end process;

  ar.arready <= '1';
  process (aclk, aresetn) begin
    if aresetn = '0' then rvalid_r <= '0';
    elsif rising_edge(aclk) then
      if ar.arvalid = '1' and ar.arready = '1' then rvalid_r <= '1';
      elsif r.rready = '1' then rvalid_r <= '0'; end if; end if; end process;
  r.rvalid <= rvalid_r; r.rdata <= mem(to_integer(unsigned(ar.araddr(AW_BITS-1 downto 0))));
  r.rresp <= "00"; r.ruser <= (r.ruser'range => '0');
end architecture;
