-- =====================================================================
-- top.vhd - full AXI3 master + slave (per-channel signals)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.axi3_pkg.all;

entity top is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; ID_W: positive:=4; BURST_LEN: positive:=4; DEPTH: positive:=256);
  port (aclk, aresetn: in std_logic; rd_data: out std_logic_vector(DATA_W-1 downto 0); rd_valid, done: out std_logic);
end entity;

architecture rtl of top is
  signal aw_bus: axi3_aw_t(awid(ID_W-1 downto 0),awaddr(ADDR_W-1 downto 0),awuser(0 downto 0));
  signal w_bus:  axi3_w_t(wid(ID_W-1 downto 0),wdata(DATA_W-1 downto 0),wstrb(DATA_W/8-1 downto 0),wuser(0 downto 0));
  signal b_bus:  axi3_b_t(bid(ID_W-1 downto 0),buser(0 downto 0));
  signal ar_bus: axi3_ar_t(arid(ID_W-1 downto 0),araddr(ADDR_W-1 downto 0),aruser(0 downto 0));
  signal r_bus:  axi3_r_t(rid(ID_W-1 downto 0),rdata(DATA_W-1 downto 0),ruser(0 downto 0));
begin
  u_master: entity work.axi3_master
    generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,BURST_LEN=>BURST_LEN)
    port map(aclk=>aclk,aresetn=>aresetn,aw=>aw_bus,w=>w_bus,b=>b_bus,ar=>ar_bus,r=>r_bus,
         rd_data=>rd_data,rd_valid=>rd_valid,done=>done);
  u_slave: entity work.axi3_slave
    generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,DEPTH=>DEPTH)
    port map(aclk=>aclk,aresetn=>aresetn,aw=>aw_bus,w=>w_bus,b=>b_bus,ar=>ar_bus,r=>r_bus);
end architecture;
