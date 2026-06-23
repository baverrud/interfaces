-- =====================================================================
-- can_pkg.vhd - CAN bus record + VHDL-2019 mode views
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package can_pkg is

    type can_t is record
        tx : std_logic;
        rx : std_logic;
    end record;

    view controller of can_t is
        tx : out;
        rx : in;
    end view;

    alias transceiver is controller'converse;

end package;
