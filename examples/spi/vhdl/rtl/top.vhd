-- =====================================================================
-- top.vhd - SPI demo: register write, then read back (VHDL-2019)
-- =====================================================================
-- Clean top level: instantiates SPI interface, master (register
-- write/read sequencer), and slave (shadow register).
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.spi_pkg.all;

entity top is
  generic (
    WR_DATA : std_logic_vector(7 downto 0) := x"A5"  -- test data
  );
  port (
    clk, rstn : in  std_logic;       -- system clock / active-low reset
    done      : out std_logic        -- high when test passes
  );
end entity;

architecture rtl of top is
  -- SPI interconnect: cs is 1-bit wide (CS_COUNT = 1)
  signal b : spi_t(cs(0 downto 0));
begin

  -- master: writes WR_DATA, reads it back, verifies
  u_mast : entity work.spi_master
    generic map (WR_DATA => WR_DATA)
    port map (
      clk  => clk,
      rstn => rstn,
      m    => b,
      done => done
    );

  -- slave: shadow register (captures MOSI, echoes on MISO)
  u_slav : entity work.spi_slave
    port map (
      clk  => clk,
      rstn => rstn,
      s    => b
    );

end architecture;    -- of top
