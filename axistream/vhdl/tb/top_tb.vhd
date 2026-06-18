-- =====================================================================
-- top_tb.vhd - self-checking testbench for the generic stream/FIFO demo
-- =====================================================================
-- Exercises three things:
--   1) pack/unpack round-trips for BOTH payload types (pixel_t, iq_t);
--   2) a generic stream_fifo instantiated at the IQ width (32-bit),
--      pushing/popping structured iq_t samples through it ("auto
--      concatenate into/out of a FIFO") and checking order + values;
--   3) the synthesizable top pixel pipeline actually moves data
--      (beats advance, a start-of-frame is observed).
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;
use work.stream_pkg.all;
use work.payload_pkg.all;

entity top_tb is
end entity;

architecture sim of top_tb is
    constant TCLK : time := 10 ns;

    signal clk  : std_logic := '0';
    signal rst  : std_logic := '1';
    signal done : boolean   := false;

    -- top (pixel pipeline) outputs
    signal last_r, last_g, last_b : std_logic_vector(7 downto 0);
    signal last_sof : std_logic;
    signal beats    : std_logic_vector(15 downto 0);

    -- second stream: IQ samples through a generic stream_fifo (32-bit)
    -- TLAST enabled (1 bit), all other sidebands absent (null ranges)
    signal iq_src  : axis_t(
        tdata(IQ_W - 1 downto 0),
        tuser(0 downto 0),
        tid(0 downto 0),
        tdest(0 downto 0),
        tkeep(0 downto 0),
        tstrb(0 downto 0)
    );
    signal iq_sink : axis_t(
        tdata(IQ_W - 1 downto 0),
        tuser(0 downto 0),
        tid(0 downto 0),
        tdest(0 downto 0),
        tkeep(0 downto 0),
        tstrb(0 downto 0)
    );

    signal sof_seen : boolean := false;
begin

    -- gated clock so the simulation stops cleanly at the end
    clk <= not clk after TCLK / 2 when not done else '0';

    -- DUT 1: full pixel pipeline (producer -> stream_fifo -> consumer)
    dut_pix : entity work.top
        generic map (FIFO_DEPTH => 16, LINE => 8)
        port map (clk => clk, rst => rst,
                  last_r => last_r, last_g => last_g, last_b => last_b,
                  last_sof => last_sof, beats => beats);

    -- DUT 2: a second generic FIFO instance, this time at the IQ width
    dut_iq : entity work.stream_fifo
        generic map (DEPTH => 16)
        port map (clk => clk, rst => rst, s => iq_src, m => iq_sink);

    -- observe at least one start-of-frame leaving the pixel pipeline
    mon : process (clk)
    begin
        if rising_edge(clk) then
            if last_sof = '1' then
                sof_seen <= true;
            end if;
        end if;
    end process;

    stim : process
        constant NIQ : natural := 8;
        type iq_array is array (natural range <>) of iq_t;
        variable seq : iq_array(0 to NIQ - 1);
        variable got : iq_t;
        variable p, rp : pixel_t;
        variable last_v : std_logic;
    begin
        -- ---- 0) reset ------------------------------------------------
        iq_src.tvalid  <= '0';
        iq_src.tlast   <= '0';
        iq_src.tdata   <= (others => '0');
        iq_sink.tready <= '0';
        rst <= '1';
        wait for 4 * TCLK;
        wait until rising_edge(clk);
        rst <= '0';

        -- ---- 1) pack/unpack round-trip checks ------------------------
        assert PIXEL_W = 25 report "PIXEL_W expected 25" severity failure;
        assert IQ_W    = 32 report "IQ_W expected 32"    severity failure;

        for k in 0 to 4 loop
            p.r := std_logic_vector(to_unsigned(10 * k + 1, 8));
            p.g := std_logic_vector(to_unsigned(10 * k + 2, 8));
            p.b := std_logic_vector(to_unsigned(10 * k + 3, 8));
            if (k mod 2) = 0 then p.sof := '1'; else p.sof := '0'; end if;
            rp := pixel_from_slv(pixel_to_slv(p));
            assert rp = p report "pixel round-trip mismatch at " & integer'image(k)
                severity failure;
        end loop;

        for k in 0 to NIQ - 1 loop
            seq(k).i := to_signed(100 + k, 16);
            seq(k).q := to_signed(-50 - k, 16);
            got := iq_from_slv(iq_to_slv(seq(k)));
            assert got = seq(k) report "iq round-trip mismatch at " & integer'image(k)
                severity failure;
        end loop;
        report "INFO: pack/unpack round-trips OK (pixel_t, iq_t)" severity note;

        -- ---- 2) push the IQ sequence THROUGH the generic FIFO --------
        -- write phase (FIFO has room: NIQ <= DEPTH)
        iq_sink.tready <= '0';
        for k in 0 to NIQ - 1 loop
            iq_src.tdata <= iq_to_slv(seq(k));
            if k = NIQ - 1 then last_v := '1'; else last_v := '0'; end if;
            iq_src.tlast  <= last_v;
            iq_src.tvalid <= '1';
            loop
                wait until rising_edge(clk);
                exit when iq_src.tready = '1';
            end loop;
        end loop;
        iq_src.tvalid <= '0';

        -- read phase: inspect head (tready=0), then pulse tready to pop
        for k in 0 to NIQ - 1 loop
            loop
                wait until rising_edge(clk);
                exit when iq_sink.tvalid = '1';
            end loop;
            got := iq_from_slv(iq_sink.tdata);
            assert got = seq(k)
                report "IQ FIFO data/order mismatch at " & integer'image(k)
                severity failure;
            if k = NIQ - 1 then
                assert iq_sink.tlast = '1'
                    report "IQ FIFO did not preserve tlast" severity failure;
            end if;
            iq_sink.tready <= '1';
            wait until rising_edge(clk);
            iq_sink.tready <= '0';
        end loop;
        report "INFO: IQ stream passed through generic FIFO (32-bit) OK" severity note;

        -- ---- 3) confirm the pixel pipeline is moving data ------------
        wait for 40 * TCLK;
        assert unsigned(beats) > 0
            report "pixel pipeline produced no beats" severity failure;
        assert sof_seen
            report "no start-of-frame observed from pixel pipeline" severity failure;
        report "INFO: pixel pipeline beats = " & integer'image(to_integer(unsigned(beats)))
            severity note;

        report "=== PIPELINE (generic FIFO / packed streams) PASSED ===" severity note;

        done <= true;
        stop;       -- std.env.stop: halt without a GUI close prompt
        wait;
    end process;

end architecture;
