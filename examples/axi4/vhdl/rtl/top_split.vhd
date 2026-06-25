-- =====================================================================
-- top_split.vhd - split masters + optional split slaves (per-channel)
-- =====================================================================
-- Consolidates the former top_sub and top_sub_slave designs.
--
--   SPLIT_SLAVE = false  →  full axi4_slave      (was top_sub)
--   SPLIT_SLAVE = true   →  axi4_write_slave +
--                            axi4_read_slave       (was top_sub_slave)
--
-- Interface demo: the write master connects only to AW/W/B channel views
-- (via `master_aw`, `master_w`, `master_b`) while the read master connects
-- only to AR/R views (`master_ar`, `master_r`).  The slave side mirrors
-- this with `slave_*` views, all derived via `'converse` in axi4_pkg.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.axi4_pkg.all;

entity top_split is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; ID_W: positive:=4;
       BURST_LEN: positive:=4; DEPTH: positive:=256;
       SPLIT_SLAVE: boolean := false);
  port (aclk, aresetn: in std_logic;
      rd_data: out std_logic_vector(DATA_W-1 downto 0); rd_valid, done: out std_logic);
end entity;

architecture rtl of top_split is
  signal aw_bus: axi4_aw_t(awid(ID_W-1 downto 0),awaddr(ADDR_W-1 downto 0),awuser(0 downto 0));
  signal w_bus:  axi4_w_t(wdata(DATA_W-1 downto 0),wstrb(DATA_W/8-1 downto 0),wuser(0 downto 0));
  signal b_bus:  axi4_b_t(bid(ID_W-1 downto 0),buser(0 downto 0));
  signal ar_bus: axi4_ar_t(arid(ID_W-1 downto 0),araddr(ADDR_W-1 downto 0),aruser(0 downto 0));
  signal r_bus:  axi4_r_t(rid(ID_W-1 downto 0),rdata(DATA_W-1 downto 0),ruser(0 downto 0));
  signal init_done, wr_done, rd_done, wr_start: std_logic;
begin
  -- Write master: drives AW + W channels, handles B response
  u_wr_master: entity work.axi4_write_master
    generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,BURST_LEN=>BURST_LEN)
    port map(aclk=>aclk,aresetn=>aresetn,aw=>aw_bus,w=>w_bus,b=>b_bus,start=>wr_start,done=>wr_done);
  -- Read master: drives AR channel, captures R beats (starts after write completes)
  u_rd_master: entity work.axi4_read_master
    generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,BURST_LEN=>BURST_LEN)
    port map(aclk=>aclk,aresetn=>aresetn,ar=>ar_bus,r=>r_bus,start=>wr_done,done=>rd_done,rd_data=>rd_data,rd_valid=>rd_valid);

  -- Full slave (both write + read in one module)
  gen_full_slave: if not SPLIT_SLAVE generate
    u_slave: entity work.axi4_slave
      generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,DEPTH=>DEPTH)
      port map(aclk=>aclk,aresetn=>aresetn,aw=>aw_bus,w=>w_bus,b=>b_bus,ar=>ar_bus,r=>r_bus);
  end generate;

  -- Split slaves (independent write-only + read-only modules)
  gen_split_slave: if SPLIT_SLAVE generate
    u_wr_slave: entity work.axi4_write_slave
      generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,DEPTH=>DEPTH)
      port map(aclk=>aclk,aresetn=>aresetn,aw=>aw_bus,w=>w_bus,b=>b_bus);
    u_rd_slave: entity work.axi4_read_slave
      generic map(DATA_W=>DATA_W,ADDR_W=>ADDR_W,ID_W=>ID_W,DEPTH=>DEPTH)
      port map(aclk=>aclk,aresetn=>aresetn,ar=>ar_bus,r=>r_bus);
  end generate;

  -- Startup sequencer: pulse wr_start for one cycle after reset
  process (aclk, aresetn) begin
    if aresetn = '0' then init_done <= '0'; wr_start <= '0';
    elsif rising_edge(aclk) then
      if init_done = '0' then init_done <= '1'; wr_start <= '1';
      else wr_start <= '0'; end if; end if; end process;
  done <= rd_done;
end architecture;
