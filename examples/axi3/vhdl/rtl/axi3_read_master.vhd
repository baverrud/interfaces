-- =====================================================================
-- axi3_read_master.vhd - read-only AXI3 master (sub-channel)
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axi3_pkg.all;

entity axi3_read_master is
  generic (DATA_W: positive:=32; ADDR_W: positive:=32; ID_W: positive:=4; BURST_LEN: positive:=4);
port (aclk, aresetn: in std_logic;
    ar: view master_ar of axi3_ar_t; r: view master_r of axi3_r_t;
    start: in std_logic; done: out std_logic;
      rd_data: out std_logic_vector(DATA_W-1 downto 0); rd_valid: out std_logic);
end entity;

architecture rtl of axi3_read_master is
  constant AXLEN: unsigned(3 downto 0) := to_unsigned(BURST_LEN - 1, 4);
  type state_t is (S_IDLE, S_AR, S_READ, S_DONE);
  signal state: state_t := S_IDLE;
  signal beat_cnt: unsigned(3 downto 0);
begin
  ar.arid    <= (ar.arid'range => '0');
  ar.arlen   <= std_logic_vector(AXLEN);
  ar.arsize  <= "010"; ar.arburst <= "01"; ar.arlock <= "00";
  ar.arcache <= "0000"; ar.arprot <= "000"; ar.arqos <= "0000";
  ar.aruser  <= (ar.aruser'range => '0');

  process (aclk, aresetn)
  begin
    if aresetn = '0' then
      state <= S_IDLE; done <= '0'; beat_cnt <= (others => '0');
      ar.arvalid <= '0'; r.rready <= '0';
      rd_data <= (others => '0'); rd_valid <= '0';
    elsif rising_edge(aclk) then
      done <= '0'; rd_valid <= '0';
      case state is
        when S_IDLE => if start = '1' then state <= S_AR; beat_cnt <= (others => '0'); end if;
        when S_AR =>
          ar.araddr <= X"00001000";
          if ar.arvalid = '0' then ar.arvalid <= '1'; end if;
          if ar.arvalid = '1' and ar.arready = '1' then
            state <= S_READ; beat_cnt <= (others => '0'); end if;
        when S_READ =>
          if r.rready = '0' then r.rready <= '1'; end if;
          if r.rvalid = '1' and r.rready = '1' then
            rd_valid <= '1'; rd_data <= r.rdata;
            if beat_cnt = AXLEN then state <= S_DONE; else beat_cnt <= beat_cnt + 1; end if; end if;
        when S_DONE =>
          done <= '1'; ar.arvalid <= '0'; r.rready <= '0';
      end case; end if; end process;
end architecture;
