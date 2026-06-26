-- =====================================================================
-- top.vhd - APB demo: producer -> consumer (VHDL-2019)
-- =====================================================================
-- Clean top: instantiates a constrained apb_t record, producer (write
-- 0xA5 then read), and consumer (single-register slave).
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.apb_pkg.all;

entity top is
  generic (DATA_W : positive := 32; ADDR_W : positive := 32);
  port (pclk, prstn : in std_logic;
        rd_data : out std_logic_vector(DATA_W-1 downto 0);
        rd_valid, done : out std_logic);
end entity;

architecture rtl of top is
  signal b : apb_t(paddr(ADDR_W-1 downto 0), pwdata(DATA_W-1 downto 0),
                   prdata(DATA_W-1 downto 0), pstrb(DATA_W/8-1 downto 0));
begin
  u_prod : entity work.apb_master
    generic map (DATA_W => DATA_W, ADDR_W => ADDR_W)
    port map (pclk => pclk, prstn => prstn, m => b,
              rd_data => rd_data, rd_valid => rd_valid, done => done);
  u_cons : entity work.apb_slave
    generic map (DATA_W => DATA_W, ADDR_W => ADDR_W)
    port map (pclk => pclk, prstn => prstn, s => b);
end architecture;
