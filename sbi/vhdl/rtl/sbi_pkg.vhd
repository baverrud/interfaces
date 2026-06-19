-- =====================================================================
-- sbi_pkg.vhd - UVVM Simple Bus Interface record + VHDL-2019 mode views
-- =====================================================================
-- Matches UVVM's t_sbi_if convention.  Used in testbenches to abstract
-- register read/write operations.  Bridge BFMs convert SBI to AXI4-Lite,
-- Wishbone, APB, or custom register interfaces.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package sbi_pkg is

    type sbi_t is record
        cs    : std_logic;
        addr  : std_logic_vector;
        wr    : std_logic;
        rd    : std_logic;
        wdata : std_logic_vector;
        rdata : std_logic_vector;
        ready : std_logic;
    end record;

    view initiator of sbi_t is
        cs, addr, wr, rd, wdata : out;
        rdata, ready : in;
    end view;

    alias target is initiator'converse;

end package;
