-- =====================================================================
-- axilite_read_master.vhd - read-only AXI4-Lite master
-- =====================================================================
-- Demonstrates the sub-channel view paradigm: this module uses only
-- the read-side views (master_ar, master_r) and has zero write-channel
-- logic or signals.
--
-- Ports:
--   ar      — Read Address channel (master_ar) — Tx
--   r       — Read Data channel    (master_r)   — Rx
--   start   — begin the read transaction
--   done    — asserted when read completes
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axilite_pkg.all;

entity axilite_read_master is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; USER_W: positive:=1);
  port (aclk, aresetn: in std_logic;
        ar: view master_ar of axilite_ar_t;
        r:  view master_r  of axilite_r_t;
        start: in std_logic; done: out std_logic;
        rd_data: out std_logic_vector(DATA_W-1 downto 0); rd_valid: out std_logic);
end entity;

architecture rtl of axilite_read_master is
  type state_t is (S_IDLE, S_AR, S_READ, S_DONE);
  signal state: state_t := S_IDLE;
begin
  ar.arprot <= "000";
  ar.aruser <= (ar.aruser'range => '0');

  process (aclk, aresetn)
  begin
    if aresetn = '0' then
      state <= S_IDLE; done <= '0'; rd_valid <= '0';
      ar.arvalid <= '0'; r.rready <= '0'; rd_data <= (others => '0');
    elsif rising_edge(aclk) then
      done <= '0'; rd_valid <= '0';
      case state is
        when S_IDLE => if start = '1' then state <= S_AR; end if;
        when S_AR =>
          ar.araddr <= std_logic_vector(to_unsigned(16#1000#, ADDR_W));
          if ar.arvalid = '0' then ar.arvalid <= '1'; end if;
          if ar.arvalid = '1' and ar.arready = '1' then state <= S_READ; end if;
        when S_READ =>
          if r.rready = '0' then r.rready <= '1'; end if;
          if r.rvalid = '1' and r.rready = '1' then
            rd_valid <= '1'; rd_data <= r.rdata;
            state <= S_DONE; end if;
        when S_DONE =>
          done <= '1'; ar.arvalid <= '0'; r.rready <= '0';
      end case; end if; end process;
end architecture;
