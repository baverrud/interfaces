-- =====================================================================
-- spi_pkg.vhd - SPI / QSPI record + VHDL-2019 mode views
-- =====================================================================
-- cs and io_* are unconstrained vectors — width chosen per signal.
--   cs(0 downto 0)      = 1 chip select
--   io_o(0 downto 0)    = classic SPI (single MOSI)
--   io_o(3 downto 0)    = QSPI (quad IO)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package spi_pkg is

    type spi_t is record
        sclk  : std_logic;
        io_o  : std_logic_vector;   -- master -> slave data
        io_i  : std_logic_vector;   -- slave -> master data
        io_oe : std_logic_vector;   -- output enable per IO line
        cs    : std_logic_vector;   -- chip-select
    end record;

    view master of spi_t is
        sclk, io_o, io_oe, cs : out;
        io_i : in;
    end view;

    alias slave is master'converse;

end package;
