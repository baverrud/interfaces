-- =====================================================================
-- top_split.vhd - AXI4-Lite split master/slave demo
-- =====================================================================
-- Demonstrates sub-channel view split on both master and slave sides.
-- The SPLIT_SLAVE generic selects between a single full slave (false)
-- or independent write/read slaves (true).
--
-- Write pattern: 0xB0B0B0B0 (from write_master)
-- Read pattern:  0xC0C0C0C0 (read slave pre-initialized, when split)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axilite_pkg.all;

entity top_split is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; USER_W: positive:=1;
           DEPTH: positive:=256; SPLIT_SLAVE: boolean := false);
  port (aclk, aresetn: in std_logic;
      rd_data: out std_logic_vector(DATA_W-1 downto 0); rd_valid, done: out std_logic);
end entity;

architecture rtl of top_split is
  signal aw_bus: axilite_aw_t(awaddr(ADDR_W-1 downto 0), awuser(USER_W-1 downto 0));
  signal w_bus:  axilite_w_t(wdata(DATA_W-1 downto 0), wstrb(DATA_W/8-1 downto 0), wuser(USER_W-1 downto 0));
  signal b_bus:  axilite_b_t(buser(USER_W-1 downto 0));
  signal ar_bus: axilite_ar_t(araddr(ADDR_W-1 downto 0), aruser(USER_W-1 downto 0));
  signal r_bus:  axilite_r_t(rdata(DATA_W-1 downto 0), ruser(USER_W-1 downto 0));
  signal wr_done, rd_done: std_logic;
  signal wr_start: std_logic;
begin
  -- Write master
  u_wr_master: entity work.axilite_write_master
    generic map(DATA_W=>DATA_W, ADDR_W=>ADDR_W, USER_W=>USER_W)
    port map(aclk=>aclk, aresetn=>aresetn, aw=>aw_bus, w=>w_bus, b=>b_bus,
         start=>wr_start, done=>wr_done);

  -- Read master
  u_rd_master: entity work.axilite_read_master
    generic map(DATA_W=>DATA_W, ADDR_W=>ADDR_W, USER_W=>USER_W)
    port map(aclk=>aclk, aresetn=>aresetn, ar=>ar_bus, r=>r_bus,
         start=>wr_done, done=>rd_done,
         rd_data=>rd_data, rd_valid=>rd_valid);

  -- Full or split slave
  gen_slave: if not SPLIT_SLAVE generate
    -- Single full slave (reads back 0xB0B0B0B0 from write master's write)
    u_slave: entity work.axilite_slave
      generic map(DATA_W=>DATA_W, ADDR_W=>ADDR_W, USER_W=>USER_W, DEPTH=>DEPTH)
      port map(aclk=>aclk, aresetn=>aresetn,
           aw=>aw_bus, w=>w_bus, b=>b_bus, ar=>ar_bus, r=>r_bus);
  else generate
    -- Split slaves: write slave + read slave (pre-init with 0xC0C0C0C0)
    u_wr_slave: entity work.axilite_write_slave
      generic map(DATA_W=>DATA_W, ADDR_W=>ADDR_W, USER_W=>USER_W, DEPTH=>DEPTH)
      port map(aclk=>aclk, aresetn=>aresetn, aw=>aw_bus, w=>w_bus, b=>b_bus);
    u_rd_slave: entity work.axilite_read_slave
      generic map(DATA_W=>DATA_W, ADDR_W=>ADDR_W, USER_W=>USER_W, DEPTH=>DEPTH)
      port map(aclk=>aclk, aresetn=>aresetn, ar=>ar_bus, r=>r_bus);
  end generate;

  -- Kick off write master after reset
  process (aclk, aresetn)
    variable init_cnt: natural range 0 to 8 := 0;
  begin
    if aresetn = '0' then
      wr_start <= '0'; init_cnt := 0;
    elsif rising_edge(aclk) then
      if init_cnt < 7 then init_cnt := init_cnt + 1;
      elsif init_cnt = 7 then wr_start <= '1'; init_cnt := init_cnt + 1; end if;
    end if; end process;
  done <= rd_done;
end architecture;
