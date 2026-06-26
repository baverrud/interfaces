-- =====================================================================
-- top.vhd - SBI demo: initiator -> target (VHDL-2019)
-- =====================================================================
library ieee; use ieee.std_logic_1164.all; use work.sbi_pkg.all;
entity top is
  generic (DATA_W : positive := 32; ADDR_W : positive := 8);
  port (clk, rstn : in std_logic;
        rd_data : out std_logic_vector(DATA_W-1 downto 0);
        rd_valid, done : out std_logic);
end entity;
architecture rtl of top is
  signal b : sbi_t(addr(ADDR_W-1 downto 0), wdata(DATA_W-1 downto 0),
                   rdata(DATA_W-1 downto 0));
begin
  u_init : entity work.sbi_initiator
    generic map (DATA_W => DATA_W, ADDR_W => ADDR_W)
    port map (clk => clk, rstn => rstn, m => b,
              rd_data => rd_data, rd_valid => rd_valid, done => done);
  u_targ : entity work.sbi_target
    generic map (DATA_W => DATA_W, ADDR_W => ADDR_W)
    port map (clk => clk, rstn => rstn, s => b);
end architecture;
