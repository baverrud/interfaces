-- =====================================================================
-- top.vhd - UART demo: transmitter -> receiver (VHDL-2019)
-- =====================================================================
-- Clean top level: instantiates the UART interface, a transmitter
-- (TX sequencer + RX capture), and a receiver (RX capture + TX echo).
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;
use work.uart_pkg.all;

entity top is
  generic (
    BAUD_DIV : positive := 8           -- system clocks per UART bit
  );
  port (
    clk, rstn : in  std_logic;         -- system clock / active-low reset
    done      : out std_logic          -- high when TX+RX cycle completes
  );
end entity;

architecture rtl of top is

  -- UART interconnect (no unconstrained elements)
  signal b : uart_t;

begin

  -- transmitter: sends 0xA5, then listens for echo
  u_tx : entity work.uart_tx
    generic map (
      BAUD_DIV => BAUD_DIV
    )
    port map (
      clk  => clk,
      rstn => rstn,
      m    => b,
      done => done
    );

  -- receiver: captures byte, echoes it back
  u_rx : entity work.uart_rx
    generic map (
      BAUD_DIV => BAUD_DIV
    )
    port map (
      clk  => clk,
      rstn => rstn,
      s    => b
    );

end architecture;    -- of top
