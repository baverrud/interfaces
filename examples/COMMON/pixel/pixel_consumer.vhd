-- =====================================================================
-- pixel_consumer.vhd - receives a stream, unpacks pixels
-- =====================================================================
-- Clock/reset are separate ports (not in the interface record).
-- Beat acceptance gated on tvalid AND tready (was tvalid-only).
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.stream_pkg.all;
use work.payload_pkg.all;

entity pixel_consumer is
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    s        : view slave of axis_t;
    last_r   : out std_logic_vector(7 downto 0);
    last_g   : out std_logic_vector(7 downto 0);
    last_b   : out std_logic_vector(7 downto 0);
    last_sof : out std_logic;
    beats    : out std_logic_vector(15 downto 0)
  );
end entity;

architecture rtl of pixel_consumer is
  signal px    : pixel_t;
  signal nbeat : unsigned(15 downto 0) := (others => '0');
begin

  s.tready <= '1';
  px       <= pixel_from_slv(s.tdata);

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        nbeat    <= (others => '0');
        last_r   <= (others => '0');
        last_g   <= (others => '0');
        last_b   <= (others => '0');
        last_sof <= '0';
      elsif s.tvalid = '1' and s.tready = '1' then   -- accepted beat
        last_r   <= px.r;
        last_g   <= px.g;
        last_b   <= px.b;
        last_sof <= px.sof;
        nbeat    <= nbeat + 1;
      end if;
    end if;
  end process;

  beats <= std_logic_vector(nbeat);

end architecture;
