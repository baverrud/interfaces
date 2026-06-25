-- =====================================================================
-- axilite_master_m40.vhd - AXI4-Lite master (axilite_m40_t composite)
-- =====================================================================
-- Demonstrates the fully constrained axilite_m40_t bus view (40-bit
-- address, 32-bit data) matching the Zynq MPSoC M00_AXI..M07_AXI
-- AXI4-Lite master ports.
--
-- Uses a single composite port (bus_m) with the master_m40 view.
-- Performs a write-then-read sequence: AW -> W -> B -> AR -> R -> done.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axilite_pkg.all;

entity axilite_master_m40 is
  port (aclk, aresetn: in std_logic;
      bus_m: view master_m40 of axilite_m40_t;
      rd_data: out std_logic_vector(31 downto 0); rd_valid, done: out std_logic);
end entity;

architecture rtl of axilite_master_m40 is
  type state_t is (S_AW, S_WRITE, S_B, S_AR, S_READ, S_DONE);
  signal state: state_t := S_AW;
begin
  -- ===================================================================
  -- Concurrent assignments: fixed sideband signals
  -- ===================================================================
  bus_m.awprot <= "000";
  bus_m.arprot <= "000";
  bus_m.awuser <= '0';
  bus_m.aruser <= '0';
  bus_m.wuser  <= '0';
  bus_m.wstrb  <= (others => '1');

  -- ===================================================================
  -- FSM: write (AW -> W -> B) then read (AR -> R) -> done
  -- ===================================================================
  process (aclk, aresetn)
  begin
    if aresetn = '0' then
      state <= S_AW; done <= '0'; rd_valid <= '0';
      bus_m.awvalid <= '0'; bus_m.wvalid <= '0'; bus_m.bready <= '0';
      bus_m.arvalid <= '0'; bus_m.rready <= '0';
      bus_m.awaddr  <= (others => '0');
      bus_m.araddr  <= (others => '0');
      rd_data       <= (others => '0');
    elsif rising_edge(aclk) then
      done <= '0'; rd_valid <= '0';
      case state is
        -- Write address: drive AW channel at address 0
        when S_AW =>
          bus_m.awaddr <= (others => '0');
          if bus_m.awvalid = '0' then bus_m.awvalid <= '1'; end if;
          if bus_m.awvalid = '1' and bus_m.awready = '1' then
            state <= S_WRITE; end if;
        -- Write data: send single beat with pattern 0xA5A5A5A5
        when S_WRITE =>
          if bus_m.wvalid = '0' then
            bus_m.wvalid <= '1';
            bus_m.wdata  <= x"A5A5A5A5";
          elsif bus_m.wvalid = '1' and bus_m.wready = '1' then
            state <= S_B; end if;
        -- Write response: wait for bvalid, then proceed to read
        when S_B =>
          if bus_m.bready = '0' then bus_m.bready <= '1'; end if;
          if bus_m.bvalid = '1' and bus_m.bready = '1' then
            bus_m.wvalid <= '0'; bus_m.awvalid <= '0'; state <= S_AR; end if;
        -- Read address: drive AR channel at address 0
        when S_AR =>
          bus_m.araddr <= (others => '0');
          if bus_m.arvalid = '0' then bus_m.arvalid <= '1'; end if;
          if bus_m.arvalid = '1' and bus_m.arready = '1' then
            state <= S_READ; end if;
        -- Read data: capture the single beat
        when S_READ =>
          if bus_m.rready = '0' then bus_m.rready <= '1'; end if;
          if bus_m.rvalid = '1' and bus_m.rready = '1' then
            rd_valid <= '1'; rd_data <= bus_m.rdata;
            state <= S_DONE; end if;
        -- Done: assert done pulse, idle all handshakes
        when S_DONE =>
          done <= '1'; bus_m.arvalid <= '0'; bus_m.rready <= '0';
      end case; end if; end process;
end architecture;
