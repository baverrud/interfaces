-- =====================================================================
-- top_split_tb.vhd - AXI4 split-master demo self-checking testbench
-- =====================================================================
-- Tests top_split in both slave modes:
--   SPLIT_SLAVE=false -> full slave, data pattern B0 (written then read back)
--   SPLIT_SLAVE=true  -> split slaves, data pattern C0 (read-only pre-init)
-- Toggle the SPLIT_SLAVE constant below to select the mode.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_split_tb is
end entity top_split_tb;

architecture sim of top_split_tb is
  constant SPLIT_SLAVE : boolean  := false;
  constant DATA_W     : positive  := 32;
  constant ADDR_W     : positive  := 32;
  constant ID_W       : positive  := 4;
  constant BURST_LEN  : positive  := 4;
  constant DEPTH      : positive  := 256;
  constant TCLK       : time      := 10 ns;

  signal aclk    : std_logic := '0';
  signal aresetn : std_logic := '0';
  signal rd_data  : std_logic_vector(DATA_W-1 downto 0);
  signal rd_valid : std_logic;
  signal done     : std_logic;

  -- Pattern base depends on slave mode:
  --   B0 = written to full slave then read back
  --   C0 = read slave pre-initialized
  function pattern_base return integer is
  begin
    if SPLIT_SLAVE then return 16#C0#; else return 16#B0#; end if;
  end function;
begin

  aclk <= not aclk after TCLK/2;

  dut : entity work.top_split
    generic map (
      DATA_W      => DATA_W,
      ADDR_W      => ADDR_W,
      ID_W        => ID_W,
      BURST_LEN   => BURST_LEN,
      DEPTH       => DEPTH,
      SPLIT_SLAVE => SPLIT_SLAVE
    )
    port map (
      aclk     => aclk,
      aresetn  => aresetn,
      rd_data  => rd_data,
      rd_valid => rd_valid,
      done     => done
    );

  stim : process
    variable beat_count : integer := 0;
    variable errors     : integer := 0;
    variable expected   : std_logic_vector(DATA_W-1 downto 0);
  begin
    errors     := 0;
    beat_count := 0;

    report "=== AXI4 Split-Master Demo (" & integer'image(BURST_LEN) & "-beat, " &
         "SPLIT_SLAVE=" & boolean'image(SPLIT_SLAVE) & ") ===" severity note;

    -- Reset
    aresetn <= '0';
    for i in 1 to 8 loop wait until rising_edge(aclk); end loop;
    aresetn <= '1';
    wait until rising_edge(aclk);

    -- Wait for done + capture read-data beats
    for i in 1 to 20 * BURST_LEN * 10 loop
      wait until rising_edge(aclk);
      if rd_valid = '1' then
        expected := std_logic_vector(to_unsigned(pattern_base + beat_count, 8)) &
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
