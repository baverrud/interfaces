-- =====================================================================
-- spi_pkg.vhd - Classic SPI record + VHDL-2019 mode views
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package spi_pkg is

  type spi_t is record
    sclk : std_logic;
    mosi : std_logic;
    miso : std_logic;
    cs   : std_logic_vector;   -- unconstrained: width per signal
  end record;

  view master of spi_t is
    sclk, mosi, cs : out;
    miso : in;
  end view;

  alias slave is master'converse;

end package;
