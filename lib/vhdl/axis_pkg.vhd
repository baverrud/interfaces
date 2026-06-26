-- =====================================================================
-- axis_pkg.vhd - AXI-Stream record + VHDL-2019 mode views
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

package axis_pkg is

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

  -- ===================================================================
  -- Option A: Fully constrained 32-bit record (no per-signal constraints)
  -- ===================================================================
  -- All vector widths are fixed in the type — signal declarations need
  -- NO record constraint syntax.  Trade-off: one type per width combo.
  -- ===================================================================
  type axis_32b_t is record
    tdata  : std_logic_vector(31 downto 0);  -- 32-bit payload
    tlast  : std_logic;                       -- end-of-packet
    tuser  : std_logic_vector(0 downto 0);   -- 1-bit stub
    tid    : std_logic_vector(0 downto 0);
    tdest  : std_logic_vector(0 downto 0);
    tkeep  : std_logic_vector(0 downto 0);
    tstrb  : std_logic_vector(0 downto 0);
    tvalid : std_logic;
    tready : std_logic;
  end record;

  view master_32b of axis_32b_t is
    tdata, tlast, tuser, tid, tdest, tkeep, tstrb, tvalid : out;
    tready : in;
  end view;
  alias slave_32b is master_32b'converse;

  -- ===================================================================
  -- Option B: Array of streams (N independent channels in one bundle)
  -- ===================================================================
  type axis_array_t is array (natural range <>) of axis_t;

end package;
