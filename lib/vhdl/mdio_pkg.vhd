-- =====================================================================
-- mdio_pkg.vhd - MDIO record + VHDL-2019 mode views
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package mdio_pkg is

  type mdio_t is record
    mdc  : std_logic;
    mdio : std_logic;   -- bidirectional
  end record;

  view manager of mdio_t is
    mdc  : out;
    mdio : inout;
  end view;

  view phy of mdio_t is
    mdc  : in;
    mdio : inout;
  end view;

end package;
