-- =====================================================================
-- top_subtype.vhd - same as top.vhd, but uses a preconstrained subtype
-- =====================================================================
-- Demonstrates the `pixel_stream_t` subtype from payload_pkg, which
-- bakes in the tdata width + 1-bit sideband stubs so signal declarations
-- become a single word instead of a six-line constraint block.
-- Compare the architecture bodies of top.vhd and top_subtype.vhd.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.axis_pkg.all;
use work.payload_pkg.all;

entity top_subtype is
  generic (
    FIFO_DEPTH : positive := 16;
    LINE       : positive := 8
  );
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    last_r   : out std_logic_vector(7 downto 0);
    last_g   : out std_logic_vector(7 downto 0);
    last_b   : out std_logic_vector(7 downto 0);
    last_sof : out std_logic;
    beats    : out std_logic_vector(15 downto 0)
  );
end entity;

architecture rtl of top_subtype is
  -- One word per signal — the constraint is baked into the subtype.
  -- Defined once in payload_pkg.vhd, used everywhere:
  signal src  : pixel_stream_t;
  signal sink : pixel_stream_t;
begin

  u_prod : entity work.pixel_producer
    generic map (LINE => LINE)
    port map (clk => clk, rst => rst, m => src);

  u_fifo : entity work.stream_fifo
    generic map (DEPTH => FIFO_DEPTH)
    port map (clk => clk, rst => rst, s => src, m => sink);

  u_cons : entity work.pixel_consumer
    port map (clk => clk, rst => rst, s => sink,
          last_r => last_r, last_g => last_g, last_b => last_b,
          last_sof => last_sof, beats => beats);

end architecture;
