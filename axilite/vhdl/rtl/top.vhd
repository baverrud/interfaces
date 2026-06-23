-- =====================================================================
-- top.vhd - AXI4-Lite demo: test driver -> axil_reg
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.axilite_pkg.all;

entity top is
    port (
        aclk         : in  std_logic;
        aresetn      : in  std_logic;
        reg_readout  : out std_logic_vector(31 downto 0)
    );
end entity;

architecture rtl of top is
    signal bus_m   : axilite_t(
        awaddr(31 downto 0),
        wdata(31 downto 0),
        wstrb(3 downto 0),
        araddr(31 downto 0),
        rdata(31 downto 0),
        awuser(0 downto 0),
        wuser(0 downto 0),
        buser(0 downto 0),
        aruser(0 downto 0),
        ruser(0 downto 0)
    );
    signal bus_s   : axilite_t(
        awaddr(31 downto 0),
        wdata(31 downto 0),
        wstrb(3 downto 0),
        araddr(31 downto 0),
        rdata(31 downto 0),
        awuser(0 downto 0),
        wuser(0 downto 0),
        buser(0 downto 0),
        aruser(0 downto 0),
        ruser(0 downto 0)
    );
    signal aclk_int, aresetn_int : std_logic;
begin
    aclk_int    <= bus_m.aclk;
    aresetn_int <= bus_m.aresetn;

    -- Pass clock/reset through both halves
    bus_s.aclk    <= bus_m.aclk;
    bus_s.aresetn <= bus_m.aresetn;

    reg_readout <= bus_s.rdata;
end architecture;
