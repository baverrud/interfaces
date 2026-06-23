-- =====================================================================
-- axi4_pkg.vhd - AXI4 record + VHDL-2019 mode views
-- =====================================================================
-- All AXI4 channels in one record.  'master' = Manager (drives requests),
-- 'slave' = Subordinate (responder).
--
-- Generics on the package?  No — element widths are chosen per-signal
-- via the constraint list, exactly like axis_t in stream_pkg.
--
-- Signal declaration:
--   signal s : axi4_t(
--       tdata(31 downto 0),
--       taddr(31 downto 0),
--       tid(3 downto 0),
--       others => (0 downto 0)   -- 1-bit stubs for unused elements
--   );
-- =====================================================================
library ieee;
use ieee.std_logic_1164.all;

package axi4_pkg is

    type axi4_t is record
        -- Write Address Channel (master -> slave)
        awid     : std_logic_vector;
        awaddr   : std_logic_vector;
        awlen    : std_logic_vector(7  downto 0);
        awsize   : std_logic_vector(2  downto 0);
        awburst  : std_logic_vector(1  downto 0);
        awlock   : std_logic;
        awcache  : std_logic_vector(3  downto 0);
        awprot   : std_logic_vector(2  downto 0);
        awqos    : std_logic_vector(3  downto 0);
        awregion : std_logic_vector(3  downto 0);
        awuser   : std_logic_vector;
        awvalid  : std_logic;
        awready  : std_logic;

        -- Write Data Channel (master -> slave)
        wdata    : std_logic_vector;
        wstrb    : std_logic_vector;
        wlast    : std_logic;
        wuser    : std_logic_vector;
        wvalid   : std_logic;
        wready   : std_logic;

        -- Write Response Channel (slave -> master)
        bid      : std_logic_vector;
        bresp    : std_logic_vector(1  downto 0);
        buser    : std_logic_vector;
        bvalid   : std_logic;
        bready   : std_logic;

        -- Read Address Channel (master -> slave)
        arid     : std_logic_vector;
        araddr   : std_logic_vector;
        arlen    : std_logic_vector(7  downto 0);
        arsize   : std_logic_vector(2  downto 0);
        arburst  : std_logic_vector(1  downto 0);
        arlock   : std_logic;
        arcache  : std_logic_vector(3  downto 0);
        arprot   : std_logic_vector(2  downto 0);
        arqos    : std_logic_vector(3  downto 0);
        arregion : std_logic_vector(3  downto 0);
        aruser   : std_logic_vector;
        arvalid  : std_logic;
        arready  : std_logic;

        -- Read Data Channel (slave -> master)
        rid      : std_logic_vector;
        rdata    : std_logic_vector;
        rresp    : std_logic_vector(1  downto 0);
        rlast    : std_logic;
        ruser    : std_logic_vector;
        rvalid   : std_logic;
        rready   : std_logic;
    end record;

    -- master (Manager): drives write/read requests
    view master of axi4_t is
        -- write address
        awid, awaddr, awlen, awsize, awburst, awlock, awcache, awprot,
        awqos, awregion, awuser, awvalid : out;
        awready : in;
        -- write data
        wdata, wstrb, wlast, wuser, wvalid : out;
        wready : in;
        -- write response
        bid, bresp, buser, bvalid : in;
        bready : out;
        -- read address
        arid, araddr, arlen, arsize, arburst, arlock, arcache, arprot,
        arqos, arregion, aruser, arvalid : out;
        arready : in;
        -- read data
        rid, rdata, rresp, rlast, ruser, rvalid : in;
        rready : out;
    end view;

    -- slave (Subordinate): converse of master.
    alias slave is master'converse;

end package;
