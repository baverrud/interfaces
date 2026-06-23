-- =====================================================================
-- i2s_pkg.vhd - I2S audio record + VHDL-2019 mode views
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package i2s_pkg is

    type i2s_t is record
        bclk     : std_logic;
        lrclk    : std_logic;
        tx_data  : std_logic_vector;
        rx_data  : std_logic_vector;
        tx_valid : std_logic;
        rx_valid : std_logic;
    end record;

    view master of i2s_t is
        bclk, lrclk : in;
        tx_data, tx_valid : out;
        rx_data, rx_valid : in;
    end view;

    alias slave is master'converse;

end package;
