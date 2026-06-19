-- =====================================================================
-- apb_pkg.vhd - AMBA APB4 record + VHDL-2019 mode views
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package apb_pkg is

    type apb_t is record
        paddr   : std_logic_vector;
        pwdata  : std_logic_vector;
        prdata  : std_logic_vector;
        pwrite  : std_logic;
        psel    : std_logic;
        penable : std_logic;
        pready  : std_logic;
        pslverr : std_logic;
        pprot   : std_logic_vector(2 downto 0);
        pstrb   : std_logic_vector;
    end record;

    view master of apb_t is
        paddr, pwdata, pwrite, psel, penable, pprot, pstrb : out;
        prdata, pready, pslverr : in;
    end view;

    alias slave is master'converse;

end package;
