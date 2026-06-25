-- =====================================================================
-- stream_pkg.vhd - AXI-Stream record + VHDL-2019 mode views
-- =====================================================================
-- All sideband signals (except tlast) are unconstrained std_logic_vector.
-- 1-bit safe-width stubs when unused — NEVER null ranges (crash Vivado GUI).
-- aclk/aresetn are NOT in the record — they remain as separate ports
-- in VHDL (unlike the SV version which puts them in the interface).
--
-- Signal declaration:
--   signal s : axis_t(
--       tdata(31 downto 0),
--       tuser(0 downto 0),       -- 1-bit stub
--       ...
--   );
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package stream_pkg is

  type axis_t is record
    tdata  : std_logic_vector;   -- payload
    tlast  : std_logic;          -- end-of-packet (always 1 bit)
    tuser  : std_logic_vector;   -- 1-bit stub when unused
    tid    : std_logic_vector;
    tdest  : std_logic_vector;
    tkeep  : std_logic_vector;
    tstrb  : std_logic_vector;
    tvalid : std_logic;
    tready : std_logic;
  end record;

  -- master (Tx): drives payload + framing, samples back-pressure.
  view master of axis_t is
    tdata  : out;
    tlast  : out;
    tuser  : out;
    tid    : out;
    tdest  : out;
    tkeep  : out;
    tstrb  : out;
    tvalid : out;
    tready : in;
  end view;

  -- slave (Rx): converse of master.
  alias slave is master'converse;

end package;
