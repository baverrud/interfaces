-- =====================================================================
-- jtag_pkg.vhd - JTAG record + VHDL-2019 mode views
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package jtag_pkg is

  type jtag_t is record
    tck  : std_logic;
    tms  : std_logic;
    tdi  : std_logic;
    tdo  : std_logic;
    trst : std_logic;
  end record;

  view tap of jtag_t is
    tck, tms, tdi, trst : in;
    tdo : out;
  end view;

end package;
