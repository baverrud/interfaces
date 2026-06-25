-- =====================================================================
-- wishbone_pkg.vhd - Wishbone B4 record + VHDL-2019 mode views
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package wishbone_pkg is

  type wishbone_t is record
    adr   : std_logic_vector;
    dat_o : std_logic_vector;
    dat_i : std_logic_vector;
    we    : std_logic;
    sel   : std_logic_vector;
    stb   : std_logic;
    ack   : std_logic;
    cyc   : std_logic;
    err   : std_logic;
  end record;

  view master of wishbone_t is
    adr, dat_o, we, sel, stb, cyc : out;
    dat_i, ack, err : in;
  end view;

  alias slave is master'converse;

end package;
