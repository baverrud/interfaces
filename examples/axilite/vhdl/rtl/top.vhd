-- =====================================================================
-- top.vhd - AXI4-Lite demo top level (full master + full slave)
-- =====================================================================
-- Instantiates the AXI4-Lite master test sequencer and register-file
-- slave, connected via per-channel constrained records.
--
-- The master drives the write-then-read sequence using per-channel
-- views (master_aw, master_w, master_b, master_ar, master_r).
-- The slave responds using the corresponding slave_* views.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axilite_pkg.all;

entity top is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; USER_W: positive:=1; DEPTH: positive:=256);
  port (aclk, aresetn: in std_logic;
      rd_data: out std_logic_vector(DATA_W-1 downto 0); rd_valid, done: out std_logic);
end entity;

architecture rtl of top is
  -- Per-channel constrained records (<=3 unconstrained elements each)
  signal aw_bus: axilite_aw_t(awaddr(ADDR_W-1 downto 0), awuser(USER_W-1 downto 0));
  signal w_bus:  axilite_w_t(wdata(DATA_W-1 downto 0), wstrb(DATA_W/8-1 downto 0), wuser(USER_W-1 downto 0));
  signal b_bus:  axilite_b_t(buser(USER_W-1 downto 0));
  signal ar_bus: axilite_ar_t(araddr(ADDR_W-1 downto 0), aruser(USER_W-1 downto 0));
  signal r_bus:  axilite_r_t(rdata(DATA_W-1 downto 0), ruser(USER_W-1 downto 0));
begin
  -- AXI4-Lite master -- test sequencer FSM
  -- Drives write-then-read sequence on per-channel views.
  u_master: entity work.axilite_master
    generic map(DATA_W=>DATA_W, ADDR_W=>ADDR_W, USER_W=>USER_W)
    port map(aclk=>aclk, aresetn=>aresetn,
         aw=>aw_bus, w=>w_bus, b=>b_bus, ar=>ar_bus, r=>r_bus,
         rd_data=>rd_data, rd_valid=>rd_valid, done=>done);

  -- AXI4-Lite slave -- register-file memory
  -- Responds to transactions on the slave_* views.
  u_slave: entity work.axilite_slave
    generic map(DATA_W=>DATA_W, ADDR_W=>ADDR_W, USER_W=>USER_W, DEPTH=>DEPTH)
    port map(aclk=>aclk, aresetn=>aresetn,
         aw=>aw_bus, w=>w_bus, b=>b_bus, ar=>ar_bus, r=>r_bus);
end architecture;
