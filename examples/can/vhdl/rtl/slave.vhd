-- =====================================================================
-- can_slave.vhd - CAN transceiver loopback (VHDL-2019)
-- =====================================================================
-- A real CAN transceiver buffers TX to the differential bus and
-- reflects the bus state back on RX.  This model implements that
-- loopback with one clock cycle of propagation delay.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.can_pkg.all;

entity can_slave is
  port (
    clk, rstn : in  std_logic;            -- system clock / active-low reset
    s         : view transceiver of can_t; -- transceiver view (tx=input, rx=output)
    done      : out std_logic             -- unused
  );
end entity;

architecture rtl of can_slave is
begin

  done <= '0';

  -- Transceiver: TX → bus → RX with one clock propagation delay
  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        s.rx <= '1';                      -- default recessive
      else
        s.rx <= s.tx;                     -- TX echoed to RX
      end if;
    end if;
  end process;

end architecture;
