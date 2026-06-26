-- =====================================================================
-- spi_slave.vhd - SPI register slave with write/read tracking (VHDL-2019)
-- =====================================================================
-- Implements a simple SPI register:
--   Phase 0 (write): capture MOSI on SCLK rising edges into shift
--     register; on CS rising edge, store into shadow register
--   Phase 1 (read):  drive shadow register onto MISO on SCLK
--     rising edges; on CS rising edge, toggle back to phase 0
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.spi_pkg.all;

entity spi_slave is
  port (
    clk, rstn : in  std_logic;          -- system clock / active-low reset
    s         : view slave of spi_t;    -- SPI slave mode view
    done      : out std_logic           -- unused
  );
end entity;

architecture rtl of spi_slave is
  signal shadow  : std_logic_vector(7 downto 0);  -- internal register
  signal shift   : std_logic_vector(7 downto 0);  -- shift register
  signal phase   : std_logic;                      -- 0=write, 1=read
  signal cs_prev : std_logic;                      -- previous CS for edge detect
begin

  done <= '0';

  process (clk) begin
    if rising_edge(clk) then
      if rstn = '0' then
        shadow  <= (others => '0');
        shift   <= (others => '0');
        s.miso  <= '0';
        phase   <= '0';
        cs_prev <= '1';
      else
        cs_prev <= s.cs(0);

        -- CS falling edge: transaction starting
        if cs_prev = '1' and s.cs(0) = '0' then
          if phase = '0' then
            shift <= (others => '0');      -- prepare to capture
          else
            shift <= shadow;               -- load data to echo
            -- MISO is driven on SCLK low (next half-cycle)
          end if;
        end if;

        -- SCLK high while CS active: capture MOSI (write)
        if s.cs(0) = '0' and s.sclk = '1' then
          if phase = '0' then
            -- Write: capture MOSI on SCLK high (MSB first)
            shift <= shift(6 downto 0) & s.mosi;
          end if;
        end if;

        -- SCLK low while CS active: drive MISO (read)
        -- Drive on opposite half-cycle to avoid race with master
        -- capture (master captures on SCLK high).
        if s.cs(0) = '0' and s.sclk = '0' then
          if phase = '1' then
            -- Read: drive shadow register onto MISO
            s.miso <= shift(7);
            shift  <= shift(6 downto 0) & '0';
          end if;
        end if;

        -- CS rising edge: transaction ending
        if cs_prev = '0' and s.cs(0) = '1' then
          if phase = '0' then
            shadow <= shift;                -- store captured byte
            s.miso <= '0';
          end if;
          phase <= not phase;               -- alternate write/read
        end if;

      end if;
    end if;
  end process;

end architecture;    -- of spi_slave
