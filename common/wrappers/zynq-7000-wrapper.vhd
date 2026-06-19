--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2023.2 (win64) Build 4029153 Fri Oct 13 20:14:34 MDT 2023
--Date        : Fri Jun 19 10:03:03 2026
--Host        : S16 running 64-bit major release  (build 9200)
--Command     : generate_target ps01_wrapper.bd
--Design      : ps01_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity ps01_wrapper is
  port (
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    IIC_0_0_scl_io : inout STD_LOGIC;
    IIC_0_0_sda_io : inout STD_LOGIC;
    M00_AXI_0_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M00_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M01_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M01_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M01_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M01_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M01_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_GP0_0_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_0_arid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_0_arlen : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_0_arlock : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_0_arready : in STD_LOGIC;
    M_AXI_GP0_0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_0_arvalid : out STD_LOGIC;
    M_AXI_GP0_0_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_0_awid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_0_awlen : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_0_awlock : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_0_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_0_awready : in STD_LOGIC;
    M_AXI_GP0_0_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_0_awvalid : out STD_LOGIC;
    M_AXI_GP0_0_bid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_0_bready : out STD_LOGIC;
    M_AXI_GP0_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_0_bvalid : in STD_LOGIC;
    M_AXI_GP0_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_0_rid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_0_rlast : in STD_LOGIC;
    M_AXI_GP0_0_rready : out STD_LOGIC;
    M_AXI_GP0_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_0_rvalid : in STD_LOGIC;
    M_AXI_GP0_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_0_wid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_0_wlast : out STD_LOGIC;
    M_AXI_GP0_0_wready : in STD_LOGIC;
    M_AXI_GP0_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_0_wvalid : out STD_LOGIC;
    S_AXI_GP0_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_0_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_0_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_0_arready : out STD_LOGIC;
    S_AXI_GP0_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_0_arvalid : in STD_LOGIC;
    S_AXI_GP0_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_0_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_0_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_0_awready : out STD_LOGIC;
    S_AXI_GP0_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_0_awvalid : in STD_LOGIC;
    S_AXI_GP0_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_0_bready : in STD_LOGIC;
    S_AXI_GP0_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_0_bvalid : out STD_LOGIC;
    S_AXI_GP0_0_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_0_rlast : out STD_LOGIC;
    S_AXI_GP0_0_rready : in STD_LOGIC;
    S_AXI_GP0_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_0_rvalid : out STD_LOGIC;
    S_AXI_GP0_0_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_0_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_0_wlast : in STD_LOGIC;
    S_AXI_GP0_0_wready : out STD_LOGIC;
    S_AXI_GP0_0_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_0_wvalid : in STD_LOGIC;
    S_AXI_GP1_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP1_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP1_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP1_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP1_0_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP1_0_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP1_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP1_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP1_0_arready : out STD_LOGIC;
    S_AXI_GP1_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP1_0_arvalid : in STD_LOGIC;
    S_AXI_GP1_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP1_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP1_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP1_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP1_0_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP1_0_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP1_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP1_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP1_0_awready : out STD_LOGIC;
    S_AXI_GP1_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP1_0_awvalid : in STD_LOGIC;
    S_AXI_GP1_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP1_0_bready : in STD_LOGIC;
    S_AXI_GP1_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP1_0_bvalid : out STD_LOGIC;
    S_AXI_GP1_0_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP1_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP1_0_rlast : out STD_LOGIC;
    S_AXI_GP1_0_rready : in STD_LOGIC;
    S_AXI_GP1_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP1_0_rvalid : out STD_LOGIC;
    S_AXI_GP1_0_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP1_0_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP1_0_wlast : in STD_LOGIC;
    S_AXI_GP1_0_wready : out STD_LOGIC;
    S_AXI_GP1_0_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP1_0_wvalid : in STD_LOGIC;
    S_AXI_HP0_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP0_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_0_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_0_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_0_arready : out STD_LOGIC;
    S_AXI_HP0_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_0_arvalid : in STD_LOGIC;
    S_AXI_HP0_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP0_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_0_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_0_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_0_awready : out STD_LOGIC;
    S_AXI_HP0_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_0_awvalid : in STD_LOGIC;
    S_AXI_HP0_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_0_bready : in STD_LOGIC;
    S_AXI_HP0_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_0_bvalid : out STD_LOGIC;
    S_AXI_HP0_0_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP0_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_0_rlast : out STD_LOGIC;
    S_AXI_HP0_0_rready : in STD_LOGIC;
    S_AXI_HP0_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_0_rvalid : out STD_LOGIC;
    S_AXI_HP0_0_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP0_0_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_0_wlast : in STD_LOGIC;
    S_AXI_HP0_0_wready : out STD_LOGIC;
    S_AXI_HP0_0_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP0_0_wvalid : in STD_LOGIC;
    S_AXI_HP1_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP1_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_0_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_0_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_0_arready : out STD_LOGIC;
    S_AXI_HP1_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_0_arvalid : in STD_LOGIC;
    S_AXI_HP1_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP1_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_0_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_0_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_0_awready : out STD_LOGIC;
    S_AXI_HP1_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_0_awvalid : in STD_LOGIC;
    S_AXI_HP1_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_0_bready : in STD_LOGIC;
    S_AXI_HP1_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_0_bvalid : out STD_LOGIC;
    S_AXI_HP1_0_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP1_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_0_rlast : out STD_LOGIC;
    S_AXI_HP1_0_rready : in STD_LOGIC;
    S_AXI_HP1_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_0_rvalid : out STD_LOGIC;
    S_AXI_HP1_0_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP1_0_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_0_wlast : in STD_LOGIC;
    S_AXI_HP1_0_wready : out STD_LOGIC;
    S_AXI_HP1_0_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP1_0_wvalid : in STD_LOGIC;
    S_AXI_HP2_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP2_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_0_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_0_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_0_arready : out STD_LOGIC;
    S_AXI_HP2_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_0_arvalid : in STD_LOGIC;
    S_AXI_HP2_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP2_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_0_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_0_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_0_awready : out STD_LOGIC;
    S_AXI_HP2_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_0_awvalid : in STD_LOGIC;
    S_AXI_HP2_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_0_bready : in STD_LOGIC;
    S_AXI_HP2_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_0_bvalid : out STD_LOGIC;
    S_AXI_HP2_0_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP2_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_0_rlast : out STD_LOGIC;
    S_AXI_HP2_0_rready : in STD_LOGIC;
    S_AXI_HP2_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_0_rvalid : out STD_LOGIC;
    S_AXI_HP2_0_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP2_0_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_0_wlast : in STD_LOGIC;
    S_AXI_HP2_0_wready : out STD_LOGIC;
    S_AXI_HP2_0_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP2_0_wvalid : in STD_LOGIC;
    S_AXI_HP3_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP3_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_0_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_0_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_0_arready : out STD_LOGIC;
    S_AXI_HP3_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_0_arvalid : in STD_LOGIC;
    S_AXI_HP3_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP3_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_0_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_0_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_0_awready : out STD_LOGIC;
    S_AXI_HP3_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_0_awvalid : in STD_LOGIC;
    S_AXI_HP3_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_0_bready : in STD_LOGIC;
    S_AXI_HP3_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_0_bvalid : out STD_LOGIC;
    S_AXI_HP3_0_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP3_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_0_rlast : out STD_LOGIC;
    S_AXI_HP3_0_rready : in STD_LOGIC;
    S_AXI_HP3_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_0_rvalid : out STD_LOGIC;
    S_AXI_HP3_0_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP3_0_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_0_wlast : in STD_LOGIC;
    S_AXI_HP3_0_wready : out STD_LOGIC;
    S_AXI_HP3_0_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP3_0_wvalid : in STD_LOGIC;
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    ps_clk : out STD_LOGIC
  );
end ps01_wrapper;

architecture STRUCTURE of ps01_wrapper is
  component ps01 is
  port (
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    S_AXI_GP0_0_arready : out STD_LOGIC;
    S_AXI_GP0_0_awready : out STD_LOGIC;
    S_AXI_GP0_0_bvalid : out STD_LOGIC;
    S_AXI_GP0_0_rlast : out STD_LOGIC;
    S_AXI_GP0_0_rvalid : out STD_LOGIC;
    S_AXI_GP0_0_wready : out STD_LOGIC;
    S_AXI_GP0_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_0_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_0_arvalid : in STD_LOGIC;
    S_AXI_GP0_0_awvalid : in STD_LOGIC;
    S_AXI_GP0_0_bready : in STD_LOGIC;
    S_AXI_GP0_0_rready : in STD_LOGIC;
    S_AXI_GP0_0_wlast : in STD_LOGIC;
    S_AXI_GP0_0_wvalid : in STD_LOGIC;
    S_AXI_GP0_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_0_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_0_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP0_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP0_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_0_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP0_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_0_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_0_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_0_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP0_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP0_0_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP1_0_arready : out STD_LOGIC;
    S_AXI_GP1_0_awready : out STD_LOGIC;
    S_AXI_GP1_0_bvalid : out STD_LOGIC;
    S_AXI_GP1_0_rlast : out STD_LOGIC;
    S_AXI_GP1_0_rvalid : out STD_LOGIC;
    S_AXI_GP1_0_wready : out STD_LOGIC;
    S_AXI_GP1_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP1_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP1_0_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP1_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP1_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP1_0_arvalid : in STD_LOGIC;
    S_AXI_GP1_0_awvalid : in STD_LOGIC;
    S_AXI_GP1_0_bready : in STD_LOGIC;
    S_AXI_GP1_0_rready : in STD_LOGIC;
    S_AXI_GP1_0_wlast : in STD_LOGIC;
    S_AXI_GP1_0_wvalid : in STD_LOGIC;
    S_AXI_GP1_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP1_0_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP1_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP1_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP1_0_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_GP1_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP1_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP1_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_GP1_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP1_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP1_0_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_GP1_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP1_0_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP1_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP1_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP1_0_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP1_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP1_0_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_GP1_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP1_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_GP1_0_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_0_arready : out STD_LOGIC;
    S_AXI_HP0_0_awready : out STD_LOGIC;
    S_AXI_HP0_0_bvalid : out STD_LOGIC;
    S_AXI_HP0_0_rlast : out STD_LOGIC;
    S_AXI_HP0_0_rvalid : out STD_LOGIC;
    S_AXI_HP0_0_wready : out STD_LOGIC;
    S_AXI_HP0_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_0_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP0_0_arvalid : in STD_LOGIC;
    S_AXI_HP0_0_awvalid : in STD_LOGIC;
    S_AXI_HP0_0_bready : in STD_LOGIC;
    S_AXI_HP0_0_rready : in STD_LOGIC;
    S_AXI_HP0_0_wlast : in STD_LOGIC;
    S_AXI_HP0_0_wvalid : in STD_LOGIC;
    S_AXI_HP0_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_0_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_0_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP0_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP0_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_0_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_0_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_0_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_0_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP0_0_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP1_0_arready : out STD_LOGIC;
    S_AXI_HP1_0_awready : out STD_LOGIC;
    S_AXI_HP1_0_bvalid : out STD_LOGIC;
    S_AXI_HP1_0_rlast : out STD_LOGIC;
    S_AXI_HP1_0_rvalid : out STD_LOGIC;
    S_AXI_HP1_0_wready : out STD_LOGIC;
    S_AXI_HP1_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_0_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP1_0_arvalid : in STD_LOGIC;
    S_AXI_HP1_0_awvalid : in STD_LOGIC;
    S_AXI_HP1_0_bready : in STD_LOGIC;
    S_AXI_HP1_0_rready : in STD_LOGIC;
    S_AXI_HP1_0_wlast : in STD_LOGIC;
    S_AXI_HP1_0_wvalid : in STD_LOGIC;
    S_AXI_HP1_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_0_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_0_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP1_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP1_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_0_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_0_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_0_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_0_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP1_0_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP2_0_arready : out STD_LOGIC;
    S_AXI_HP2_0_awready : out STD_LOGIC;
    S_AXI_HP2_0_bvalid : out STD_LOGIC;
    S_AXI_HP2_0_rlast : out STD_LOGIC;
    S_AXI_HP2_0_rvalid : out STD_LOGIC;
    S_AXI_HP2_0_wready : out STD_LOGIC;
    S_AXI_HP2_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_0_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP2_0_arvalid : in STD_LOGIC;
    S_AXI_HP2_0_awvalid : in STD_LOGIC;
    S_AXI_HP2_0_bready : in STD_LOGIC;
    S_AXI_HP2_0_rready : in STD_LOGIC;
    S_AXI_HP2_0_wlast : in STD_LOGIC;
    S_AXI_HP2_0_wvalid : in STD_LOGIC;
    S_AXI_HP2_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_0_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_0_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP2_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP2_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_0_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_0_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_0_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_0_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP2_0_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP3_0_arready : out STD_LOGIC;
    S_AXI_HP3_0_awready : out STD_LOGIC;
    S_AXI_HP3_0_bvalid : out STD_LOGIC;
    S_AXI_HP3_0_rlast : out STD_LOGIC;
    S_AXI_HP3_0_rvalid : out STD_LOGIC;
    S_AXI_HP3_0_wready : out STD_LOGIC;
    S_AXI_HP3_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_0_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP3_0_arvalid : in STD_LOGIC;
    S_AXI_HP3_0_awvalid : in STD_LOGIC;
    S_AXI_HP3_0_bready : in STD_LOGIC;
    S_AXI_HP3_0_rready : in STD_LOGIC;
    S_AXI_HP3_0_wlast : in STD_LOGIC;
    S_AXI_HP3_0_wvalid : in STD_LOGIC;
    S_AXI_HP3_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_0_arlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_0_awlock : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_0_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP3_0_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    S_AXI_HP3_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_0_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_0_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_0_wid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_0_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    S_AXI_HP3_0_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_GP0_0_arvalid : out STD_LOGIC;
    M_AXI_GP0_0_awvalid : out STD_LOGIC;
    M_AXI_GP0_0_bready : out STD_LOGIC;
    M_AXI_GP0_0_rready : out STD_LOGIC;
    M_AXI_GP0_0_wlast : out STD_LOGIC;
    M_AXI_GP0_0_wvalid : out STD_LOGIC;
    M_AXI_GP0_0_arid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_0_awid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_0_wid : out STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_0_arlock : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_0_awlock : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_0_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_GP0_0_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_0_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_GP0_0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_0_arlen : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_0_awlen : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_0_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_GP0_0_arready : in STD_LOGIC;
    M_AXI_GP0_0_awready : in STD_LOGIC;
    M_AXI_GP0_0_bvalid : in STD_LOGIC;
    M_AXI_GP0_0_rlast : in STD_LOGIC;
    M_AXI_GP0_0_rvalid : in STD_LOGIC;
    M_AXI_GP0_0_wready : in STD_LOGIC;
    M_AXI_GP0_0_bid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_0_rid : in STD_LOGIC_VECTOR ( 11 downto 0 );
    M_AXI_GP0_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_GP0_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    ps_clk : out STD_LOGIC;
    M00_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M00_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M01_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M01_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M01_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M01_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M01_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    IIC_0_0_sda_i : in STD_LOGIC;
    IIC_0_0_sda_o : out STD_LOGIC;
    IIC_0_0_sda_t : out STD_LOGIC;
    IIC_0_0_scl_i : in STD_LOGIC;
    IIC_0_0_scl_o : out STD_LOGIC;
    IIC_0_0_scl_t : out STD_LOGIC
  );
  end component ps01;
  component IOBUF is
  port (
    I : in STD_LOGIC;
    O : out STD_LOGIC;
    T : in STD_LOGIC;
    IO : inout STD_LOGIC
  );
  end component IOBUF;
  signal IIC_0_0_scl_i : STD_LOGIC;
  signal IIC_0_0_scl_o : STD_LOGIC;
  signal IIC_0_0_scl_t : STD_LOGIC;
  signal IIC_0_0_sda_i : STD_LOGIC;
  signal IIC_0_0_sda_o : STD_LOGIC;
  signal IIC_0_0_sda_t : STD_LOGIC;
begin
IIC_0_0_scl_iobuf: component IOBUF
     port map (
      I => IIC_0_0_scl_o,
      IO => IIC_0_0_scl_io,
      O => IIC_0_0_scl_i,
      T => IIC_0_0_scl_t
    );
IIC_0_0_sda_iobuf: component IOBUF
     port map (
      I => IIC_0_0_sda_o,
      IO => IIC_0_0_sda_io,
      O => IIC_0_0_sda_i,
      T => IIC_0_0_sda_t
    );
ps01_i: component ps01
     port map (
      DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
      DDR_cas_n => DDR_cas_n,
      DDR_ck_n => DDR_ck_n,
      DDR_ck_p => DDR_ck_p,
      DDR_cke => DDR_cke,
      DDR_cs_n => DDR_cs_n,
      DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_odt => DDR_odt,
      DDR_ras_n => DDR_ras_n,
      DDR_reset_n => DDR_reset_n,
      DDR_we_n => DDR_we_n,
      FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
      IIC_0_0_scl_i => IIC_0_0_scl_i,
      IIC_0_0_scl_o => IIC_0_0_scl_o,
      IIC_0_0_scl_t => IIC_0_0_scl_t,
      IIC_0_0_sda_i => IIC_0_0_sda_i,
      IIC_0_0_sda_o => IIC_0_0_sda_o,
      IIC_0_0_sda_t => IIC_0_0_sda_t,
      M00_AXI_0_araddr(31 downto 0) => M00_AXI_0_araddr(31 downto 0),
      M00_AXI_0_arprot(2 downto 0) => M00_AXI_0_arprot(2 downto 0),
      M00_AXI_0_arready(0) => M00_AXI_0_arready(0),
      M00_AXI_0_arvalid(0) => M00_AXI_0_arvalid(0),
      M00_AXI_0_awaddr(31 downto 0) => M00_AXI_0_awaddr(31 downto 0),
      M00_AXI_0_awprot(2 downto 0) => M00_AXI_0_awprot(2 downto 0),
      M00_AXI_0_awready(0) => M00_AXI_0_awready(0),
      M00_AXI_0_awvalid(0) => M00_AXI_0_awvalid(0),
      M00_AXI_0_bready(0) => M00_AXI_0_bready(0),
      M00_AXI_0_bresp(1 downto 0) => M00_AXI_0_bresp(1 downto 0),
      M00_AXI_0_bvalid(0) => M00_AXI_0_bvalid(0),
      M00_AXI_0_rdata(31 downto 0) => M00_AXI_0_rdata(31 downto 0),
      M00_AXI_0_rready(0) => M00_AXI_0_rready(0),
      M00_AXI_0_rresp(1 downto 0) => M00_AXI_0_rresp(1 downto 0),
      M00_AXI_0_rvalid(0) => M00_AXI_0_rvalid(0),
      M00_AXI_0_wdata(31 downto 0) => M00_AXI_0_wdata(31 downto 0),
      M00_AXI_0_wready(0) => M00_AXI_0_wready(0),
      M00_AXI_0_wstrb(3 downto 0) => M00_AXI_0_wstrb(3 downto 0),
      M00_AXI_0_wvalid(0) => M00_AXI_0_wvalid(0),
      M01_AXI_0_araddr(31 downto 0) => M01_AXI_0_araddr(31 downto 0),
      M01_AXI_0_arprot(2 downto 0) => M01_AXI_0_arprot(2 downto 0),
      M01_AXI_0_arready(0) => M01_AXI_0_arready(0),
      M01_AXI_0_arvalid(0) => M01_AXI_0_arvalid(0),
      M01_AXI_0_awaddr(31 downto 0) => M01_AXI_0_awaddr(31 downto 0),
      M01_AXI_0_awprot(2 downto 0) => M01_AXI_0_awprot(2 downto 0),
      M01_AXI_0_awready(0) => M01_AXI_0_awready(0),
      M01_AXI_0_awvalid(0) => M01_AXI_0_awvalid(0),
      M01_AXI_0_bready(0) => M01_AXI_0_bready(0),
      M01_AXI_0_bresp(1 downto 0) => M01_AXI_0_bresp(1 downto 0),
      M01_AXI_0_bvalid(0) => M01_AXI_0_bvalid(0),
      M01_AXI_0_rdata(31 downto 0) => M01_AXI_0_rdata(31 downto 0),
      M01_AXI_0_rready(0) => M01_AXI_0_rready(0),
      M01_AXI_0_rresp(1 downto 0) => M01_AXI_0_rresp(1 downto 0),
      M01_AXI_0_rvalid(0) => M01_AXI_0_rvalid(0),
      M01_AXI_0_wdata(31 downto 0) => M01_AXI_0_wdata(31 downto 0),
      M01_AXI_0_wready(0) => M01_AXI_0_wready(0),
      M01_AXI_0_wstrb(3 downto 0) => M01_AXI_0_wstrb(3 downto 0),
      M01_AXI_0_wvalid(0) => M01_AXI_0_wvalid(0),
      M_AXI_GP0_0_araddr(31 downto 0) => M_AXI_GP0_0_araddr(31 downto 0),
      M_AXI_GP0_0_arburst(1 downto 0) => M_AXI_GP0_0_arburst(1 downto 0),
      M_AXI_GP0_0_arcache(3 downto 0) => M_AXI_GP0_0_arcache(3 downto 0),
      M_AXI_GP0_0_arid(11 downto 0) => M_AXI_GP0_0_arid(11 downto 0),
      M_AXI_GP0_0_arlen(3 downto 0) => M_AXI_GP0_0_arlen(3 downto 0),
      M_AXI_GP0_0_arlock(1 downto 0) => M_AXI_GP0_0_arlock(1 downto 0),
      M_AXI_GP0_0_arprot(2 downto 0) => M_AXI_GP0_0_arprot(2 downto 0),
      M_AXI_GP0_0_arqos(3 downto 0) => M_AXI_GP0_0_arqos(3 downto 0),
      M_AXI_GP0_0_arready => M_AXI_GP0_0_arready,
      M_AXI_GP0_0_arsize(2 downto 0) => M_AXI_GP0_0_arsize(2 downto 0),
      M_AXI_GP0_0_arvalid => M_AXI_GP0_0_arvalid,
      M_AXI_GP0_0_awaddr(31 downto 0) => M_AXI_GP0_0_awaddr(31 downto 0),
      M_AXI_GP0_0_awburst(1 downto 0) => M_AXI_GP0_0_awburst(1 downto 0),
      M_AXI_GP0_0_awcache(3 downto 0) => M_AXI_GP0_0_awcache(3 downto 0),
      M_AXI_GP0_0_awid(11 downto 0) => M_AXI_GP0_0_awid(11 downto 0),
      M_AXI_GP0_0_awlen(3 downto 0) => M_AXI_GP0_0_awlen(3 downto 0),
      M_AXI_GP0_0_awlock(1 downto 0) => M_AXI_GP0_0_awlock(1 downto 0),
      M_AXI_GP0_0_awprot(2 downto 0) => M_AXI_GP0_0_awprot(2 downto 0),
      M_AXI_GP0_0_awqos(3 downto 0) => M_AXI_GP0_0_awqos(3 downto 0),
      M_AXI_GP0_0_awready => M_AXI_GP0_0_awready,
      M_AXI_GP0_0_awsize(2 downto 0) => M_AXI_GP0_0_awsize(2 downto 0),
      M_AXI_GP0_0_awvalid => M_AXI_GP0_0_awvalid,
      M_AXI_GP0_0_bid(11 downto 0) => M_AXI_GP0_0_bid(11 downto 0),
      M_AXI_GP0_0_bready => M_AXI_GP0_0_bready,
      M_AXI_GP0_0_bresp(1 downto 0) => M_AXI_GP0_0_bresp(1 downto 0),
      M_AXI_GP0_0_bvalid => M_AXI_GP0_0_bvalid,
      M_AXI_GP0_0_rdata(31 downto 0) => M_AXI_GP0_0_rdata(31 downto 0),
      M_AXI_GP0_0_rid(11 downto 0) => M_AXI_GP0_0_rid(11 downto 0),
      M_AXI_GP0_0_rlast => M_AXI_GP0_0_rlast,
      M_AXI_GP0_0_rready => M_AXI_GP0_0_rready,
      M_AXI_GP0_0_rresp(1 downto 0) => M_AXI_GP0_0_rresp(1 downto 0),
      M_AXI_GP0_0_rvalid => M_AXI_GP0_0_rvalid,
      M_AXI_GP0_0_wdata(31 downto 0) => M_AXI_GP0_0_wdata(31 downto 0),
      M_AXI_GP0_0_wid(11 downto 0) => M_AXI_GP0_0_wid(11 downto 0),
      M_AXI_GP0_0_wlast => M_AXI_GP0_0_wlast,
      M_AXI_GP0_0_wready => M_AXI_GP0_0_wready,
      M_AXI_GP0_0_wstrb(3 downto 0) => M_AXI_GP0_0_wstrb(3 downto 0),
      M_AXI_GP0_0_wvalid => M_AXI_GP0_0_wvalid,
      S_AXI_GP0_0_araddr(31 downto 0) => S_AXI_GP0_0_araddr(31 downto 0),
      S_AXI_GP0_0_arburst(1 downto 0) => S_AXI_GP0_0_arburst(1 downto 0),
      S_AXI_GP0_0_arcache(3 downto 0) => S_AXI_GP0_0_arcache(3 downto 0),
      S_AXI_GP0_0_arid(5 downto 0) => S_AXI_GP0_0_arid(5 downto 0),
      S_AXI_GP0_0_arlen(3 downto 0) => S_AXI_GP0_0_arlen(3 downto 0),
      S_AXI_GP0_0_arlock(1 downto 0) => S_AXI_GP0_0_arlock(1 downto 0),
      S_AXI_GP0_0_arprot(2 downto 0) => S_AXI_GP0_0_arprot(2 downto 0),
      S_AXI_GP0_0_arqos(3 downto 0) => S_AXI_GP0_0_arqos(3 downto 0),
      S_AXI_GP0_0_arready => S_AXI_GP0_0_arready,
      S_AXI_GP0_0_arsize(2 downto 0) => S_AXI_GP0_0_arsize(2 downto 0),
      S_AXI_GP0_0_arvalid => S_AXI_GP0_0_arvalid,
      S_AXI_GP0_0_awaddr(31 downto 0) => S_AXI_GP0_0_awaddr(31 downto 0),
      S_AXI_GP0_0_awburst(1 downto 0) => S_AXI_GP0_0_awburst(1 downto 0),
      S_AXI_GP0_0_awcache(3 downto 0) => S_AXI_GP0_0_awcache(3 downto 0),
      S_AXI_GP0_0_awid(5 downto 0) => S_AXI_GP0_0_awid(5 downto 0),
      S_AXI_GP0_0_awlen(3 downto 0) => S_AXI_GP0_0_awlen(3 downto 0),
      S_AXI_GP0_0_awlock(1 downto 0) => S_AXI_GP0_0_awlock(1 downto 0),
      S_AXI_GP0_0_awprot(2 downto 0) => S_AXI_GP0_0_awprot(2 downto 0),
      S_AXI_GP0_0_awqos(3 downto 0) => S_AXI_GP0_0_awqos(3 downto 0),
      S_AXI_GP0_0_awready => S_AXI_GP0_0_awready,
      S_AXI_GP0_0_awsize(2 downto 0) => S_AXI_GP0_0_awsize(2 downto 0),
      S_AXI_GP0_0_awvalid => S_AXI_GP0_0_awvalid,
      S_AXI_GP0_0_bid(5 downto 0) => S_AXI_GP0_0_bid(5 downto 0),
      S_AXI_GP0_0_bready => S_AXI_GP0_0_bready,
      S_AXI_GP0_0_bresp(1 downto 0) => S_AXI_GP0_0_bresp(1 downto 0),
      S_AXI_GP0_0_bvalid => S_AXI_GP0_0_bvalid,
      S_AXI_GP0_0_rdata(31 downto 0) => S_AXI_GP0_0_rdata(31 downto 0),
      S_AXI_GP0_0_rid(5 downto 0) => S_AXI_GP0_0_rid(5 downto 0),
      S_AXI_GP0_0_rlast => S_AXI_GP0_0_rlast,
      S_AXI_GP0_0_rready => S_AXI_GP0_0_rready,
      S_AXI_GP0_0_rresp(1 downto 0) => S_AXI_GP0_0_rresp(1 downto 0),
      S_AXI_GP0_0_rvalid => S_AXI_GP0_0_rvalid,
      S_AXI_GP0_0_wdata(31 downto 0) => S_AXI_GP0_0_wdata(31 downto 0),
      S_AXI_GP0_0_wid(5 downto 0) => S_AXI_GP0_0_wid(5 downto 0),
      S_AXI_GP0_0_wlast => S_AXI_GP0_0_wlast,
      S_AXI_GP0_0_wready => S_AXI_GP0_0_wready,
      S_AXI_GP0_0_wstrb(3 downto 0) => S_AXI_GP0_0_wstrb(3 downto 0),
      S_AXI_GP0_0_wvalid => S_AXI_GP0_0_wvalid,
      S_AXI_GP1_0_araddr(31 downto 0) => S_AXI_GP1_0_araddr(31 downto 0),
      S_AXI_GP1_0_arburst(1 downto 0) => S_AXI_GP1_0_arburst(1 downto 0),
      S_AXI_GP1_0_arcache(3 downto 0) => S_AXI_GP1_0_arcache(3 downto 0),
      S_AXI_GP1_0_arid(5 downto 0) => S_AXI_GP1_0_arid(5 downto 0),
      S_AXI_GP1_0_arlen(3 downto 0) => S_AXI_GP1_0_arlen(3 downto 0),
      S_AXI_GP1_0_arlock(1 downto 0) => S_AXI_GP1_0_arlock(1 downto 0),
      S_AXI_GP1_0_arprot(2 downto 0) => S_AXI_GP1_0_arprot(2 downto 0),
      S_AXI_GP1_0_arqos(3 downto 0) => S_AXI_GP1_0_arqos(3 downto 0),
      S_AXI_GP1_0_arready => S_AXI_GP1_0_arready,
      S_AXI_GP1_0_arsize(2 downto 0) => S_AXI_GP1_0_arsize(2 downto 0),
      S_AXI_GP1_0_arvalid => S_AXI_GP1_0_arvalid,
      S_AXI_GP1_0_awaddr(31 downto 0) => S_AXI_GP1_0_awaddr(31 downto 0),
      S_AXI_GP1_0_awburst(1 downto 0) => S_AXI_GP1_0_awburst(1 downto 0),
      S_AXI_GP1_0_awcache(3 downto 0) => S_AXI_GP1_0_awcache(3 downto 0),
      S_AXI_GP1_0_awid(5 downto 0) => S_AXI_GP1_0_awid(5 downto 0),
      S_AXI_GP1_0_awlen(3 downto 0) => S_AXI_GP1_0_awlen(3 downto 0),
      S_AXI_GP1_0_awlock(1 downto 0) => S_AXI_GP1_0_awlock(1 downto 0),
      S_AXI_GP1_0_awprot(2 downto 0) => S_AXI_GP1_0_awprot(2 downto 0),
      S_AXI_GP1_0_awqos(3 downto 0) => S_AXI_GP1_0_awqos(3 downto 0),
      S_AXI_GP1_0_awready => S_AXI_GP1_0_awready,
      S_AXI_GP1_0_awsize(2 downto 0) => S_AXI_GP1_0_awsize(2 downto 0),
      S_AXI_GP1_0_awvalid => S_AXI_GP1_0_awvalid,
      S_AXI_GP1_0_bid(5 downto 0) => S_AXI_GP1_0_bid(5 downto 0),
      S_AXI_GP1_0_bready => S_AXI_GP1_0_bready,
      S_AXI_GP1_0_bresp(1 downto 0) => S_AXI_GP1_0_bresp(1 downto 0),
      S_AXI_GP1_0_bvalid => S_AXI_GP1_0_bvalid,
      S_AXI_GP1_0_rdata(31 downto 0) => S_AXI_GP1_0_rdata(31 downto 0),
      S_AXI_GP1_0_rid(5 downto 0) => S_AXI_GP1_0_rid(5 downto 0),
      S_AXI_GP1_0_rlast => S_AXI_GP1_0_rlast,
      S_AXI_GP1_0_rready => S_AXI_GP1_0_rready,
      S_AXI_GP1_0_rresp(1 downto 0) => S_AXI_GP1_0_rresp(1 downto 0),
      S_AXI_GP1_0_rvalid => S_AXI_GP1_0_rvalid,
      S_AXI_GP1_0_wdata(31 downto 0) => S_AXI_GP1_0_wdata(31 downto 0),
      S_AXI_GP1_0_wid(5 downto 0) => S_AXI_GP1_0_wid(5 downto 0),
      S_AXI_GP1_0_wlast => S_AXI_GP1_0_wlast,
      S_AXI_GP1_0_wready => S_AXI_GP1_0_wready,
      S_AXI_GP1_0_wstrb(3 downto 0) => S_AXI_GP1_0_wstrb(3 downto 0),
      S_AXI_GP1_0_wvalid => S_AXI_GP1_0_wvalid,
      S_AXI_HP0_0_araddr(31 downto 0) => S_AXI_HP0_0_araddr(31 downto 0),
      S_AXI_HP0_0_arburst(1 downto 0) => S_AXI_HP0_0_arburst(1 downto 0),
      S_AXI_HP0_0_arcache(3 downto 0) => S_AXI_HP0_0_arcache(3 downto 0),
      S_AXI_HP0_0_arid(5 downto 0) => S_AXI_HP0_0_arid(5 downto 0),
      S_AXI_HP0_0_arlen(3 downto 0) => S_AXI_HP0_0_arlen(3 downto 0),
      S_AXI_HP0_0_arlock(1 downto 0) => S_AXI_HP0_0_arlock(1 downto 0),
      S_AXI_HP0_0_arprot(2 downto 0) => S_AXI_HP0_0_arprot(2 downto 0),
      S_AXI_HP0_0_arqos(3 downto 0) => S_AXI_HP0_0_arqos(3 downto 0),
      S_AXI_HP0_0_arready => S_AXI_HP0_0_arready,
      S_AXI_HP0_0_arsize(2 downto 0) => S_AXI_HP0_0_arsize(2 downto 0),
      S_AXI_HP0_0_arvalid => S_AXI_HP0_0_arvalid,
      S_AXI_HP0_0_awaddr(31 downto 0) => S_AXI_HP0_0_awaddr(31 downto 0),
      S_AXI_HP0_0_awburst(1 downto 0) => S_AXI_HP0_0_awburst(1 downto 0),
      S_AXI_HP0_0_awcache(3 downto 0) => S_AXI_HP0_0_awcache(3 downto 0),
      S_AXI_HP0_0_awid(5 downto 0) => S_AXI_HP0_0_awid(5 downto 0),
      S_AXI_HP0_0_awlen(3 downto 0) => S_AXI_HP0_0_awlen(3 downto 0),
      S_AXI_HP0_0_awlock(1 downto 0) => S_AXI_HP0_0_awlock(1 downto 0),
      S_AXI_HP0_0_awprot(2 downto 0) => S_AXI_HP0_0_awprot(2 downto 0),
      S_AXI_HP0_0_awqos(3 downto 0) => S_AXI_HP0_0_awqos(3 downto 0),
      S_AXI_HP0_0_awready => S_AXI_HP0_0_awready,
      S_AXI_HP0_0_awsize(2 downto 0) => S_AXI_HP0_0_awsize(2 downto 0),
      S_AXI_HP0_0_awvalid => S_AXI_HP0_0_awvalid,
      S_AXI_HP0_0_bid(5 downto 0) => S_AXI_HP0_0_bid(5 downto 0),
      S_AXI_HP0_0_bready => S_AXI_HP0_0_bready,
      S_AXI_HP0_0_bresp(1 downto 0) => S_AXI_HP0_0_bresp(1 downto 0),
      S_AXI_HP0_0_bvalid => S_AXI_HP0_0_bvalid,
      S_AXI_HP0_0_rdata(63 downto 0) => S_AXI_HP0_0_rdata(63 downto 0),
      S_AXI_HP0_0_rid(5 downto 0) => S_AXI_HP0_0_rid(5 downto 0),
      S_AXI_HP0_0_rlast => S_AXI_HP0_0_rlast,
      S_AXI_HP0_0_rready => S_AXI_HP0_0_rready,
      S_AXI_HP0_0_rresp(1 downto 0) => S_AXI_HP0_0_rresp(1 downto 0),
      S_AXI_HP0_0_rvalid => S_AXI_HP0_0_rvalid,
      S_AXI_HP0_0_wdata(63 downto 0) => S_AXI_HP0_0_wdata(63 downto 0),
      S_AXI_HP0_0_wid(5 downto 0) => S_AXI_HP0_0_wid(5 downto 0),
      S_AXI_HP0_0_wlast => S_AXI_HP0_0_wlast,
      S_AXI_HP0_0_wready => S_AXI_HP0_0_wready,
      S_AXI_HP0_0_wstrb(7 downto 0) => S_AXI_HP0_0_wstrb(7 downto 0),
      S_AXI_HP0_0_wvalid => S_AXI_HP0_0_wvalid,
      S_AXI_HP1_0_araddr(31 downto 0) => S_AXI_HP1_0_araddr(31 downto 0),
      S_AXI_HP1_0_arburst(1 downto 0) => S_AXI_HP1_0_arburst(1 downto 0),
      S_AXI_HP1_0_arcache(3 downto 0) => S_AXI_HP1_0_arcache(3 downto 0),
      S_AXI_HP1_0_arid(5 downto 0) => S_AXI_HP1_0_arid(5 downto 0),
      S_AXI_HP1_0_arlen(3 downto 0) => S_AXI_HP1_0_arlen(3 downto 0),
      S_AXI_HP1_0_arlock(1 downto 0) => S_AXI_HP1_0_arlock(1 downto 0),
      S_AXI_HP1_0_arprot(2 downto 0) => S_AXI_HP1_0_arprot(2 downto 0),
      S_AXI_HP1_0_arqos(3 downto 0) => S_AXI_HP1_0_arqos(3 downto 0),
      S_AXI_HP1_0_arready => S_AXI_HP1_0_arready,
      S_AXI_HP1_0_arsize(2 downto 0) => S_AXI_HP1_0_arsize(2 downto 0),
      S_AXI_HP1_0_arvalid => S_AXI_HP1_0_arvalid,
      S_AXI_HP1_0_awaddr(31 downto 0) => S_AXI_HP1_0_awaddr(31 downto 0),
      S_AXI_HP1_0_awburst(1 downto 0) => S_AXI_HP1_0_awburst(1 downto 0),
      S_AXI_HP1_0_awcache(3 downto 0) => S_AXI_HP1_0_awcache(3 downto 0),
      S_AXI_HP1_0_awid(5 downto 0) => S_AXI_HP1_0_awid(5 downto 0),
      S_AXI_HP1_0_awlen(3 downto 0) => S_AXI_HP1_0_awlen(3 downto 0),
      S_AXI_HP1_0_awlock(1 downto 0) => S_AXI_HP1_0_awlock(1 downto 0),
      S_AXI_HP1_0_awprot(2 downto 0) => S_AXI_HP1_0_awprot(2 downto 0),
      S_AXI_HP1_0_awqos(3 downto 0) => S_AXI_HP1_0_awqos(3 downto 0),
      S_AXI_HP1_0_awready => S_AXI_HP1_0_awready,
      S_AXI_HP1_0_awsize(2 downto 0) => S_AXI_HP1_0_awsize(2 downto 0),
      S_AXI_HP1_0_awvalid => S_AXI_HP1_0_awvalid,
      S_AXI_HP1_0_bid(5 downto 0) => S_AXI_HP1_0_bid(5 downto 0),
      S_AXI_HP1_0_bready => S_AXI_HP1_0_bready,
      S_AXI_HP1_0_bresp(1 downto 0) => S_AXI_HP1_0_bresp(1 downto 0),
      S_AXI_HP1_0_bvalid => S_AXI_HP1_0_bvalid,
      S_AXI_HP1_0_rdata(63 downto 0) => S_AXI_HP1_0_rdata(63 downto 0),
      S_AXI_HP1_0_rid(5 downto 0) => S_AXI_HP1_0_rid(5 downto 0),
      S_AXI_HP1_0_rlast => S_AXI_HP1_0_rlast,
      S_AXI_HP1_0_rready => S_AXI_HP1_0_rready,
      S_AXI_HP1_0_rresp(1 downto 0) => S_AXI_HP1_0_rresp(1 downto 0),
      S_AXI_HP1_0_rvalid => S_AXI_HP1_0_rvalid,
      S_AXI_HP1_0_wdata(63 downto 0) => S_AXI_HP1_0_wdata(63 downto 0),
      S_AXI_HP1_0_wid(5 downto 0) => S_AXI_HP1_0_wid(5 downto 0),
      S_AXI_HP1_0_wlast => S_AXI_HP1_0_wlast,
      S_AXI_HP1_0_wready => S_AXI_HP1_0_wready,
      S_AXI_HP1_0_wstrb(7 downto 0) => S_AXI_HP1_0_wstrb(7 downto 0),
      S_AXI_HP1_0_wvalid => S_AXI_HP1_0_wvalid,
      S_AXI_HP2_0_araddr(31 downto 0) => S_AXI_HP2_0_araddr(31 downto 0),
      S_AXI_HP2_0_arburst(1 downto 0) => S_AXI_HP2_0_arburst(1 downto 0),
      S_AXI_HP2_0_arcache(3 downto 0) => S_AXI_HP2_0_arcache(3 downto 0),
      S_AXI_HP2_0_arid(5 downto 0) => S_AXI_HP2_0_arid(5 downto 0),
      S_AXI_HP2_0_arlen(3 downto 0) => S_AXI_HP2_0_arlen(3 downto 0),
      S_AXI_HP2_0_arlock(1 downto 0) => S_AXI_HP2_0_arlock(1 downto 0),
      S_AXI_HP2_0_arprot(2 downto 0) => S_AXI_HP2_0_arprot(2 downto 0),
      S_AXI_HP2_0_arqos(3 downto 0) => S_AXI_HP2_0_arqos(3 downto 0),
      S_AXI_HP2_0_arready => S_AXI_HP2_0_arready,
      S_AXI_HP2_0_arsize(2 downto 0) => S_AXI_HP2_0_arsize(2 downto 0),
      S_AXI_HP2_0_arvalid => S_AXI_HP2_0_arvalid,
      S_AXI_HP2_0_awaddr(31 downto 0) => S_AXI_HP2_0_awaddr(31 downto 0),
      S_AXI_HP2_0_awburst(1 downto 0) => S_AXI_HP2_0_awburst(1 downto 0),
      S_AXI_HP2_0_awcache(3 downto 0) => S_AXI_HP2_0_awcache(3 downto 0),
      S_AXI_HP2_0_awid(5 downto 0) => S_AXI_HP2_0_awid(5 downto 0),
      S_AXI_HP2_0_awlen(3 downto 0) => S_AXI_HP2_0_awlen(3 downto 0),
      S_AXI_HP2_0_awlock(1 downto 0) => S_AXI_HP2_0_awlock(1 downto 0),
      S_AXI_HP2_0_awprot(2 downto 0) => S_AXI_HP2_0_awprot(2 downto 0),
      S_AXI_HP2_0_awqos(3 downto 0) => S_AXI_HP2_0_awqos(3 downto 0),
      S_AXI_HP2_0_awready => S_AXI_HP2_0_awready,
      S_AXI_HP2_0_awsize(2 downto 0) => S_AXI_HP2_0_awsize(2 downto 0),
      S_AXI_HP2_0_awvalid => S_AXI_HP2_0_awvalid,
      S_AXI_HP2_0_bid(5 downto 0) => S_AXI_HP2_0_bid(5 downto 0),
      S_AXI_HP2_0_bready => S_AXI_HP2_0_bready,
      S_AXI_HP2_0_bresp(1 downto 0) => S_AXI_HP2_0_bresp(1 downto 0),
      S_AXI_HP2_0_bvalid => S_AXI_HP2_0_bvalid,
      S_AXI_HP2_0_rdata(63 downto 0) => S_AXI_HP2_0_rdata(63 downto 0),
      S_AXI_HP2_0_rid(5 downto 0) => S_AXI_HP2_0_rid(5 downto 0),
      S_AXI_HP2_0_rlast => S_AXI_HP2_0_rlast,
      S_AXI_HP2_0_rready => S_AXI_HP2_0_rready,
      S_AXI_HP2_0_rresp(1 downto 0) => S_AXI_HP2_0_rresp(1 downto 0),
      S_AXI_HP2_0_rvalid => S_AXI_HP2_0_rvalid,
      S_AXI_HP2_0_wdata(63 downto 0) => S_AXI_HP2_0_wdata(63 downto 0),
      S_AXI_HP2_0_wid(5 downto 0) => S_AXI_HP2_0_wid(5 downto 0),
      S_AXI_HP2_0_wlast => S_AXI_HP2_0_wlast,
      S_AXI_HP2_0_wready => S_AXI_HP2_0_wready,
      S_AXI_HP2_0_wstrb(7 downto 0) => S_AXI_HP2_0_wstrb(7 downto 0),
      S_AXI_HP2_0_wvalid => S_AXI_HP2_0_wvalid,
      S_AXI_HP3_0_araddr(31 downto 0) => S_AXI_HP3_0_araddr(31 downto 0),
      S_AXI_HP3_0_arburst(1 downto 0) => S_AXI_HP3_0_arburst(1 downto 0),
      S_AXI_HP3_0_arcache(3 downto 0) => S_AXI_HP3_0_arcache(3 downto 0),
      S_AXI_HP3_0_arid(5 downto 0) => S_AXI_HP3_0_arid(5 downto 0),
      S_AXI_HP3_0_arlen(3 downto 0) => S_AXI_HP3_0_arlen(3 downto 0),
      S_AXI_HP3_0_arlock(1 downto 0) => S_AXI_HP3_0_arlock(1 downto 0),
      S_AXI_HP3_0_arprot(2 downto 0) => S_AXI_HP3_0_arprot(2 downto 0),
      S_AXI_HP3_0_arqos(3 downto 0) => S_AXI_HP3_0_arqos(3 downto 0),
      S_AXI_HP3_0_arready => S_AXI_HP3_0_arready,
      S_AXI_HP3_0_arsize(2 downto 0) => S_AXI_HP3_0_arsize(2 downto 0),
      S_AXI_HP3_0_arvalid => S_AXI_HP3_0_arvalid,
      S_AXI_HP3_0_awaddr(31 downto 0) => S_AXI_HP3_0_awaddr(31 downto 0),
      S_AXI_HP3_0_awburst(1 downto 0) => S_AXI_HP3_0_awburst(1 downto 0),
      S_AXI_HP3_0_awcache(3 downto 0) => S_AXI_HP3_0_awcache(3 downto 0),
      S_AXI_HP3_0_awid(5 downto 0) => S_AXI_HP3_0_awid(5 downto 0),
      S_AXI_HP3_0_awlen(3 downto 0) => S_AXI_HP3_0_awlen(3 downto 0),
      S_AXI_HP3_0_awlock(1 downto 0) => S_AXI_HP3_0_awlock(1 downto 0),
      S_AXI_HP3_0_awprot(2 downto 0) => S_AXI_HP3_0_awprot(2 downto 0),
      S_AXI_HP3_0_awqos(3 downto 0) => S_AXI_HP3_0_awqos(3 downto 0),
      S_AXI_HP3_0_awready => S_AXI_HP3_0_awready,
      S_AXI_HP3_0_awsize(2 downto 0) => S_AXI_HP3_0_awsize(2 downto 0),
      S_AXI_HP3_0_awvalid => S_AXI_HP3_0_awvalid,
      S_AXI_HP3_0_bid(5 downto 0) => S_AXI_HP3_0_bid(5 downto 0),
      S_AXI_HP3_0_bready => S_AXI_HP3_0_bready,
      S_AXI_HP3_0_bresp(1 downto 0) => S_AXI_HP3_0_bresp(1 downto 0),
      S_AXI_HP3_0_bvalid => S_AXI_HP3_0_bvalid,
      S_AXI_HP3_0_rdata(63 downto 0) => S_AXI_HP3_0_rdata(63 downto 0),
      S_AXI_HP3_0_rid(5 downto 0) => S_AXI_HP3_0_rid(5 downto 0),
      S_AXI_HP3_0_rlast => S_AXI_HP3_0_rlast,
      S_AXI_HP3_0_rready => S_AXI_HP3_0_rready,
      S_AXI_HP3_0_rresp(1 downto 0) => S_AXI_HP3_0_rresp(1 downto 0),
      S_AXI_HP3_0_rvalid => S_AXI_HP3_0_rvalid,
      S_AXI_HP3_0_wdata(63 downto 0) => S_AXI_HP3_0_wdata(63 downto 0),
      S_AXI_HP3_0_wid(5 downto 0) => S_AXI_HP3_0_wid(5 downto 0),
      S_AXI_HP3_0_wlast => S_AXI_HP3_0_wlast,
      S_AXI_HP3_0_wready => S_AXI_HP3_0_wready,
      S_AXI_HP3_0_wstrb(7 downto 0) => S_AXI_HP3_0_wstrb(7 downto 0),
      S_AXI_HP3_0_wvalid => S_AXI_HP3_0_wvalid,
      peripheral_aresetn(0) => peripheral_aresetn(0),
      ps_clk => ps_clk
    );
end STRUCTURE;
