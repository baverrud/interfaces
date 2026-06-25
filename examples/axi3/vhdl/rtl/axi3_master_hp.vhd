-- =====================================================================
-- axi3_master_hp.vhd - AXI3 HP master (fully constrained axi3_hp_t)
-- =====================================================================
-- AXI3 HP variant: 64-bit data, 32-bit address, 6-bit ID.
-- Models the Zynq-7000 S_AXI_HP port style.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axi3_pkg.all;

entity axi3_master_hp is
  generic (BURST_LEN: positive := 4);
  port (aclk, aresetn: in std_logic;
      bus_m: view master_hp of axi3_hp_t;
      done: out std_logic);
end entity;

architecture rtl of axi3_master_hp is
  constant AXLEN: unsigned(3 downto 0) := to_unsigned(BURST_LEN - 1, 4);
  type state_t is (S_AW, S_WRITE, S_B, S_AR, S_READ, S_DONE);
  signal state: state_t := S_AW;
  signal beat_cnt: unsigned(3 downto 0);
begin
  bus_m.awid    <= (others => '0');
  bus_m.awlen   <= std_logic_vector(AXLEN);
  bus_m.awsize  <= "011";  -- 8 bytes per beat (64-bit)
  bus_m.awburst <= "01"; bus_m.awlock <= "00";
  bus_m.awcache <= "0000"; bus_m.awprot <= "000"; bus_m.awqos <= "0000";
  bus_m.awuser  <= '0';

  bus_m.arid    <= (others => '0');
  bus_m.arlen   <= std_logic_vector(AXLEN);
  bus_m.arsize  <= "011";
  bus_m.arburst <= "01"; bus_m.arlock <= "00";
  bus_m.arcache <= "0000"; bus_m.arprot <= "000"; bus_m.arqos <= "0000";
  bus_m.aruser  <= '0';

  bus_m.wstrb <= (others => '1');
  bus_m.wid   <= (others => '0');  -- AXI3: write interleaving ID

  process (aclk, aresetn)
  begin
    if aresetn = '0' then
      state <= S_AW; done <= '0'; beat_cnt <= (others => '0');
      bus_m.awvalid <= '0'; bus_m.wvalid <= '0'; bus_m.bready <= '0';
      bus_m.arvalid <= '0'; bus_m.rready <= '0';
      bus_m.awaddr  <= (others => '0');
      bus_m.araddr  <= (others => '0');
    elsif rising_edge(aclk) then
      done <= '0';
      case state is
        when S_AW =>
          bus_m.awaddr <= (others => '0');
          bus_m.awvalid <= '1';
          if bus_m.awready = '1' then
            state <= S_WRITE; beat_cnt <= (others => '0'); end if;
        when S_WRITE =>
          bus_m.wvalid <= '1';
          bus_m.wlast <= '1' when beat_cnt = AXLEN else '0';
          bus_m.wdata <= X"A0000000" & X"00000000";
          if bus_m.wvalid = '1' and bus_m.wready = '1' then
            if beat_cnt = AXLEN then state <= S_B;
            else beat_cnt <= beat_cnt + 1; end if; end if;
        when S_B =>
          bus_m.bready <= '1';
          if bus_m.bvalid = '1' then
            bus_m.wvalid <= '0'; bus_m.awvalid <= '0';
            bus_m.bready <= '0'; state <= S_AR; beat_cnt <= (others => '0'); end if;
        when S_AR =>
          bus_m.araddr <= (0 => '1', others => '0');
          bus_m.arvalid <= '1';
          if bus_m.arready = '1' then
            state <= S_READ; beat_cnt <= (others => '0'); end if;
        when S_READ =>
          bus_m.rready <= '1';
          if bus_m.rvalid = '1' then
            if beat_cnt = AXLEN then state <= S_DONE;
            else beat_cnt <= beat_cnt + 1; end if; end if;
        when S_DONE =>
          done <= '1'; bus_m.arvalid <= '0'; bus_m.rready <= '0';
      end case; end if; end process;
end architecture;
