-- =====================================================================
-- top.vhd - synthesizable top: producer -> stream_fifo -> consumer
-- =====================================================================
-- Wires the packed-pixel pipeline together.  Signal constraints for
-- all sideband elements are provided — TLAST enabled, all others absent
-- (null ranges).  Clock/reset remain as top-level ports.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.axis_pkg.all;
use work.payload_pkg.all;

entity top is
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

architecture rtl of top is
  signal src  : axis_t(
    tdata(PIXEL_W - 1 downto 0),
    tuser(0 downto 0),
    tid(0 downto 0),
    tdest(0 downto 0),
    tkeep(0 downto 0),
    tstrb(0 downto 0)
  );
  signal sink : axis_t(
    tdata(PIXEL_W - 1 downto 0),
    tuser(0 downto 0),
    tid(0 downto 0),
    tdest(0 downto 0),
    tkeep(0 downto 0),
    tstrb(0 downto 0)
  );
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
