-- =====================================================================
-- top.vhd - QSPI demo: register write, then read back (VHDL-2019)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.qspi_pkg.all;

entity top is
  generic (
    WR_DATA : std_logic_vector(7 downto 0) := x"A5"
  );
  port (
    clk, rstn : in  std_logic;
    done      : out std_logic
  );
end entity;

architecture rtl of top is
  signal b : qspi_t(io_o(3 downto 0), io_i(3 downto 0),
                    io_oe(3 downto 0), cs(0 downto 0));
begin

  u_mast : entity work.qspi_master
    generic map (WR_DATA => WR_DATA)
    port map (clk => clk, rstn => rstn, m => b, done => done);

  u_slav : entity work.qspi_slave
    port map (clk => clk, rstn => rstn, s => b);

end architecture;
