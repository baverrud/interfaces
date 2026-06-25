-- =====================================================================
-- axi3_pkg.vhd - AXI3 record + VHDL-2019 mode views
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package axi3_pkg is

  type axi3_t is record
    -- Write Address
    awid     : std_logic_vector;
    awaddr   : std_logic_vector;
    awlen    : std_logic_vector(3  downto 0);
    awsize   : std_logic_vector(2  downto 0);
    awburst  : std_logic_vector(1  downto 0);
    awlock   : std_logic_vector(1  downto 0);
    awcache  : std_logic_vector(3  downto 0);
    awprot   : std_logic_vector(2  downto 0);
    awqos    : std_logic_vector(3  downto 0);
    awuser   : std_logic_vector;
    awvalid  : std_logic;
    awready  : std_logic;
    
    -- Write Data (AXI3 includes wid)
    wid      : std_logic_vector;
    wdata    : std_logic_vector;
    wstrb    : std_logic_vector;
    wlast    : std_logic;
    wuser    : std_logic_vector;
    wvalid   : std_logic;
    wready   : std_logic;
    
    -- Write Response
    bid      : std_logic_vector;
    bresp    : std_logic_vector(1  downto 0);
    buser    : std_logic_vector;
    bvalid   : std_logic;
    bready   : std_logic;
    
    -- Read Address
    arid     : std_logic_vector;
    araddr   : std_logic_vector;
    arlen    : std_logic_vector(3  downto 0);
    arsize   : std_logic_vector(2  downto 0);
    arburst  : std_logic_vector(1  downto 0);
    arlock   : std_logic_vector(1  downto 0);
    arcache  : std_logic_vector(3  downto 0);
    arprot   : std_logic_vector(2  downto 0);
    arqos    : std_logic_vector(3  downto 0);
    aruser   : std_logic_vector;
    arvalid  : std_logic;
    arready  : std_logic;
    
    -- Read Data
    rid      : std_logic_vector;
    rdata    : std_logic_vector;
    rresp    : std_logic_vector(1  downto 0);
    rlast    : std_logic;
    ruser    : std_logic_vector;
    rvalid   : std_logic;
    rready   : std_logic;
  end record;

  view master of axi3_t is
    awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot,
    awqos, awuser, awvalid : out; awready : in;
    wid, wdata, wstrb, wlast, wuser, wvalid : out; wready : in;
    bid, bresp, buser, bvalid : in; bready : out;
    arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot,
    arqos, aruser, arvalid : out; arready : in;
    rid, rdata, rresp, rlast, ruser, rvalid : in; rready : out;
  end view;

  alias slave is master'converse;

end package;
