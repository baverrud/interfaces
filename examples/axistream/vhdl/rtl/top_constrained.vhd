-- =====================================================================
-- top_constrained.vhd - fully constrained 32-bit AXI-Stream demo
-- =====================================================================
-- Demonstrates `axis_32b_t` — a record with ALL vector widths fixed in
-- the type declaration.  Signal declarations need NO record constraint
-- syntax.  The producer and consumer logic is inline (no separate
-- entity files needed) to keep the focus on the type.
--
-- Compare:
--   signal s : axis_32b_t;            -- this file (no constraint)
--   signal s : axis_t(tdata(..),...); -- top.vhd (inline constraints)
--   signal s : pixel_stream_t;        -- top_subtype.vhd (subtype alias)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axis_pkg.all;

entity top_constrained is
  generic (
    N_BEATS : positive := 16   -- number of beats to send
  );
  port (
    clk  : in  std_logic;
    rst  : in  std_logic;
    done : out std_logic
  );
end entity;

architecture rtl of top_constrained is
  signal str   : axis_32b_t;
  signal nbeat : unsigned(31 downto 0) := (others => '0');
  signal done_r : std_logic := '0';
begin

  -- ---- Producer: drive a counter as tdata ---------------------------
  str.tdata  <= std_logic_vector(nbeat);
  str.tlast  <= '1' when nbeat = N_BEATS - 1 else '0';
  str.tvalid <= '1' when unsigned(nbeat) < N_BEATS else '0';
  -- 1-bit sideband stubs — tie low
  str.tuser  <= (others => '0');
  str.tid    <= (others => '0');
  str.tdest  <= (others => '0');
  str.tkeep  <= (others => '0');
  str.tstrb  <= (others => '0');

  -- ---- Consumer: always ready ---------------------------------------
  str.tready <= '1';

  process (clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        nbeat <= (others => '0');
        done_r <= '0';
      elsif str.tvalid = '1' and str.tready = '1' then
        if nbeat = N_BEATS - 1 then
          done_r <= '1';
        else
          nbeat <= nbeat + 1;
        end if;
      end if;
    end if;
  end process;

  done <= done_r;

end architecture;
