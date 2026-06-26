-- =====================================================================
-- qspi_slave.vhd - QSPI register slave (4-bit parallel) (VHDL-2019)
-- =====================================================================
-- Phase 0 (write): capture io_o on SCLK high (2 × 4-bit nibbles)
-- Phase 1 (read):  drive shadow onto io_i combinatorially
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.qspi_pkg.all;

entity qspi_slave is
  port (
    clk, rstn : in  std_logic;
    s         : view slave of qspi_t;
    done      : out std_logic
  );
end entity;

architecture rtl of qspi_slave is
  signal shadow     : std_logic_vector(7 downto 0);
  signal phase      : std_logic;
  signal cs_int     : std_logic;
  signal cs_prev    : std_logic;
  signal nibble_cnt : unsigned(3 downto 0);
  signal read_nibble : std_logic;
begin

  done <= '0';

  -- Combinational io_i drive during read phase
  s.io_i <= shadow(7 downto 4) when (cs_int = '0' and phase = '1' and read_nibble = '0') else
            shadow(3 downto 0) when (cs_int = '0' and phase = '1' and read_nibble = '1') else
            (s.io_i'range => '0');

  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        shadow      <= (others => '0');
        phase       <= '0';
        cs_prev     <= '1';
        cs_int      <= '1';
        nibble_cnt  <= (others => '0');
        read_nibble <= '0';
      else
        cs_int  <= s.cs(0);
        cs_prev <= cs_int;

        -- CS falling edge: transaction starting
        if cs_prev = '1' and cs_int = '0' then
          nibble_cnt  <= (others => '0');
          read_nibble <= '0';
        end if;

        -- SCLK high while CS active: capture io_o (write)
        if cs_int = '0' and s.sclk = '1' and phase = '0' then
          if nibble_cnt = 0 then
            shadow(7 downto 4) <= s.io_o;
            nibble_cnt <= nibble_cnt + 1;
          else
            shadow(3 downto 0) <= s.io_o;
          end if;
        end if;

        -- SCLK low while CS active: advance read nibble
        if cs_int = '0' and s.sclk = '0' and phase = '1' then
          read_nibble <= '1';
        end if;

        -- CS rising edge: transaction ending
        if cs_prev = '0' and cs_int = '1' then
          phase <= not phase;
        end if;

      end if;
    end if;
  end process;

end architecture;
