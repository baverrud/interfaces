-- =====================================================================
-- i2c_pkg.vhd - I2C interface record + VHDL-2019 mode views
-- =====================================================================
-- The record contains only the SCL/SDA bidirectional signals.  No triplets
-- — those are internal implementation details of the controller.
-- Connects directly to the wrapper's inout I2C pins.
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package i2c_pkg is

  type i2c_t is record
    scl  : std_logic;   -- bidirectional (open-drain)
    sda  : std_logic;   -- bidirectional (open-drain)
  end record;

  view master of i2c_t is
    scl, sda : inout;
  end view;

  view slave of i2c_t is
    scl, sda : inout;
  end view;

end package;
