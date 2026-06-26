-- =====================================================================
-- top.vhd - CAN demo: controller -> transceiver (VHDL-2019)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.can_pkg.all;

entity top is
  port (
    clk, rstn : in  std_logic;         -- system clock / active-low reset
    done      : out std_logic          -- high when test completes
  );
end entity;

architecture rtl of top is
  signal b : can_t;                    -- CAN interconnect (no unconstrained elements)
begin

  u_mast : entity work.can_master
    port map (clk => clk, rstn => rstn, m => b, done => done);

  u_slav : entity work.can_slave
    port map (clk => clk, rstn => rstn, s => b);

end architecture;
