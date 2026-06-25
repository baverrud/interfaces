-- =====================================================================
-- uart_pkg.vhd - UART record + VHDL-2019 mode views
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package uart_pkg is

  type uart_t is record
    tx  : std_logic;
    rx  : std_logic;
    rts : std_logic;
    cts : std_logic;
  end record;

  view master of uart_t is
    tx, rts : out;
    rx, cts : in;
  end view;

  alias slave is master'converse;

end package;
