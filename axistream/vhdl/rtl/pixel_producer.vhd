-- =====================================================================
-- pixel_producer.vhd - builds RGB pixels, drives axis_t.master
-- =====================================================================
-- Drives tdata with pixel data, tlast at end-of-line, and ties unused
-- sidebands to '0'.  Matches the SV pixel_producer behaviour.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.stream_pkg.all;
use work.payload_pkg.all;

entity pixel_producer is
    generic (
        LINE : positive := 8
    );
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        m   : view master of axis_t
    );
end entity;

architecture rtl of pixel_producer is
    signal cnt  : unsigned(7 downto 0) := (others => '0');
    signal seed : unsigned(7 downto 0) := (others => '0');
    signal px   : pixel_t;
begin

    px.r   <= std_logic_vector(seed);
    px.g   <= std_logic_vector(seed + 1);
    px.b   <= std_logic_vector(seed + 2);
    px.sof <= '1' when cnt = 0 else '0';

    m.tdata  <= pixel_to_slv(px);
    m.tvalid <= '1';
    m.tlast  <= '1' when cnt = LINE - 1 else '0';
    -- 1-bit sideband stubs — tie low (synthesis constant-propagates to zero)
    m.tuser  <= (m.tuser'range => '0');
    m.tid    <= (m.tid'range => '0');
    m.tdest  <= (m.tdest'range => '0');
    m.tkeep  <= (m.tkeep'range => '0');
    m.tstrb  <= (m.tstrb'range => '0');

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt  <= (others => '0');
                seed <= (others => '0');
            elsif m.tready = '1' then
                seed <= seed + 1;
                if cnt = LINE - 1 then
                    cnt <= (others => '0');
                else
                    cnt <= cnt + 1;
                end if;
            end if;
        end if;
    end process;

end architecture;
