-- =====================================================================
-- pixel_producer.vhd - builds RGB pixels, packs them onto a Tx stream
-- =====================================================================
-- Application-side module: it constructs a structured pixel_t each beat,
-- serialises it onto the (PIXEL_W-wide) tdata via pixel_to_slv, and marks
-- end-of-line with tlast. The stream infrastructure below it never needs
-- to know what the bits mean.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.stream_pkg.all;
use work.payload_pkg.all;

entity pixel_producer is
    generic (
        LINE : positive := 8       -- pixels per line; tlast at end of line
    );
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        m   : view tx of axis_t    -- tdata must be PIXEL_W wide
    );
end entity;

architecture rtl of pixel_producer is
    signal cnt  : unsigned(7 downto 0) := (others => '0');  -- pixel index in line
    signal seed : unsigned(7 downto 0) := (others => '0');  -- evolving colour
    signal px   : pixel_t;
begin

    -- Construct a pixel and serialise it onto the stream.
    px.r   <= std_logic_vector(seed);
    px.g   <= std_logic_vector(seed + 1);
    px.b   <= std_logic_vector(seed + 2);
    px.sof <= '1' when cnt = 0 else '0';

    m.tdata  <= pixel_to_slv(px);
    m.tvalid <= '1';
    m.tlast  <= '1' when cnt = LINE - 1 else '0';

    process (clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                cnt  <= (others => '0');
                seed <= (others => '0');
            elsif m.tready = '1' then       -- advance only on an accepted beat
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
