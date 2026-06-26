-- =====================================================================
-- top_array.vhd - N parallel pixel lanes via axis_array_t
-- =====================================================================
-- Demonstrates `axis_array_t` — an array of axis_t signals carrying
-- multiple independent streams in one bundle.  A `for ... generate`
-- loop instantiates identical producer → FIFO → consumer lanes.
--
-- Each array element IS an axis_t, so existing entities with
-- `view master/slave of axis_t` ports connect directly — no wrappers.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axis_pkg.all;
use work.payload_pkg.all;

entity top_array is
  generic (
    N_LANES    : positive := 2;    -- number of parallel streams
    FIFO_DEPTH : positive := 16;
    LINE       : positive := 8
  );
  port (
    clk   : in  std_logic;
    rst   : in  std_logic;
    beats : out std_logic_vector(15 downto 0);
    done  : out std_logic
  );
end entity;

architecture rtl of top_array is
  -- Array of stream signals — one constraint block sizes all lanes
  signal src  : axis_array_t(0 to N_LANES - 1)(
    tdata(PIXEL_W - 1 downto 0),
    tuser(0 downto 0),
    tid(0 downto 0),
    tdest(0 downto 0),
    tkeep(0 downto 0),
    tstrb(0 downto 0)
  );
  signal sink : axis_array_t(0 to N_LANES - 1)(
    tdata(PIXEL_W - 1 downto 0),
    tuser(0 downto 0),
    tid(0 downto 0),
    tdest(0 downto 0),
    tkeep(0 downto 0),
    tstrb(0 downto 0)
  );

  -- Per-lane beat count (std_logic_vector so pixel_consumer.out port connects directly)
  type beats_array is array (0 to N_LANES - 1) of std_logic_vector(15 downto 0);
  signal lane_beats : beats_array := (others => (others => '0'));
  signal total_beats : unsigned(15 downto 0) := (others => '0');
  signal all_done : std_logic := '0';
begin

  -- Instantiate one pixel pipeline per lane
  gen_lanes : for i in 0 to N_LANES - 1 generate
    u_prod : entity work.pixel_producer
      generic map (LINE => LINE)
      port map (clk => clk, rst => rst, m => src(i));

    u_fifo : entity work.stream_fifo
      generic map (DEPTH => FIFO_DEPTH)
      port map (clk => clk, rst => rst, s => src(i), m => sink(i));

    u_cons : entity work.pixel_consumer
      port map (
        clk      => clk,
        rst      => rst,
        s        => sink(i),
        last_r   => open,
        last_g   => open,
        last_b   => open,
        last_sof => open,
        beats    => lane_beats(i)
      );
  end generate;

  -- Aggregate: sum all lane beat counts, assert done when all lanes finish
  process (clk)
    variable sum : unsigned(15 downto 0);
  begin
    if rising_edge(clk) then
      if rst = '1' then
        total_beats <= (others => '0');
        all_done    <= '0';
      else
        sum := (others => '0');
        for i in 0 to N_LANES - 1 loop
          sum := sum + unsigned(lane_beats(i));
        end loop;
        total_beats <= sum;

        -- All lanes must have produced at least LINE beats
        if unsigned(total_beats) >= N_LANES * LINE then
          all_done <= '1';
        end if;
      end if;
    end if;
  end process;

  beats <= std_logic_vector(total_beats);
  done  <= all_done;

end architecture;
