-- =====================================================================
-- stream_fifo.vhd - mode-view stream wrapper around the generic FIFO
-- =====================================================================
-- Presents an Rx port 's' (data in) and a Tx port 'm' (data out), both
-- using the generic-width axis_t. Internally it packs {tlast, tdata} into
-- one FIFO word of width DATA_W+1 and drives the handshake. The same
-- module therefore serves streams of ANY width via the DATA_W generic.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.stream_pkg.all;

entity stream_fifo is
    generic (
        DATA_W : positive := 8;
        DEPTH  : positive := 16
    );
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        s   : view rx of axis_t;   -- receiver side: data flows IN
        m   : view tx of axis_t    -- transmitter side: data flows OUT
    );
end entity;

architecture rtl of stream_fifo is
    constant W : positive := DATA_W + 1;   -- payload + tlast
    signal wr_en, rd_en, full, empty : std_logic;
    signal din, dout : std_logic_vector(W - 1 downto 0);
begin

    -- ---- write side: concatenate framing + payload into one word ------
    din      <= s.tlast & s.tdata;
    wr_en    <= s.tvalid;
    s.tready <= not full;

    -- ---- read side: split the word back into payload + framing --------
    m.tdata  <= dout(DATA_W - 1 downto 0);
    m.tlast  <= dout(DATA_W);
    m.tvalid <= not empty;
    rd_en    <= m.tready;

    u_fifo : entity work.sync_fifo
        generic map (WIDTH => W, DEPTH => DEPTH)
        port map (
            clk => clk, rst => rst,
            wr_en => wr_en, wr_data => din, full => full,
            rd_en => rd_en, rd_data => dout, empty => empty
        );

end architecture;
