-- =====================================================================
-- qspi_pkg.vhd - QSPI record + VHDL-2019 mode views
-- =====================================================================
-- QSPI (Quad SPI) interface with configurable data-line width and
-- chip-select count.
--
-- Signal declaration:
--   signal s : qspi_t(
--       io(3 downto 0),            -- quad SPI
--       cs(0 downto 0)             -- single chip-select
--   );
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package qspi_pkg is

    type qspi_t is record
        sclk : std_logic;                      -- clock (master -> slave)
        io_o : std_logic_vector;                -- data out (master -> slave)
        io_i : std_logic_vector;                -- data in  (slave -> master)
        io_oe : std_logic_vector;               -- output enable (1=master drives)
        cs    : std_logic_vector;               -- chip-select (active low)
    end record;

    -- master port: drives sclk, io_o, io_oe, cs; receives io_i
    view master of qspi_t is
        sclk, io_o, io_oe, cs : out;
        io_i : in;
    end view;

    -- slave port: converse of master.
    alias slave is master'converse;

end package;
