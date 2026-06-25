-- =====================================================================
-- top_tb.vhd - AXI4 demo self-checking testbench
-- =====================================================================
-- Generates clock + reset for the top (axi4_master + axi4_slave)
-- design, waits for the write-then-read burst sequence to complete,
-- and verifies that each read-back data beat matches the expected
-- 0xA0-prefixed incrementing pattern.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_tb is
end entity top_tb;

architecture sim of top_tb is
  -- DUT parameters (must match what the master generates)
  constant DATA_W    : positive := 32;
  constant ADDR_W    : positive := 32;
  constant ID_W      : positive := 4;
  constant BURST_LEN : positive := 4;
  constant DEPTH     : positive := 256;
  -- 100 MHz clock
  constant TCLK      : time := 10 ns;

  signal aclk    : std_logic := '0';
  signal aresetn : std_logic := '0';
  signal rd_data  : std_logic_vector(DATA_W-1 downto 0);
  signal rd_valid : std_logic;
  signal done     : std_logic;
begin

  -- Clock generator: 100 MHz
  aclk <= not aclk after TCLK/2;

  -- Device under test: top level with full master + full slave
  dut : entity work.top
    generic map (
      DATA_W    => DATA_W,
      ADDR_W    => ADDR_W,
      ID_W      => ID_W,
      BURST_LEN => BURST_LEN,
      DEPTH     => DEPTH
    )
    port map (
      aclk     => aclk,
      aresetn  => aresetn,
      rd_data  => rd_data,
      rd_valid => rd_valid,
      done     => done
    );

  -- Test sequence: apply reset, wait for done, check every read beat
  stim : process
    variable beat_count : integer := 0;
    variable errors     : integer := 0;
    variable expected   : std_logic_vector(DATA_W-1 downto 0);
  begin
    errors     := 0;
    beat_count := 0;

    report "=== AXI4 Burst Write/Read Demo (" & integer'image(BURST_LEN) & "-beat bursts) ===" severity note;

    -- Assert reset for 8 clock cycles
    aresetn <= '0';
    for i in 1 to 8 loop wait until rising_edge(aclk); end loop;
    aresetn <= '1';
    wait until rising_edge(aclk);

    -- Monitor rd_valid beats until done is asserted
    for i in 1 to 20 * BURST_LEN * 10 loop
      wait until rising_edge(aclk);
      if rd_valid = '1' then
        -- Expected pattern: {8'hA0 + beat, 24'(beat + 1)}
        expected := std_logic_vector(to_unsigned(16#A0# + beat_count, 8)) &
              std_logic_vector(to_unsigned(beat_count + 1, 24));
        if rd_data /= expected then
          report "Beat " & integer'image(beat_count) & " mismatch: expected " &
               to_hstring(expected) & ", got " & to_hstring(rd_data) severity error;
          errors := errors + 1;
        else
          report "Beat " & integer'image(beat_count) & ": " & to_hstring(rd_data) & " (OK)" severity note;
        end if;
        beat_count := beat_count + 1;
      end if;
      if done = '1' then exit; end if;
    end loop;

    -- Final pass/fail report
    if errors = 0 then
      report "PASSED: All " & integer'image(BURST_LEN) & " beats matched expected pattern" severity note;
    else
      report "FAILED: " & integer'image(errors) & " mismatches detected" severity error;
    end if;

    report "Simulation finished." severity note;
    std.env.stop;
    wait;
  end process;

end architecture sim;
