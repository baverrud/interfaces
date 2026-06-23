-- =====================================================================
-- axilite_pkg.vhd - AXI4-Lite record + VHDL-2019 mode views
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package axilite_pkg is

    type axilite_t is record
        -- Write Address
        awaddr   : std_logic_vector;
        awprot   : std_logic_vector(2 downto 0);
        awuser   : std_logic_vector;
        awvalid  : std_logic;
        awready  : std_logic;

        -- Write Data
        wdata    : std_logic_vector;
        wstrb    : std_logic_vector;
        wuser    : std_logic_vector;
        wvalid   : std_logic;
        wready   : std_logic;

        -- Write Response
        bresp    : std_logic_vector(1 downto 0);
        buser    : std_logic_vector;
        bvalid   : std_logic;
        bready   : std_logic;

        -- Read Address
        araddr   : std_logic_vector;
        arprot   : std_logic_vector(2 downto 0);
        aruser   : std_logic_vector;
        arvalid  : std_logic;
        arready  : std_logic;

        -- Read Data
        rdata    : std_logic_vector;
        rresp    : std_logic_vector(1 downto 0);
        ruser    : std_logic_vector;
        rvalid   : std_logic;
        rready   : std_logic;
    end record;

    view master of axilite_t is
        awaddr, awprot, awuser, awvalid : out;  awready : in;
        wdata, wstrb, wuser, wvalid : out;      wready  : in;
        bresp, buser, bvalid : in;              bready  : out;
        araddr, arprot, aruser, arvalid : out;  arready : in;
        rdata, rresp, ruser, rvalid : in;       rready  : out;
    end view;

    alias slave is master'converse;

end package;
