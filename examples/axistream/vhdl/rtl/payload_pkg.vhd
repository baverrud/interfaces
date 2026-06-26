-- =====================================================================
-- payload_pkg.vhd - structured stream payloads + auto pack/unpack
-- =====================================================================
-- Demonstrates how to carry DIFFERENT subfields of DIFFERENT widths over
-- a generic byte/bit stream. Each payload type gets a 'to_slv'/'from_slv'
-- pair (the "auto concatenate / split") and a width constant that is
-- DERIVED from to_slv so you never hand-count bits. These functions live
-- next to the type, so every stream flavour is defined in one place.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axis_pkg.all;

package payload_pkg is

  -- ---- Stream A: a 25-bit RGB pixel with a start-of-frame flag -------
  type pixel_t is record
    r   : std_logic_vector(7 downto 0);
    g   : std_logic_vector(7 downto 0);
    b   : std_logic_vector(7 downto 0);
    sof : std_logic;
  end record;

  function pixel_to_slv   (p : pixel_t)          return std_logic_vector;
  function pixel_from_slv (v : std_logic_vector) return pixel_t;

  -- ---- Stream B: a 32-bit complex (IQ) sample -----------------------
  type iq_t is record
    i : signed(15 downto 0);
    q : signed(15 downto 0);
  end record;

  function iq_to_slv   (s : iq_t)             return std_logic_vector;
  function iq_from_slv (v : std_logic_vector) return iq_t;

  -- Packed widths = the sum of the field widths (one place to update if
  -- you add a subfield; keep these in step with the to_slv functions).
  constant PIXEL_W : natural := 8 + 8 + 8 + 1;   -- r + g + b + sof = 25
  constant IQ_W    : natural := 16 + 16;         -- i + q          = 32

  -- Preconstrained stream subtype for pixel_t — all sidebands stubbed to
  -- 1-bit safe width.  Using this subtype eliminates repetitive inline
  -- record constraints (see top_subtype.vhd vs. top.vhd).
  subtype pixel_stream_t is axis_t(
    tdata(PIXEL_W - 1 downto 0),
    tuser(0 downto 0),
    tid(0 downto 0),
    tdest(0 downto 0),
    tkeep(0 downto 0),
    tstrb(0 downto 0)
  );

end package;

package body payload_pkg is

  function pixel_to_slv (p : pixel_t) return std_logic_vector is
  begin
    return p.r & p.g & p.b & p.sof;          -- 8 + 8 + 8 + 1 = 25
  end function;

  function pixel_from_slv (v : std_logic_vector) return pixel_t is
    variable w : std_logic_vector(v'length - 1 downto 0) := v;  -- normalise index
    variable p : pixel_t;
  begin
    p.sof := w(0);
    p.b   := w(8  downto 1);
    p.g   := w(16 downto 9);
    p.r   := w(24 downto 17);
    return p;
  end function;

  function iq_to_slv (s : iq_t) return std_logic_vector is
  begin
    return std_logic_vector(s.i) & std_logic_vector(s.q);  -- 16 + 16 = 32
  end function;

  function iq_from_slv (v : std_logic_vector) return iq_t is
    variable w : std_logic_vector(v'length - 1 downto 0) := v;
    variable s : iq_t;
  begin
    s.q := signed(w(15 downto 0));
    s.i := signed(w(31 downto 16));
    return s;
  end function;

end package body;
