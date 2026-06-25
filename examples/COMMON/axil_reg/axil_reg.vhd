-- =====================================================================
-- axil_reg.vhd - single-register AXI4-Lite slave (synthesizable)
-- =====================================================================
-- Stores one DATA_W-wide value.  Responds to writes and reads.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.axilite_pkg.all;

entity axil_reg is
  port (
    aclk    : in  std_logic;
    aresetn : in  std_logic;
    s       : view slave of axilite_t
  );
end entity;

architecture rtl of axil_reg is
  signal reg_val : std_logic_vector(s.wdata'range) := (others => '0');
  signal aw_done, bvalid_r, rvalid_r : std_logic := '0';
begin
  s.awready <= not aw_done;
  s.wready  <= aw_done;

  -- Write address handshake
  process (aclk)
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        aw_done <= '0';
      else
        if s.awvalid = '1' and s.awready = '1' then
          aw_done <= '1';
        end if;
        if s.wvalid = '1' and s.wready = '1' and aw_done = '1' then
          aw_done <= '0';
        end if;
      end if;
    end if;
  end process;

  -- Register write
  process (aclk)
  begin
    if rising_edge(aclk) then
      if s.wvalid = '1' and s.wready = '1' then
        for i in s.wstrb'range loop
          if s.wstrb(i) = '1' then
            reg_val((i+1)*8-1 downto i*8) <= s.wdata((i+1)*8-1 downto i*8);
          end if;
        end loop;
      end if;
    end if;
  end process;

  -- Write response
  s.bresp <= (others => '0');
  process (aclk)
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        bvalid_r <= '0';
      elsif s.wvalid = '1' and s.wready = '1' then
        bvalid_r <= '1';
      elsif s.bready = '1' then
        bvalid_r <= '0';
      end if;
    end if;
  end process;
  s.bvalid <= bvalid_r;

  -- Read
  s.arready <= '1';
  s.rdata   <= reg_val;
  s.rresp   <= (others => '0');
  process (aclk)
  begin
    if rising_edge(aclk) then
      if aresetn = '0' then
        rvalid_r <= '0';
      elsif s.arvalid = '1' and s.arready = '1' then
        rvalid_r <= '1';
      elsif s.rready = '1' then
        rvalid_r <= '0';
      end if;
    end if;
  end process;
  s.rvalid <= rvalid_r;

end architecture;
