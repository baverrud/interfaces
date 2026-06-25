-- =====================================================================
-- top_split.vhd - split masters + optional split slaves (per-channel)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.axi3_pkg.all;

entity top_split is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; ID_W: positive:=4;
       BURST_LEN: positive:=4; DEPTH: positive:=256;
       SPLIT_SLAVE: boolean := false);
  port (aclk, aresetn: in std_logic;
      rd_data: out std_logic_vector(DATA_W-1 downto 0); rd_valid, done: out std_logic);
end entity;

architecture rtl of top_split is
  signal aw_bus: axi3_aw_t(awid(ID_W-1 downto 0),awaddr(ADDR_W-1 downto 0),awuser(0 downto 0));
  signal w_bus:  axi3_w_t(wid(ID_W-1 downto 0),wdata(DATA_W-1 downto 0),wstrb(DATA_W/8-1 downto 0),wuser(0 downto 0));
  signal b_bus:  axi3_b_t(bid(ID_W-1 downto 0),buser(0 downto 0));
  signal ar_bus: axi3_ar_t(arid(ID_W-1 downto 0),araddr(ADDR_W-1 downto 0),aruser(0 downto 0));
  signal r_bus:  axi3_r_t(rid(ID_W-1 downto 0),rdata(DATA_W-1 downto 0),ruser(0 downto 0));
  signal init_done, wr_done, rd_done, wr_start: std_logic;
begin
  u_wr_master: entity work.axi3_write_master
    generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,BURST_LEN=>BURST_LEN)
    port map(aclk=>aclk,aresetn=>aresetn,aw=>aw_bus,w=>w_bus,b=>b_bus,start=>wr_start,done=>wr_done);
  u_rd_master: entity work.axi3_read_master
    generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,BURST_LEN=>BURST_LEN)
    port map(aclk=>aclk,aresetn=>aresetn,ar=>ar_bus,r=>r_bus,start=>wr_done,done=>rd_done,rd_data=>rd_data,rd_valid=>rd_valid);

  gen_full_slave: if not SPLIT_SLAVE generate
    u_slave: entity work.axi3_slave
      generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,DEPTH=>DEPTH)
      port map(aclk=>aclk,aresetn=>aresetn,aw=>aw_bus,w=>w_bus,b=>b_bus,ar=>ar_bus,r=>r_bus);
  end generate;

  gen_split_slave: if SPLIT_SLAVE generate
    u_wr_slave: entity work.axi3_write_slave
      generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,DEPTH=>DEPTH)
      port map(aclk=>aclk,aresetn=>aresetn,aw=>aw_bus,w=>w_bus,b=>b_bus);
    u_rd_slave: entity work.axi3_read_slave
      generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,DEPTH=>DEPTH)
      port map(aclk=>aclk,aresetn=>aresetn,ar=>ar_bus,r=>r_bus);
  end generate;

  process (aclk, aresetn) begin
    if aresetn = '0' then init_done <= '0'; wr_start <= '0';
    elsif rising_edge(aclk) then
      if init_done = '0' then init_done <= '1'; wr_start <= '1';
      else wr_start <= '0'; end if; end if; end process;
  done <= rd_done;
end architecture;
