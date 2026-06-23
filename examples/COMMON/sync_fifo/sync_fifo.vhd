-- =====================================================================
-- sync_fifo.vhd - generic WIDTH/DEPTH synchronous FIFO (first-word
--                 fall-through). Operates on a flat std_logic_vector, so
--                 it is fully synthesis-portable and width-agnostic.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sync_fifo is
    generic (
        WIDTH : positive := 8;
        DEPTH : positive := 16
    );
    port (
        clk     : in  std_logic;
        rst     : in  std_logic;
        -- write side
        wr_en   : in  std_logic;
        wr_data : in  std_logic_vector(WIDTH - 1 downto 0);
        full    : out std_logic;
        -- read side (first-word fall-through: rd_data is the current head)
        rd_en   : in  std_logic;
        rd_data : out std_logic_vector(WIDTH - 1 downto 0);
        empty   : out std_logic
    );
end entity;

architecture rtl of sync_fifo is
    type mem_t is array (0 to DEPTH - 1) of std_logic_vector(WIDTH - 1 downto 0);
    signal mem   : mem_t;
    signal wptr  : natural range 0 to DEPTH - 1 := 0;
    signal rptr  : natural range 0 to DEPTH - 1 := 0;
    signal count : natural range 0 to DEPTH     := 0;
    signal full_i, empty_i : std_logic;
begin

    full_i  <= '1' when count = DEPTH else '0';
    empty_i <= '1' when count = 0     else '0';
    full    <= full_i;
    empty   <= empty_i;

    -- First-word fall-through: present the head combinationally.
    rd_data <= mem(rptr);

    process (clk)
        variable do_wr, do_rd : boolean;
    begin
        if rising_edge(clk) then
            if rst = '1' then
                wptr  <= 0;
                rptr  <= 0;
                count <= 0;
            else
                do_wr := (wr_en = '1') and (full_i  = '0');
                do_rd := (rd_en = '1') and (empty_i = '0');

                if do_wr then
                    mem(wptr) <= wr_data;
                    if wptr = DEPTH - 1 then wptr <= 0; else wptr <= wptr + 1; end if;
                end if;

                if do_rd then
                    if rptr = DEPTH - 1 then rptr <= 0; else rptr <= rptr + 1; end if;
                end if;

                if do_wr and not do_rd then
                    count <= count + 1;
                elsif do_rd and not do_wr then
                    count <= count - 1;
                end if;
            end if;
        end if;
    end process;

end architecture;
