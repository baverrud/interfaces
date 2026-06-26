-- =====================================================================
-- top.vhd - Wishbone demo: master -> slave (VHDL-2019)
-- =====================================================================
library ieee; use ieee.std_logic_1164.all; use work.wishbone_pkg.all;
entity top is
  generic (DATA_W : positive := 32; ADDR_W : positive := 32);
  port (clk, rstn : in std_logic;
        rd_data : out std_logic_vector(DATA_W-1 downto 0);
        rd_valid, done : out std_logic);
end entity;
architecture rtl of top is
  signal b : wishbone_t(adr(ADDR_W-1 downto 0), dat_o(DATA_W-1 downto 0),
                         dat_i(DATA_W-1 downto 0), sel(DATA_W/8-1 downto 0));
begin
  u_mast : entity work.wishbone_master
    generic map (DATA_W => DATA_W, ADDR_W => ADDR_W)
    port map (clk => clk, rstn => rstn, m => b,
              rd_data => rd_data, rd_valid => rd_valid, done => done);
  u_slav : entity work.wishbone_slave
    generic map (DATA_W => DATA_W, ADDR_W => ADDR_W)
    port map (clk => clk, rstn => rstn, s => b);
end architecture;
