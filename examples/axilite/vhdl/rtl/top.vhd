-- =====================================================================
-- top.vhd - AXI4-Lite demo: test driver -> axil_reg
-- =====================================================================
-- The test driver writes DEADBEEF to the register, then reads it back.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.axilite_pkg.all;

entity top is
  port (
    aclk         : in  std_logic;
    aresetn      : in  std_logic;
    reg_readout  : out std_logic_vector(31 downto 0)
  );
end entity;

architecture rtl of top is
  signal bus : axilite_t(
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

  type state_t is (S_WA, S_WD, S_WR, S_RA, S_RD, S_DONE);
  signal state : state_t := S_WA;
  signal test_val : std_logic_vector(31 downto 0) := X"DEADBEEF";

begin

  -- Default tie-offs
  bus.awaddr <= (others => '0');
  bus.awuser <= (others => '0');
  bus.wuser  <= (others => '0');
  bus.aruser <= (others => '0');

  -- Test sequencer FSM (write DEADBEEF, then read it back)
  process (aclk, aresetn)
  begin
    if aresetn = '0' then
      state      <= S_WA;
      bus.awvalid <= '0';
      bus.wvalid  <= '0';
      bus.bready  <= '0';
      bus.arvalid <= '0';
      bus.rready  <= '0';

    elsif rising_edge(aclk) then
      case state is

        when S_WA =>          -- Write address phase
          if bus.awvalid = '0' then
            bus.awvalid <= '1';
          end if;
          if bus.awvalid = '1' and bus.awready = '1' then
            state <= S_WD;
          end if;

        when S_WD =>          -- Write data phase
          bus.wstrb <= (others => '1');
          bus.wdata <= test_val;
          if bus.wvalid = '0' then
            bus.wvalid <= '1';
          end if;
          if bus.wvalid = '1' and bus.wready = '1' then
            state <= S_WR;
          end if;

        when S_WR =>          -- Wait for write response
          if bus.bready = '0' then
            bus.bready <= '1';
          end if;
          if bus.bvalid = '1' and bus.bready = '1' then
            state <= S_RA;
          end if;

        when S_RA =>          -- Read address phase
          if bus.arvalid = '0' then
            bus.arvalid <= '1';
          end if;
          if bus.arvalid = '1' and bus.arready = '1' then
            state <= S_RD;
          end if;

        when S_RD =>          -- Read data phase
          if bus.rready = '0' then
            bus.rready <= '1';
          end if;
          if bus.rvalid = '1' and bus.rready = '1' then
            state <= S_DONE;
          end if;

        when S_DONE =>
          null;

      end case;
    end if;
  end process;

  reg_readout <= bus.rdata;

  u_reg : entity work.axil_reg
    port map (
      aclk    => aclk,
      aresetn => aresetn,
      s       => bus
    );

end architecture;
