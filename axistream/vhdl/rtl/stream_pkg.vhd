-- =====================================================================
-- stream_pkg.vhd - generic-width AXI-Stream-like interface (VHDL-2019)
-- =====================================================================
-- A single mode-view stream record that works for ANY data width: the
-- 'tdata' element is left unconstrained (VHDL-2008) and is constrained
-- where a signal/port is declared, e.g.
--     signal s : axis_t(tdata(31 downto 0));
--
-- The 'tx' mode view (VHDL-2019) makes the transmitter drive the payload
-- and sample back-pressure; 'rx' is its converse for the receiver.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package stream_pkg is

    type axis_t is record
        tdata  : std_logic_vector;   -- unconstrained: width chosen per signal
        tlast  : std_logic;          -- end-of-packet marker
        tvalid : std_logic;          -- transmitter has data
        tready : std_logic;          -- receiver can accept
    end record;

    -- Transmitter (Tx) drives data + framing, reads back-pressure.
    view tx of axis_t is
        tdata  : out;
        tlast  : out;
        tvalid : out;
        tready : in;
    end view;

    -- Receiver (Rx) is the exact converse of Tx.
    alias rx is tx'converse;

end package;
