-- =====================================================================
-- stream_fifo.vhd - bundles ALL sidebands + payload into one FIFO word
-- =====================================================================
-- FIFO word width is computed at elaboration from the actual signal
-- widths of the connected port (s.tdata'length, s.tlast'length, etc.).
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.stream_pkg.all;

entity stream_fifo is
    generic (
        DEPTH : positive := 16
    );
    port (
        clk : in  std_logic;
        rst : in  std_logic;
        s   : view slave of axis_t;   -- receiver side: data flows IN
        m   : view master of axis_t   -- transmitter side: data flows OUT
    );
end entity;

architecture rtl of stream_fifo is
    -- Compute total word width from actual signal constraints.
    -- tlast is std_logic (1 bit); all sidebands are 1-bit safe-width stubs.
    constant DATA_W  : natural := s.tdata'length;
    constant TLAST_W : natural := 1;
    constant TUSER_W : natural := s.tuser'length;
    constant TID_W   : natural := s.tid'length;
    constant TDEST_W : natural := s.tdest'length;
    constant TKEEP_W : natural := s.tkeep'length;
    constant TSTRB_W : natural := s.tstrb'length;
    constant WORD_W  : natural := DATA_W + TLAST_W + TUSER_W + TID_W +
                                  TDEST_W + TKEEP_W + TSTRB_W;
    signal full, empty : std_logic;
    signal din, dout   : std_logic_vector(WORD_W - 1 downto 0);
begin

    -- ---- write side: pack into one word --------------------------------
    -- tlast is std_logic, convert to vector for concatenation
    din      <= s.tstrb & s.tkeep & s.tdest & s.tid & s.tuser &
                (0 => s.tlast) & s.tdata;
    s.tready <= not full;

    -- ---- read side: unpack using generate -------------------------------
    -- tlast is always present (std_logic)
    m.tlast <= dout(DATA_W);

    gen_tuser : if TUSER_W > 0 generate
        m.tuser <= dout(DATA_W + TLAST_W + TUSER_W - 1 downto DATA_W + TLAST_W);
    end generate;

    gen_tid : if TID_W > 0 generate
        m.tid   <= dout(DATA_W + TLAST_W + TUSER_W + TID_W - 1 downto
                        DATA_W + TLAST_W + TUSER_W);
    end generate;

    gen_tdest : if TDEST_W > 0 generate
        m.tdest <= dout(DATA_W + TLAST_W + TUSER_W + TID_W + TDEST_W - 1 downto
                        DATA_W + TLAST_W + TUSER_W + TID_W);
    end generate;

    gen_tkeep : if TKEEP_W > 0 generate
        m.tkeep <= dout(DATA_W + TLAST_W + TUSER_W + TID_W + TDEST_W + TKEEP_W - 1 downto
                        DATA_W + TLAST_W + TUSER_W + TID_W + TDEST_W);
    end generate;

    gen_tstrb : if TSTRB_W > 0 generate
        m.tstrb <= dout(DATA_W + TLAST_W + TUSER_W + TID_W + TDEST_W + TKEEP_W + TSTRB_W - 1 downto
                        DATA_W + TLAST_W + TUSER_W + TID_W + TDEST_W + TKEEP_W);
    end generate;

    m.tdata  <= dout(DATA_W - 1 downto 0);
    m.tvalid <= not empty;

    -- ---- FIFO ---------------------------------------------------------
    u_fifo : entity work.sync_fifo
        generic map (WIDTH => WORD_W, DEPTH => DEPTH)
        port map (
            clk => clk, rst => rst,
            wr_en => s.tvalid, wr_data => din, full => full,
            rd_en => m.tready, rd_data => dout, empty => empty
        );

end architecture;
