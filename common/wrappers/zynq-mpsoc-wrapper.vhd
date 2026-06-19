--Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
--Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2025.2 (win64) Build 6299465 Fri Nov 14 19:35:11 GMT 2025
--Date        : Fri Jun 12 14:40:18 2026
--Host        : S16 running 64-bit major release  (build 9200)
--Command     : generate_target ps02_wrapper.bd
--Design      : ps02_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity ps02_wrapper is
  port (
    IIC_0_0_scl_io : inout STD_LOGIC;
    IIC_0_0_sda_io : inout STD_LOGIC;
    M00_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M00_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
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
    M01_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M01_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M01_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
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
    M02_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M02_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M02_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M02_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M02_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M02_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M02_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M02_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M02_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M02_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M03_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M03_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M03_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M03_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M03_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M03_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M03_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M03_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M03_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M04_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M04_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M04_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M04_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M04_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M04_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M04_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M04_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M04_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M05_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M05_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M05_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M05_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M05_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M06_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M06_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M06_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M06_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M06_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M06_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M06_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M06_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M06_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M07_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M07_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M07_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M07_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M07_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M07_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M07_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M07_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M07_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HPM0_FPD_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HPM0_FPD_0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_FPD_0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_FPD_0_arid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_FPD_0_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HPM0_FPD_0_arlock : out STD_LOGIC;
    M_AXI_HPM0_FPD_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_FPD_0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_FPD_0_arready : in STD_LOGIC;
    M_AXI_HPM0_FPD_0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_FPD_0_aruser : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_FPD_0_arvalid : out STD_LOGIC;
    M_AXI_HPM0_FPD_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HPM0_FPD_0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_FPD_0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_FPD_0_awid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_FPD_0_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HPM0_FPD_0_awlock : out STD_LOGIC;
    M_AXI_HPM0_FPD_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_FPD_0_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_FPD_0_awready : in STD_LOGIC;
    M_AXI_HPM0_FPD_0_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_FPD_0_awuser : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_FPD_0_awvalid : out STD_LOGIC;
    M_AXI_HPM0_FPD_0_bid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_FPD_0_bready : out STD_LOGIC;
    M_AXI_HPM0_FPD_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_FPD_0_bvalid : in STD_LOGIC;
    M_AXI_HPM0_FPD_0_rdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    M_AXI_HPM0_FPD_0_rid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_FPD_0_rlast : in STD_LOGIC;
    M_AXI_HPM0_FPD_0_rready : out STD_LOGIC;
    M_AXI_HPM0_FPD_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_FPD_0_rvalid : in STD_LOGIC;
    M_AXI_HPM0_FPD_0_wdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    M_AXI_HPM0_FPD_0_wlast : out STD_LOGIC;
    M_AXI_HPM0_FPD_0_wready : in STD_LOGIC;
    M_AXI_HPM0_FPD_0_wstrb : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_FPD_0_wvalid : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HPM0_LPD_0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_LPD_0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_LPD_0_arid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_LPD_0_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HPM0_LPD_0_arlock : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_LPD_0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_LPD_0_arready : in STD_LOGIC;
    M_AXI_HPM0_LPD_0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_LPD_0_aruser : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_LPD_0_arvalid : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HPM0_LPD_0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_LPD_0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_LPD_0_awid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_LPD_0_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HPM0_LPD_0_awlock : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_LPD_0_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_LPD_0_awready : in STD_LOGIC;
    M_AXI_HPM0_LPD_0_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_LPD_0_awuser : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_LPD_0_awvalid : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_bid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_LPD_0_bready : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_LPD_0_bvalid : in STD_LOGIC;
    M_AXI_HPM0_LPD_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_HPM0_LPD_0_rid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_LPD_0_rlast : in STD_LOGIC;
    M_AXI_HPM0_LPD_0_rready : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_LPD_0_rvalid : in STD_LOGIC;
    M_AXI_HPM0_LPD_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_HPM0_LPD_0_wlast : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_wready : in STD_LOGIC;
    M_AXI_HPM0_LPD_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_LPD_0_wvalid : out STD_LOGIC;
    S_AXI_HP0_FPD_0_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP0_FPD_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_FPD_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_FPD_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_FPD_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP0_FPD_0_arlock : in STD_LOGIC;
    S_AXI_HP0_FPD_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_FPD_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_FPD_0_arready : out STD_LOGIC;
    S_AXI_HP0_FPD_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_FPD_0_aruser : in STD_LOGIC;
    S_AXI_HP0_FPD_0_arvalid : in STD_LOGIC;
    S_AXI_HP0_FPD_0_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP0_FPD_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_FPD_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_FPD_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_FPD_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP0_FPD_0_awlock : in STD_LOGIC;
    S_AXI_HP0_FPD_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_FPD_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_FPD_0_awready : out STD_LOGIC;
    S_AXI_HP0_FPD_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_FPD_0_awuser : in STD_LOGIC;
    S_AXI_HP0_FPD_0_awvalid : in STD_LOGIC;
    S_AXI_HP0_FPD_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_FPD_0_bready : in STD_LOGIC;
    S_AXI_HP0_FPD_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_FPD_0_bvalid : out STD_LOGIC;
    S_AXI_HP0_FPD_0_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP0_FPD_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_FPD_0_rlast : out STD_LOGIC;
    S_AXI_HP0_FPD_0_rready : in STD_LOGIC;
    S_AXI_HP0_FPD_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_FPD_0_rvalid : out STD_LOGIC;
    S_AXI_HP0_FPD_0_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP0_FPD_0_wlast : in STD_LOGIC;
    S_AXI_HP0_FPD_0_wready : out STD_LOGIC;
    S_AXI_HP0_FPD_0_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_HP0_FPD_0_wvalid : in STD_LOGIC;
    S_AXI_HP1_FPD_0_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP1_FPD_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_FPD_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_FPD_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_FPD_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP1_FPD_0_arlock : in STD_LOGIC;
    S_AXI_HP1_FPD_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_FPD_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_FPD_0_arready : out STD_LOGIC;
    S_AXI_HP1_FPD_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_FPD_0_aruser : in STD_LOGIC;
    S_AXI_HP1_FPD_0_arvalid : in STD_LOGIC;
    S_AXI_HP1_FPD_0_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP1_FPD_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_FPD_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_FPD_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_FPD_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP1_FPD_0_awlock : in STD_LOGIC;
    S_AXI_HP1_FPD_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_FPD_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_FPD_0_awready : out STD_LOGIC;
    S_AXI_HP1_FPD_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_FPD_0_awuser : in STD_LOGIC;
    S_AXI_HP1_FPD_0_awvalid : in STD_LOGIC;
    S_AXI_HP1_FPD_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_FPD_0_bready : in STD_LOGIC;
    S_AXI_HP1_FPD_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_FPD_0_bvalid : out STD_LOGIC;
    S_AXI_HP1_FPD_0_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP1_FPD_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_FPD_0_rlast : out STD_LOGIC;
    S_AXI_HP1_FPD_0_rready : in STD_LOGIC;
    S_AXI_HP1_FPD_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_FPD_0_rvalid : out STD_LOGIC;
    S_AXI_HP1_FPD_0_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP1_FPD_0_wlast : in STD_LOGIC;
    S_AXI_HP1_FPD_0_wready : out STD_LOGIC;
    S_AXI_HP1_FPD_0_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_HP1_FPD_0_wvalid : in STD_LOGIC;
    S_AXI_HP2_FPD_0_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP2_FPD_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_FPD_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_FPD_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_FPD_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP2_FPD_0_arlock : in STD_LOGIC;
    S_AXI_HP2_FPD_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_FPD_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_FPD_0_arready : out STD_LOGIC;
    S_AXI_HP2_FPD_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_FPD_0_aruser : in STD_LOGIC;
    S_AXI_HP2_FPD_0_arvalid : in STD_LOGIC;
    S_AXI_HP2_FPD_0_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP2_FPD_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_FPD_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_FPD_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_FPD_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP2_FPD_0_awlock : in STD_LOGIC;
    S_AXI_HP2_FPD_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_FPD_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_FPD_0_awready : out STD_LOGIC;
    S_AXI_HP2_FPD_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_FPD_0_awuser : in STD_LOGIC;
    S_AXI_HP2_FPD_0_awvalid : in STD_LOGIC;
    S_AXI_HP2_FPD_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_FPD_0_bready : in STD_LOGIC;
    S_AXI_HP2_FPD_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_FPD_0_bvalid : out STD_LOGIC;
    S_AXI_HP2_FPD_0_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP2_FPD_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_FPD_0_rlast : out STD_LOGIC;
    S_AXI_HP2_FPD_0_rready : in STD_LOGIC;
    S_AXI_HP2_FPD_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_FPD_0_rvalid : out STD_LOGIC;
    S_AXI_HP2_FPD_0_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP2_FPD_0_wlast : in STD_LOGIC;
    S_AXI_HP2_FPD_0_wready : out STD_LOGIC;
    S_AXI_HP2_FPD_0_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_HP2_FPD_0_wvalid : in STD_LOGIC;
    S_AXI_HP3_FPD_0_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP3_FPD_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_FPD_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_FPD_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_FPD_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP3_FPD_0_arlock : in STD_LOGIC;
    S_AXI_HP3_FPD_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_FPD_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_FPD_0_arready : out STD_LOGIC;
    S_AXI_HP3_FPD_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_FPD_0_aruser : in STD_LOGIC;
    S_AXI_HP3_FPD_0_arvalid : in STD_LOGIC;
    S_AXI_HP3_FPD_0_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP3_FPD_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_FPD_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_FPD_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_FPD_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP3_FPD_0_awlock : in STD_LOGIC;
    S_AXI_HP3_FPD_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_FPD_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_FPD_0_awready : out STD_LOGIC;
    S_AXI_HP3_FPD_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_FPD_0_awuser : in STD_LOGIC;
    S_AXI_HP3_FPD_0_awvalid : in STD_LOGIC;
    S_AXI_HP3_FPD_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_FPD_0_bready : in STD_LOGIC;
    S_AXI_HP3_FPD_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_FPD_0_bvalid : out STD_LOGIC;
    S_AXI_HP3_FPD_0_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP3_FPD_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_FPD_0_rlast : out STD_LOGIC;
    S_AXI_HP3_FPD_0_rready : in STD_LOGIC;
    S_AXI_HP3_FPD_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_FPD_0_rvalid : out STD_LOGIC;
    S_AXI_HP3_FPD_0_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP3_FPD_0_wlast : in STD_LOGIC;
    S_AXI_HP3_FPD_0_wready : out STD_LOGIC;
    S_AXI_HP3_FPD_0_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_HP3_FPD_0_wvalid : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HPC0_FPD_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC0_FPD_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC0_FPD_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC0_FPD_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HPC0_FPD_0_arlock : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC0_FPD_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC0_FPD_0_arready : out STD_LOGIC;
    S_AXI_HPC0_FPD_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC0_FPD_0_aruser : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_arvalid : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HPC0_FPD_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC0_FPD_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC0_FPD_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC0_FPD_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HPC0_FPD_0_awlock : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC0_FPD_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC0_FPD_0_awready : out STD_LOGIC;
    S_AXI_HPC0_FPD_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC0_FPD_0_awuser : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_awvalid : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC0_FPD_0_bready : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC0_FPD_0_bvalid : out STD_LOGIC;
    S_AXI_HPC0_FPD_0_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HPC0_FPD_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC0_FPD_0_rlast : out STD_LOGIC;
    S_AXI_HPC0_FPD_0_rready : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC0_FPD_0_rvalid : out STD_LOGIC;
    S_AXI_HPC0_FPD_0_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HPC0_FPD_0_wlast : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_wready : out STD_LOGIC;
    S_AXI_HPC0_FPD_0_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_HPC0_FPD_0_wvalid : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HPC1_FPD_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC1_FPD_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC1_FPD_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC1_FPD_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HPC1_FPD_0_arlock : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC1_FPD_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC1_FPD_0_arready : out STD_LOGIC;
    S_AXI_HPC1_FPD_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC1_FPD_0_aruser : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_arvalid : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HPC1_FPD_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC1_FPD_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC1_FPD_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC1_FPD_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HPC1_FPD_0_awlock : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC1_FPD_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC1_FPD_0_awready : out STD_LOGIC;
    S_AXI_HPC1_FPD_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC1_FPD_0_awuser : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_awvalid : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC1_FPD_0_bready : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC1_FPD_0_bvalid : out STD_LOGIC;
    S_AXI_HPC1_FPD_0_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HPC1_FPD_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC1_FPD_0_rlast : out STD_LOGIC;
    S_AXI_HPC1_FPD_0_rready : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC1_FPD_0_rvalid : out STD_LOGIC;
    S_AXI_HPC1_FPD_0_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HPC1_FPD_0_wlast : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_wready : out STD_LOGIC;
    S_AXI_HPC1_FPD_0_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_HPC1_FPD_0_wvalid : in STD_LOGIC;
    S_AXI_LPD_0_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_LPD_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_LPD_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_LPD_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_LPD_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_LPD_0_arlock : in STD_LOGIC;
    S_AXI_LPD_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_LPD_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_LPD_0_arready : out STD_LOGIC;
    S_AXI_LPD_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_LPD_0_aruser : in STD_LOGIC;
    S_AXI_LPD_0_arvalid : in STD_LOGIC;
    S_AXI_LPD_0_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_LPD_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_LPD_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_LPD_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_LPD_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_LPD_0_awlock : in STD_LOGIC;
    S_AXI_LPD_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_LPD_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_LPD_0_awready : out STD_LOGIC;
    S_AXI_LPD_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_LPD_0_awuser : in STD_LOGIC;
    S_AXI_LPD_0_awvalid : in STD_LOGIC;
    S_AXI_LPD_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_LPD_0_bready : in STD_LOGIC;
    S_AXI_LPD_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_LPD_0_bvalid : out STD_LOGIC;
    S_AXI_LPD_0_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_LPD_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_LPD_0_rlast : out STD_LOGIC;
    S_AXI_LPD_0_rready : in STD_LOGIC;
    S_AXI_LPD_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_LPD_0_rvalid : out STD_LOGIC;
    S_AXI_LPD_0_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_LPD_0_wlast : in STD_LOGIC;
    S_AXI_LPD_0_wready : out STD_LOGIC;
    S_AXI_LPD_0_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_LPD_0_wvalid : in STD_LOGIC;
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    pl_clk0 : out STD_LOGIC;
    pl_ps_irq0_0 : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
end ps02_wrapper;

architecture STRUCTURE of ps02_wrapper is
  component ps02 is
  port (
    M00_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
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
    M00_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M00_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M00_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M00_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M00_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M00_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
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
    M01_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M01_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M01_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M01_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M01_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M01_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M_AXI_HPM0_FPD_0_awid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_FPD_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HPM0_FPD_0_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HPM0_FPD_0_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_FPD_0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_FPD_0_awlock : out STD_LOGIC;
    M_AXI_HPM0_FPD_0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_FPD_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_FPD_0_awvalid : out STD_LOGIC;
    M_AXI_HPM0_FPD_0_awuser : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_FPD_0_awready : in STD_LOGIC;
    M_AXI_HPM0_FPD_0_wdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    M_AXI_HPM0_FPD_0_wstrb : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_FPD_0_wlast : out STD_LOGIC;
    M_AXI_HPM0_FPD_0_wvalid : out STD_LOGIC;
    M_AXI_HPM0_FPD_0_wready : in STD_LOGIC;
    M_AXI_HPM0_FPD_0_bid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_FPD_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_FPD_0_bvalid : in STD_LOGIC;
    M_AXI_HPM0_FPD_0_bready : out STD_LOGIC;
    M_AXI_HPM0_FPD_0_arid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_FPD_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HPM0_FPD_0_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HPM0_FPD_0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_FPD_0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_FPD_0_arlock : out STD_LOGIC;
    M_AXI_HPM0_FPD_0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_FPD_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_FPD_0_arvalid : out STD_LOGIC;
    M_AXI_HPM0_FPD_0_aruser : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_FPD_0_arready : in STD_LOGIC;
    M_AXI_HPM0_FPD_0_rid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_FPD_0_rdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    M_AXI_HPM0_FPD_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_FPD_0_rlast : in STD_LOGIC;
    M_AXI_HPM0_FPD_0_rvalid : in STD_LOGIC;
    M_AXI_HPM0_FPD_0_rready : out STD_LOGIC;
    M_AXI_HPM0_FPD_0_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_FPD_0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    IIC_0_0_scl_i : in STD_LOGIC;
    IIC_0_0_scl_o : out STD_LOGIC;
    IIC_0_0_scl_t : out STD_LOGIC;
    IIC_0_0_sda_i : in STD_LOGIC;
    IIC_0_0_sda_o : out STD_LOGIC;
    IIC_0_0_sda_t : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_awid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_LPD_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HPM0_LPD_0_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HPM0_LPD_0_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_LPD_0_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_LPD_0_awlock : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_LPD_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_LPD_0_awvalid : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_awuser : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_LPD_0_awready : in STD_LOGIC;
    M_AXI_HPM0_LPD_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_HPM0_LPD_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_LPD_0_wlast : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_wvalid : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_wready : in STD_LOGIC;
    M_AXI_HPM0_LPD_0_bid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_LPD_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_LPD_0_bvalid : in STD_LOGIC;
    M_AXI_HPM0_LPD_0_bready : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_arid : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_LPD_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M_AXI_HPM0_LPD_0_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
    M_AXI_HPM0_LPD_0_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_LPD_0_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_LPD_0_arlock : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_LPD_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M_AXI_HPM0_LPD_0_arvalid : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_aruser : out STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_LPD_0_arready : in STD_LOGIC;
    M_AXI_HPM0_LPD_0_rid : in STD_LOGIC_VECTOR ( 15 downto 0 );
    M_AXI_HPM0_LPD_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M_AXI_HPM0_LPD_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M_AXI_HPM0_LPD_0_rlast : in STD_LOGIC;
    M_AXI_HPM0_LPD_0_rvalid : in STD_LOGIC;
    M_AXI_HPM0_LPD_0_rready : out STD_LOGIC;
    M_AXI_HPM0_LPD_0_awqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M_AXI_HPM0_LPD_0_arqos : out STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC0_FPD_0_aruser : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_awuser : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC0_FPD_0_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HPC0_FPD_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HPC0_FPD_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC0_FPD_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC0_FPD_0_awlock : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC0_FPD_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC0_FPD_0_awvalid : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_awready : out STD_LOGIC;
    S_AXI_HPC0_FPD_0_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HPC0_FPD_0_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_HPC0_FPD_0_wlast : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_wvalid : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_wready : out STD_LOGIC;
    S_AXI_HPC0_FPD_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC0_FPD_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC0_FPD_0_bvalid : out STD_LOGIC;
    S_AXI_HPC0_FPD_0_bready : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC0_FPD_0_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HPC0_FPD_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HPC0_FPD_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC0_FPD_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC0_FPD_0_arlock : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC0_FPD_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC0_FPD_0_arvalid : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_arready : out STD_LOGIC;
    S_AXI_HPC0_FPD_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC0_FPD_0_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HPC0_FPD_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC0_FPD_0_rlast : out STD_LOGIC;
    S_AXI_HPC0_FPD_0_rvalid : out STD_LOGIC;
    S_AXI_HPC0_FPD_0_rready : in STD_LOGIC;
    S_AXI_HPC0_FPD_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC0_FPD_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC1_FPD_0_aruser : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_awuser : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC1_FPD_0_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HPC1_FPD_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HPC1_FPD_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC1_FPD_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC1_FPD_0_awlock : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC1_FPD_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC1_FPD_0_awvalid : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_awready : out STD_LOGIC;
    S_AXI_HPC1_FPD_0_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HPC1_FPD_0_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_HPC1_FPD_0_wlast : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_wvalid : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_wready : out STD_LOGIC;
    S_AXI_HPC1_FPD_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC1_FPD_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC1_FPD_0_bvalid : out STD_LOGIC;
    S_AXI_HPC1_FPD_0_bready : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC1_FPD_0_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HPC1_FPD_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HPC1_FPD_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC1_FPD_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC1_FPD_0_arlock : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC1_FPD_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HPC1_FPD_0_arvalid : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_arready : out STD_LOGIC;
    S_AXI_HPC1_FPD_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HPC1_FPD_0_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HPC1_FPD_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HPC1_FPD_0_rlast : out STD_LOGIC;
    S_AXI_HPC1_FPD_0_rvalid : out STD_LOGIC;
    S_AXI_HPC1_FPD_0_rready : in STD_LOGIC;
    S_AXI_HPC1_FPD_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HPC1_FPD_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_FPD_0_aruser : in STD_LOGIC;
    S_AXI_HP0_FPD_0_awuser : in STD_LOGIC;
    S_AXI_HP0_FPD_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_FPD_0_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP0_FPD_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP0_FPD_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_FPD_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_FPD_0_awlock : in STD_LOGIC;
    S_AXI_HP0_FPD_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_FPD_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_FPD_0_awvalid : in STD_LOGIC;
    S_AXI_HP0_FPD_0_awready : out STD_LOGIC;
    S_AXI_HP0_FPD_0_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP0_FPD_0_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_HP0_FPD_0_wlast : in STD_LOGIC;
    S_AXI_HP0_FPD_0_wvalid : in STD_LOGIC;
    S_AXI_HP0_FPD_0_wready : out STD_LOGIC;
    S_AXI_HP0_FPD_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_FPD_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_FPD_0_bvalid : out STD_LOGIC;
    S_AXI_HP0_FPD_0_bready : in STD_LOGIC;
    S_AXI_HP0_FPD_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_FPD_0_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP0_FPD_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP0_FPD_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_FPD_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_FPD_0_arlock : in STD_LOGIC;
    S_AXI_HP0_FPD_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_FPD_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP0_FPD_0_arvalid : in STD_LOGIC;
    S_AXI_HP0_FPD_0_arready : out STD_LOGIC;
    S_AXI_HP0_FPD_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP0_FPD_0_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP0_FPD_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP0_FPD_0_rlast : out STD_LOGIC;
    S_AXI_HP0_FPD_0_rvalid : out STD_LOGIC;
    S_AXI_HP0_FPD_0_rready : in STD_LOGIC;
    S_AXI_HP0_FPD_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP0_FPD_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_FPD_0_aruser : in STD_LOGIC;
    S_AXI_HP1_FPD_0_awuser : in STD_LOGIC;
    S_AXI_HP1_FPD_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_FPD_0_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP1_FPD_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP1_FPD_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_FPD_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_FPD_0_awlock : in STD_LOGIC;
    S_AXI_HP1_FPD_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_FPD_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_FPD_0_awvalid : in STD_LOGIC;
    S_AXI_HP1_FPD_0_awready : out STD_LOGIC;
    S_AXI_HP1_FPD_0_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP1_FPD_0_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_HP1_FPD_0_wlast : in STD_LOGIC;
    S_AXI_HP1_FPD_0_wvalid : in STD_LOGIC;
    S_AXI_HP1_FPD_0_wready : out STD_LOGIC;
    S_AXI_HP1_FPD_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_FPD_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_FPD_0_bvalid : out STD_LOGIC;
    S_AXI_HP1_FPD_0_bready : in STD_LOGIC;
    S_AXI_HP1_FPD_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_FPD_0_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP1_FPD_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP1_FPD_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_FPD_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_FPD_0_arlock : in STD_LOGIC;
    S_AXI_HP1_FPD_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_FPD_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP1_FPD_0_arvalid : in STD_LOGIC;
    S_AXI_HP1_FPD_0_arready : out STD_LOGIC;
    S_AXI_HP1_FPD_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP1_FPD_0_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP1_FPD_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP1_FPD_0_rlast : out STD_LOGIC;
    S_AXI_HP1_FPD_0_rvalid : out STD_LOGIC;
    S_AXI_HP1_FPD_0_rready : in STD_LOGIC;
    S_AXI_HP1_FPD_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP1_FPD_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_FPD_0_aruser : in STD_LOGIC;
    S_AXI_HP2_FPD_0_awuser : in STD_LOGIC;
    S_AXI_HP2_FPD_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_FPD_0_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP2_FPD_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP2_FPD_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_FPD_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_FPD_0_awlock : in STD_LOGIC;
    S_AXI_HP2_FPD_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_FPD_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_FPD_0_awvalid : in STD_LOGIC;
    S_AXI_HP2_FPD_0_awready : out STD_LOGIC;
    S_AXI_HP2_FPD_0_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP2_FPD_0_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_HP2_FPD_0_wlast : in STD_LOGIC;
    S_AXI_HP2_FPD_0_wvalid : in STD_LOGIC;
    S_AXI_HP2_FPD_0_wready : out STD_LOGIC;
    S_AXI_HP2_FPD_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_FPD_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_FPD_0_bvalid : out STD_LOGIC;
    S_AXI_HP2_FPD_0_bready : in STD_LOGIC;
    S_AXI_HP2_FPD_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_FPD_0_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP2_FPD_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP2_FPD_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_FPD_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_FPD_0_arlock : in STD_LOGIC;
    S_AXI_HP2_FPD_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_FPD_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP2_FPD_0_arvalid : in STD_LOGIC;
    S_AXI_HP2_FPD_0_arready : out STD_LOGIC;
    S_AXI_HP2_FPD_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP2_FPD_0_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP2_FPD_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP2_FPD_0_rlast : out STD_LOGIC;
    S_AXI_HP2_FPD_0_rvalid : out STD_LOGIC;
    S_AXI_HP2_FPD_0_rready : in STD_LOGIC;
    S_AXI_HP2_FPD_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP2_FPD_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_FPD_0_aruser : in STD_LOGIC;
    S_AXI_HP3_FPD_0_awuser : in STD_LOGIC;
    S_AXI_HP3_FPD_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_FPD_0_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP3_FPD_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP3_FPD_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_FPD_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_FPD_0_awlock : in STD_LOGIC;
    S_AXI_HP3_FPD_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_FPD_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_FPD_0_awvalid : in STD_LOGIC;
    S_AXI_HP3_FPD_0_awready : out STD_LOGIC;
    S_AXI_HP3_FPD_0_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP3_FPD_0_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_HP3_FPD_0_wlast : in STD_LOGIC;
    S_AXI_HP3_FPD_0_wvalid : in STD_LOGIC;
    S_AXI_HP3_FPD_0_wready : out STD_LOGIC;
    S_AXI_HP3_FPD_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_FPD_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_FPD_0_bvalid : out STD_LOGIC;
    S_AXI_HP3_FPD_0_bready : in STD_LOGIC;
    S_AXI_HP3_FPD_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_FPD_0_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_HP3_FPD_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_HP3_FPD_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_FPD_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_FPD_0_arlock : in STD_LOGIC;
    S_AXI_HP3_FPD_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_FPD_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_HP3_FPD_0_arvalid : in STD_LOGIC;
    S_AXI_HP3_FPD_0_arready : out STD_LOGIC;
    S_AXI_HP3_FPD_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_HP3_FPD_0_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_HP3_FPD_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_HP3_FPD_0_rlast : out STD_LOGIC;
    S_AXI_HP3_FPD_0_rvalid : out STD_LOGIC;
    S_AXI_HP3_FPD_0_rready : in STD_LOGIC;
    S_AXI_HP3_FPD_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_HP3_FPD_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_LPD_0_aruser : in STD_LOGIC;
    S_AXI_LPD_0_awuser : in STD_LOGIC;
    S_AXI_LPD_0_awid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_LPD_0_awaddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_LPD_0_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_LPD_0_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_LPD_0_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_LPD_0_awlock : in STD_LOGIC;
    S_AXI_LPD_0_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_LPD_0_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_LPD_0_awvalid : in STD_LOGIC;
    S_AXI_LPD_0_awready : out STD_LOGIC;
    S_AXI_LPD_0_wdata : in STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_LPD_0_wstrb : in STD_LOGIC_VECTOR ( 15 downto 0 );
    S_AXI_LPD_0_wlast : in STD_LOGIC;
    S_AXI_LPD_0_wvalid : in STD_LOGIC;
    S_AXI_LPD_0_wready : out STD_LOGIC;
    S_AXI_LPD_0_bid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_LPD_0_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_LPD_0_bvalid : out STD_LOGIC;
    S_AXI_LPD_0_bready : in STD_LOGIC;
    S_AXI_LPD_0_arid : in STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_LPD_0_araddr : in STD_LOGIC_VECTOR ( 48 downto 0 );
    S_AXI_LPD_0_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    S_AXI_LPD_0_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_LPD_0_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_LPD_0_arlock : in STD_LOGIC;
    S_AXI_LPD_0_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_LPD_0_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    S_AXI_LPD_0_arvalid : in STD_LOGIC;
    S_AXI_LPD_0_arready : out STD_LOGIC;
    S_AXI_LPD_0_rid : out STD_LOGIC_VECTOR ( 5 downto 0 );
    S_AXI_LPD_0_rdata : out STD_LOGIC_VECTOR ( 127 downto 0 );
    S_AXI_LPD_0_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    S_AXI_LPD_0_rlast : out STD_LOGIC;
    S_AXI_LPD_0_rvalid : out STD_LOGIC;
    S_AXI_LPD_0_rready : in STD_LOGIC;
    S_AXI_LPD_0_awqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    S_AXI_LPD_0_arqos : in STD_LOGIC_VECTOR ( 3 downto 0 );
    M02_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M02_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M02_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M02_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M02_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M02_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M02_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M02_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M02_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M02_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M02_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M03_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M03_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M03_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M03_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M03_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M03_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M03_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M03_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M03_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M03_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M04_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M04_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M04_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M04_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M04_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M04_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M04_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M04_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M04_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M04_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M05_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M05_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M05_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M05_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M05_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M05_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M05_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M05_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M06_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M06_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M06_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M06_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M06_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M06_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M06_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M06_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M06_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M06_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_awaddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M07_AXI_0_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M07_AXI_0_awvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_awready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_wdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    M07_AXI_0_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
    M07_AXI_0_wvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_wready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M07_AXI_0_bvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_bready : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_araddr : out STD_LOGIC_VECTOR ( 39 downto 0 );
    M07_AXI_0_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
    M07_AXI_0_arvalid : out STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_arready : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_rdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    M07_AXI_0_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
    M07_AXI_0_rvalid : in STD_LOGIC_VECTOR ( 0 to 0 );
    M07_AXI_0_rready : out STD_LOGIC_VECTOR ( 0 to 0 );
    pl_clk0 : out STD_LOGIC;
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    pl_ps_irq0_0 : in STD_LOGIC_VECTOR ( 0 to 0 )
  );
  end component ps02;
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
ps02_i: component ps02
     port map (
      IIC_0_0_scl_i => IIC_0_0_scl_i,
      IIC_0_0_scl_o => IIC_0_0_scl_o,
      IIC_0_0_scl_t => IIC_0_0_scl_t,
      IIC_0_0_sda_i => IIC_0_0_sda_i,
      IIC_0_0_sda_o => IIC_0_0_sda_o,
      IIC_0_0_sda_t => IIC_0_0_sda_t,
      M00_AXI_0_araddr(39 downto 0) => M00_AXI_0_araddr(39 downto 0),
      M00_AXI_0_arprot(2 downto 0) => M00_AXI_0_arprot(2 downto 0),
      M00_AXI_0_arready(0) => M00_AXI_0_arready(0),
      M00_AXI_0_arvalid(0) => M00_AXI_0_arvalid(0),
      M00_AXI_0_awaddr(39 downto 0) => M00_AXI_0_awaddr(39 downto 0),
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
      M01_AXI_0_araddr(39 downto 0) => M01_AXI_0_araddr(39 downto 0),
      M01_AXI_0_arprot(2 downto 0) => M01_AXI_0_arprot(2 downto 0),
      M01_AXI_0_arready(0) => M01_AXI_0_arready(0),
      M01_AXI_0_arvalid(0) => M01_AXI_0_arvalid(0),
      M01_AXI_0_awaddr(39 downto 0) => M01_AXI_0_awaddr(39 downto 0),
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
      M02_AXI_0_araddr(39 downto 0) => M02_AXI_0_araddr(39 downto 0),
      M02_AXI_0_arprot(2 downto 0) => M02_AXI_0_arprot(2 downto 0),
      M02_AXI_0_arready(0) => M02_AXI_0_arready(0),
      M02_AXI_0_arvalid(0) => M02_AXI_0_arvalid(0),
      M02_AXI_0_awaddr(39 downto 0) => M02_AXI_0_awaddr(39 downto 0),
      M02_AXI_0_awprot(2 downto 0) => M02_AXI_0_awprot(2 downto 0),
      M02_AXI_0_awready(0) => M02_AXI_0_awready(0),
      M02_AXI_0_awvalid(0) => M02_AXI_0_awvalid(0),
      M02_AXI_0_bready(0) => M02_AXI_0_bready(0),
      M02_AXI_0_bresp(1 downto 0) => M02_AXI_0_bresp(1 downto 0),
      M02_AXI_0_bvalid(0) => M02_AXI_0_bvalid(0),
      M02_AXI_0_rdata(31 downto 0) => M02_AXI_0_rdata(31 downto 0),
      M02_AXI_0_rready(0) => M02_AXI_0_rready(0),
      M02_AXI_0_rresp(1 downto 0) => M02_AXI_0_rresp(1 downto 0),
      M02_AXI_0_rvalid(0) => M02_AXI_0_rvalid(0),
      M02_AXI_0_wdata(31 downto 0) => M02_AXI_0_wdata(31 downto 0),
      M02_AXI_0_wready(0) => M02_AXI_0_wready(0),
      M02_AXI_0_wstrb(3 downto 0) => M02_AXI_0_wstrb(3 downto 0),
      M02_AXI_0_wvalid(0) => M02_AXI_0_wvalid(0),
      M03_AXI_0_araddr(39 downto 0) => M03_AXI_0_araddr(39 downto 0),
      M03_AXI_0_arprot(2 downto 0) => M03_AXI_0_arprot(2 downto 0),
      M03_AXI_0_arready(0) => M03_AXI_0_arready(0),
      M03_AXI_0_arvalid(0) => M03_AXI_0_arvalid(0),
      M03_AXI_0_awaddr(39 downto 0) => M03_AXI_0_awaddr(39 downto 0),
      M03_AXI_0_awprot(2 downto 0) => M03_AXI_0_awprot(2 downto 0),
      M03_AXI_0_awready(0) => M03_AXI_0_awready(0),
      M03_AXI_0_awvalid(0) => M03_AXI_0_awvalid(0),
      M03_AXI_0_bready(0) => M03_AXI_0_bready(0),
      M03_AXI_0_bresp(1 downto 0) => M03_AXI_0_bresp(1 downto 0),
      M03_AXI_0_bvalid(0) => M03_AXI_0_bvalid(0),
      M03_AXI_0_rdata(31 downto 0) => M03_AXI_0_rdata(31 downto 0),
      M03_AXI_0_rready(0) => M03_AXI_0_rready(0),
      M03_AXI_0_rresp(1 downto 0) => M03_AXI_0_rresp(1 downto 0),
      M03_AXI_0_rvalid(0) => M03_AXI_0_rvalid(0),
      M03_AXI_0_wdata(31 downto 0) => M03_AXI_0_wdata(31 downto 0),
      M03_AXI_0_wready(0) => M03_AXI_0_wready(0),
      M03_AXI_0_wstrb(3 downto 0) => M03_AXI_0_wstrb(3 downto 0),
      M03_AXI_0_wvalid(0) => M03_AXI_0_wvalid(0),
      M04_AXI_0_araddr(39 downto 0) => M04_AXI_0_araddr(39 downto 0),
      M04_AXI_0_arprot(2 downto 0) => M04_AXI_0_arprot(2 downto 0),
      M04_AXI_0_arready(0) => M04_AXI_0_arready(0),
      M04_AXI_0_arvalid(0) => M04_AXI_0_arvalid(0),
      M04_AXI_0_awaddr(39 downto 0) => M04_AXI_0_awaddr(39 downto 0),
      M04_AXI_0_awprot(2 downto 0) => M04_AXI_0_awprot(2 downto 0),
      M04_AXI_0_awready(0) => M04_AXI_0_awready(0),
      M04_AXI_0_awvalid(0) => M04_AXI_0_awvalid(0),
      M04_AXI_0_bready(0) => M04_AXI_0_bready(0),
      M04_AXI_0_bresp(1 downto 0) => M04_AXI_0_bresp(1 downto 0),
      M04_AXI_0_bvalid(0) => M04_AXI_0_bvalid(0),
      M04_AXI_0_rdata(31 downto 0) => M04_AXI_0_rdata(31 downto 0),
      M04_AXI_0_rready(0) => M04_AXI_0_rready(0),
      M04_AXI_0_rresp(1 downto 0) => M04_AXI_0_rresp(1 downto 0),
      M04_AXI_0_rvalid(0) => M04_AXI_0_rvalid(0),
      M04_AXI_0_wdata(31 downto 0) => M04_AXI_0_wdata(31 downto 0),
      M04_AXI_0_wready(0) => M04_AXI_0_wready(0),
      M04_AXI_0_wstrb(3 downto 0) => M04_AXI_0_wstrb(3 downto 0),
      M04_AXI_0_wvalid(0) => M04_AXI_0_wvalid(0),
      M05_AXI_0_araddr(39 downto 0) => M05_AXI_0_araddr(39 downto 0),
      M05_AXI_0_arprot(2 downto 0) => M05_AXI_0_arprot(2 downto 0),
      M05_AXI_0_arready(0) => M05_AXI_0_arready(0),
      M05_AXI_0_arvalid(0) => M05_AXI_0_arvalid(0),
      M05_AXI_0_awaddr(39 downto 0) => M05_AXI_0_awaddr(39 downto 0),
      M05_AXI_0_awprot(2 downto 0) => M05_AXI_0_awprot(2 downto 0),
      M05_AXI_0_awready(0) => M05_AXI_0_awready(0),
      M05_AXI_0_awvalid(0) => M05_AXI_0_awvalid(0),
      M05_AXI_0_bready(0) => M05_AXI_0_bready(0),
      M05_AXI_0_bresp(1 downto 0) => M05_AXI_0_bresp(1 downto 0),
      M05_AXI_0_bvalid(0) => M05_AXI_0_bvalid(0),
      M05_AXI_0_rdata(31 downto 0) => M05_AXI_0_rdata(31 downto 0),
      M05_AXI_0_rready(0) => M05_AXI_0_rready(0),
      M05_AXI_0_rresp(1 downto 0) => M05_AXI_0_rresp(1 downto 0),
      M05_AXI_0_rvalid(0) => M05_AXI_0_rvalid(0),
      M05_AXI_0_wdata(31 downto 0) => M05_AXI_0_wdata(31 downto 0),
      M05_AXI_0_wready(0) => M05_AXI_0_wready(0),
      M05_AXI_0_wstrb(3 downto 0) => M05_AXI_0_wstrb(3 downto 0),
      M05_AXI_0_wvalid(0) => M05_AXI_0_wvalid(0),
      M06_AXI_0_araddr(39 downto 0) => M06_AXI_0_araddr(39 downto 0),
      M06_AXI_0_arprot(2 downto 0) => M06_AXI_0_arprot(2 downto 0),
      M06_AXI_0_arready(0) => M06_AXI_0_arready(0),
      M06_AXI_0_arvalid(0) => M06_AXI_0_arvalid(0),
      M06_AXI_0_awaddr(39 downto 0) => M06_AXI_0_awaddr(39 downto 0),
      M06_AXI_0_awprot(2 downto 0) => M06_AXI_0_awprot(2 downto 0),
      M06_AXI_0_awready(0) => M06_AXI_0_awready(0),
      M06_AXI_0_awvalid(0) => M06_AXI_0_awvalid(0),
      M06_AXI_0_bready(0) => M06_AXI_0_bready(0),
      M06_AXI_0_bresp(1 downto 0) => M06_AXI_0_bresp(1 downto 0),
      M06_AXI_0_bvalid(0) => M06_AXI_0_bvalid(0),
      M06_AXI_0_rdata(31 downto 0) => M06_AXI_0_rdata(31 downto 0),
      M06_AXI_0_rready(0) => M06_AXI_0_rready(0),
      M06_AXI_0_rresp(1 downto 0) => M06_AXI_0_rresp(1 downto 0),
      M06_AXI_0_rvalid(0) => M06_AXI_0_rvalid(0),
      M06_AXI_0_wdata(31 downto 0) => M06_AXI_0_wdata(31 downto 0),
      M06_AXI_0_wready(0) => M06_AXI_0_wready(0),
      M06_AXI_0_wstrb(3 downto 0) => M06_AXI_0_wstrb(3 downto 0),
      M06_AXI_0_wvalid(0) => M06_AXI_0_wvalid(0),
      M07_AXI_0_araddr(39 downto 0) => M07_AXI_0_araddr(39 downto 0),
      M07_AXI_0_arprot(2 downto 0) => M07_AXI_0_arprot(2 downto 0),
      M07_AXI_0_arready(0) => M07_AXI_0_arready(0),
      M07_AXI_0_arvalid(0) => M07_AXI_0_arvalid(0),
      M07_AXI_0_awaddr(39 downto 0) => M07_AXI_0_awaddr(39 downto 0),
      M07_AXI_0_awprot(2 downto 0) => M07_AXI_0_awprot(2 downto 0),
      M07_AXI_0_awready(0) => M07_AXI_0_awready(0),
      M07_AXI_0_awvalid(0) => M07_AXI_0_awvalid(0),
      M07_AXI_0_bready(0) => M07_AXI_0_bready(0),
      M07_AXI_0_bresp(1 downto 0) => M07_AXI_0_bresp(1 downto 0),
      M07_AXI_0_bvalid(0) => M07_AXI_0_bvalid(0),
      M07_AXI_0_rdata(31 downto 0) => M07_AXI_0_rdata(31 downto 0),
      M07_AXI_0_rready(0) => M07_AXI_0_rready(0),
      M07_AXI_0_rresp(1 downto 0) => M07_AXI_0_rresp(1 downto 0),
      M07_AXI_0_rvalid(0) => M07_AXI_0_rvalid(0),
      M07_AXI_0_wdata(31 downto 0) => M07_AXI_0_wdata(31 downto 0),
      M07_AXI_0_wready(0) => M07_AXI_0_wready(0),
      M07_AXI_0_wstrb(3 downto 0) => M07_AXI_0_wstrb(3 downto 0),
      M07_AXI_0_wvalid(0) => M07_AXI_0_wvalid(0),
      M_AXI_HPM0_FPD_0_araddr(39 downto 0) => M_AXI_HPM0_FPD_0_araddr(39 downto 0),
      M_AXI_HPM0_FPD_0_arburst(1 downto 0) => M_AXI_HPM0_FPD_0_arburst(1 downto 0),
      M_AXI_HPM0_FPD_0_arcache(3 downto 0) => M_AXI_HPM0_FPD_0_arcache(3 downto 0),
      M_AXI_HPM0_FPD_0_arid(15 downto 0) => M_AXI_HPM0_FPD_0_arid(15 downto 0),
      M_AXI_HPM0_FPD_0_arlen(7 downto 0) => M_AXI_HPM0_FPD_0_arlen(7 downto 0),
      M_AXI_HPM0_FPD_0_arlock => M_AXI_HPM0_FPD_0_arlock,
      M_AXI_HPM0_FPD_0_arprot(2 downto 0) => M_AXI_HPM0_FPD_0_arprot(2 downto 0),
      M_AXI_HPM0_FPD_0_arqos(3 downto 0) => M_AXI_HPM0_FPD_0_arqos(3 downto 0),
      M_AXI_HPM0_FPD_0_arready => M_AXI_HPM0_FPD_0_arready,
      M_AXI_HPM0_FPD_0_arsize(2 downto 0) => M_AXI_HPM0_FPD_0_arsize(2 downto 0),
      M_AXI_HPM0_FPD_0_aruser(15 downto 0) => M_AXI_HPM0_FPD_0_aruser(15 downto 0),
      M_AXI_HPM0_FPD_0_arvalid => M_AXI_HPM0_FPD_0_arvalid,
      M_AXI_HPM0_FPD_0_awaddr(39 downto 0) => M_AXI_HPM0_FPD_0_awaddr(39 downto 0),
      M_AXI_HPM0_FPD_0_awburst(1 downto 0) => M_AXI_HPM0_FPD_0_awburst(1 downto 0),
      M_AXI_HPM0_FPD_0_awcache(3 downto 0) => M_AXI_HPM0_FPD_0_awcache(3 downto 0),
      M_AXI_HPM0_FPD_0_awid(15 downto 0) => M_AXI_HPM0_FPD_0_awid(15 downto 0),
      M_AXI_HPM0_FPD_0_awlen(7 downto 0) => M_AXI_HPM0_FPD_0_awlen(7 downto 0),
      M_AXI_HPM0_FPD_0_awlock => M_AXI_HPM0_FPD_0_awlock,
      M_AXI_HPM0_FPD_0_awprot(2 downto 0) => M_AXI_HPM0_FPD_0_awprot(2 downto 0),
      M_AXI_HPM0_FPD_0_awqos(3 downto 0) => M_AXI_HPM0_FPD_0_awqos(3 downto 0),
      M_AXI_HPM0_FPD_0_awready => M_AXI_HPM0_FPD_0_awready,
      M_AXI_HPM0_FPD_0_awsize(2 downto 0) => M_AXI_HPM0_FPD_0_awsize(2 downto 0),
      M_AXI_HPM0_FPD_0_awuser(15 downto 0) => M_AXI_HPM0_FPD_0_awuser(15 downto 0),
      M_AXI_HPM0_FPD_0_awvalid => M_AXI_HPM0_FPD_0_awvalid,
      M_AXI_HPM0_FPD_0_bid(15 downto 0) => M_AXI_HPM0_FPD_0_bid(15 downto 0),
      M_AXI_HPM0_FPD_0_bready => M_AXI_HPM0_FPD_0_bready,
      M_AXI_HPM0_FPD_0_bresp(1 downto 0) => M_AXI_HPM0_FPD_0_bresp(1 downto 0),
      M_AXI_HPM0_FPD_0_bvalid => M_AXI_HPM0_FPD_0_bvalid,
      M_AXI_HPM0_FPD_0_rdata(127 downto 0) => M_AXI_HPM0_FPD_0_rdata(127 downto 0),
      M_AXI_HPM0_FPD_0_rid(15 downto 0) => M_AXI_HPM0_FPD_0_rid(15 downto 0),
      M_AXI_HPM0_FPD_0_rlast => M_AXI_HPM0_FPD_0_rlast,
      M_AXI_HPM0_FPD_0_rready => M_AXI_HPM0_FPD_0_rready,
      M_AXI_HPM0_FPD_0_rresp(1 downto 0) => M_AXI_HPM0_FPD_0_rresp(1 downto 0),
      M_AXI_HPM0_FPD_0_rvalid => M_AXI_HPM0_FPD_0_rvalid,
      M_AXI_HPM0_FPD_0_wdata(127 downto 0) => M_AXI_HPM0_FPD_0_wdata(127 downto 0),
      M_AXI_HPM0_FPD_0_wlast => M_AXI_HPM0_FPD_0_wlast,
      M_AXI_HPM0_FPD_0_wready => M_AXI_HPM0_FPD_0_wready,
      M_AXI_HPM0_FPD_0_wstrb(15 downto 0) => M_AXI_HPM0_FPD_0_wstrb(15 downto 0),
      M_AXI_HPM0_FPD_0_wvalid => M_AXI_HPM0_FPD_0_wvalid,
      M_AXI_HPM0_LPD_0_araddr(39 downto 0) => M_AXI_HPM0_LPD_0_araddr(39 downto 0),
      M_AXI_HPM0_LPD_0_arburst(1 downto 0) => M_AXI_HPM0_LPD_0_arburst(1 downto 0),
      M_AXI_HPM0_LPD_0_arcache(3 downto 0) => M_AXI_HPM0_LPD_0_arcache(3 downto 0),
      M_AXI_HPM0_LPD_0_arid(15 downto 0) => M_AXI_HPM0_LPD_0_arid(15 downto 0),
      M_AXI_HPM0_LPD_0_arlen(7 downto 0) => M_AXI_HPM0_LPD_0_arlen(7 downto 0),
      M_AXI_HPM0_LPD_0_arlock => M_AXI_HPM0_LPD_0_arlock,
      M_AXI_HPM0_LPD_0_arprot(2 downto 0) => M_AXI_HPM0_LPD_0_arprot(2 downto 0),
      M_AXI_HPM0_LPD_0_arqos(3 downto 0) => M_AXI_HPM0_LPD_0_arqos(3 downto 0),
      M_AXI_HPM0_LPD_0_arready => M_AXI_HPM0_LPD_0_arready,
      M_AXI_HPM0_LPD_0_arsize(2 downto 0) => M_AXI_HPM0_LPD_0_arsize(2 downto 0),
      M_AXI_HPM0_LPD_0_aruser(15 downto 0) => M_AXI_HPM0_LPD_0_aruser(15 downto 0),
      M_AXI_HPM0_LPD_0_arvalid => M_AXI_HPM0_LPD_0_arvalid,
      M_AXI_HPM0_LPD_0_awaddr(39 downto 0) => M_AXI_HPM0_LPD_0_awaddr(39 downto 0),
      M_AXI_HPM0_LPD_0_awburst(1 downto 0) => M_AXI_HPM0_LPD_0_awburst(1 downto 0),
      M_AXI_HPM0_LPD_0_awcache(3 downto 0) => M_AXI_HPM0_LPD_0_awcache(3 downto 0),
      M_AXI_HPM0_LPD_0_awid(15 downto 0) => M_AXI_HPM0_LPD_0_awid(15 downto 0),
      M_AXI_HPM0_LPD_0_awlen(7 downto 0) => M_AXI_HPM0_LPD_0_awlen(7 downto 0),
      M_AXI_HPM0_LPD_0_awlock => M_AXI_HPM0_LPD_0_awlock,
      M_AXI_HPM0_LPD_0_awprot(2 downto 0) => M_AXI_HPM0_LPD_0_awprot(2 downto 0),
      M_AXI_HPM0_LPD_0_awqos(3 downto 0) => M_AXI_HPM0_LPD_0_awqos(3 downto 0),
      M_AXI_HPM0_LPD_0_awready => M_AXI_HPM0_LPD_0_awready,
      M_AXI_HPM0_LPD_0_awsize(2 downto 0) => M_AXI_HPM0_LPD_0_awsize(2 downto 0),
      M_AXI_HPM0_LPD_0_awuser(15 downto 0) => M_AXI_HPM0_LPD_0_awuser(15 downto 0),
      M_AXI_HPM0_LPD_0_awvalid => M_AXI_HPM0_LPD_0_awvalid,
      M_AXI_HPM0_LPD_0_bid(15 downto 0) => M_AXI_HPM0_LPD_0_bid(15 downto 0),
      M_AXI_HPM0_LPD_0_bready => M_AXI_HPM0_LPD_0_bready,
      M_AXI_HPM0_LPD_0_bresp(1 downto 0) => M_AXI_HPM0_LPD_0_bresp(1 downto 0),
      M_AXI_HPM0_LPD_0_bvalid => M_AXI_HPM0_LPD_0_bvalid,
      M_AXI_HPM0_LPD_0_rdata(31 downto 0) => M_AXI_HPM0_LPD_0_rdata(31 downto 0),
      M_AXI_HPM0_LPD_0_rid(15 downto 0) => M_AXI_HPM0_LPD_0_rid(15 downto 0),
      M_AXI_HPM0_LPD_0_rlast => M_AXI_HPM0_LPD_0_rlast,
      M_AXI_HPM0_LPD_0_rready => M_AXI_HPM0_LPD_0_rready,
      M_AXI_HPM0_LPD_0_rresp(1 downto 0) => M_AXI_HPM0_LPD_0_rresp(1 downto 0),
      M_AXI_HPM0_LPD_0_rvalid => M_AXI_HPM0_LPD_0_rvalid,
      M_AXI_HPM0_LPD_0_wdata(31 downto 0) => M_AXI_HPM0_LPD_0_wdata(31 downto 0),
      M_AXI_HPM0_LPD_0_wlast => M_AXI_HPM0_LPD_0_wlast,
      M_AXI_HPM0_LPD_0_wready => M_AXI_HPM0_LPD_0_wready,
      M_AXI_HPM0_LPD_0_wstrb(3 downto 0) => M_AXI_HPM0_LPD_0_wstrb(3 downto 0),
      M_AXI_HPM0_LPD_0_wvalid => M_AXI_HPM0_LPD_0_wvalid,
      S_AXI_HP0_FPD_0_araddr(48 downto 0) => S_AXI_HP0_FPD_0_araddr(48 downto 0),
      S_AXI_HP0_FPD_0_arburst(1 downto 0) => S_AXI_HP0_FPD_0_arburst(1 downto 0),
      S_AXI_HP0_FPD_0_arcache(3 downto 0) => S_AXI_HP0_FPD_0_arcache(3 downto 0),
      S_AXI_HP0_FPD_0_arid(5 downto 0) => S_AXI_HP0_FPD_0_arid(5 downto 0),
      S_AXI_HP0_FPD_0_arlen(7 downto 0) => S_AXI_HP0_FPD_0_arlen(7 downto 0),
      S_AXI_HP0_FPD_0_arlock => S_AXI_HP0_FPD_0_arlock,
      S_AXI_HP0_FPD_0_arprot(2 downto 0) => S_AXI_HP0_FPD_0_arprot(2 downto 0),
      S_AXI_HP0_FPD_0_arqos(3 downto 0) => S_AXI_HP0_FPD_0_arqos(3 downto 0),
      S_AXI_HP0_FPD_0_arready => S_AXI_HP0_FPD_0_arready,
      S_AXI_HP0_FPD_0_arsize(2 downto 0) => S_AXI_HP0_FPD_0_arsize(2 downto 0),
      S_AXI_HP0_FPD_0_aruser => S_AXI_HP0_FPD_0_aruser,
      S_AXI_HP0_FPD_0_arvalid => S_AXI_HP0_FPD_0_arvalid,
      S_AXI_HP0_FPD_0_awaddr(48 downto 0) => S_AXI_HP0_FPD_0_awaddr(48 downto 0),
      S_AXI_HP0_FPD_0_awburst(1 downto 0) => S_AXI_HP0_FPD_0_awburst(1 downto 0),
      S_AXI_HP0_FPD_0_awcache(3 downto 0) => S_AXI_HP0_FPD_0_awcache(3 downto 0),
      S_AXI_HP0_FPD_0_awid(5 downto 0) => S_AXI_HP0_FPD_0_awid(5 downto 0),
      S_AXI_HP0_FPD_0_awlen(7 downto 0) => S_AXI_HP0_FPD_0_awlen(7 downto 0),
      S_AXI_HP0_FPD_0_awlock => S_AXI_HP0_FPD_0_awlock,
      S_AXI_HP0_FPD_0_awprot(2 downto 0) => S_AXI_HP0_FPD_0_awprot(2 downto 0),
      S_AXI_HP0_FPD_0_awqos(3 downto 0) => S_AXI_HP0_FPD_0_awqos(3 downto 0),
      S_AXI_HP0_FPD_0_awready => S_AXI_HP0_FPD_0_awready,
      S_AXI_HP0_FPD_0_awsize(2 downto 0) => S_AXI_HP0_FPD_0_awsize(2 downto 0),
      S_AXI_HP0_FPD_0_awuser => S_AXI_HP0_FPD_0_awuser,
      S_AXI_HP0_FPD_0_awvalid => S_AXI_HP0_FPD_0_awvalid,
      S_AXI_HP0_FPD_0_bid(5 downto 0) => S_AXI_HP0_FPD_0_bid(5 downto 0),
      S_AXI_HP0_FPD_0_bready => S_AXI_HP0_FPD_0_bready,
      S_AXI_HP0_FPD_0_bresp(1 downto 0) => S_AXI_HP0_FPD_0_bresp(1 downto 0),
      S_AXI_HP0_FPD_0_bvalid => S_AXI_HP0_FPD_0_bvalid,
      S_AXI_HP0_FPD_0_rdata(127 downto 0) => S_AXI_HP0_FPD_0_rdata(127 downto 0),
      S_AXI_HP0_FPD_0_rid(5 downto 0) => S_AXI_HP0_FPD_0_rid(5 downto 0),
      S_AXI_HP0_FPD_0_rlast => S_AXI_HP0_FPD_0_rlast,
      S_AXI_HP0_FPD_0_rready => S_AXI_HP0_FPD_0_rready,
      S_AXI_HP0_FPD_0_rresp(1 downto 0) => S_AXI_HP0_FPD_0_rresp(1 downto 0),
      S_AXI_HP0_FPD_0_rvalid => S_AXI_HP0_FPD_0_rvalid,
      S_AXI_HP0_FPD_0_wdata(127 downto 0) => S_AXI_HP0_FPD_0_wdata(127 downto 0),
      S_AXI_HP0_FPD_0_wlast => S_AXI_HP0_FPD_0_wlast,
      S_AXI_HP0_FPD_0_wready => S_AXI_HP0_FPD_0_wready,
      S_AXI_HP0_FPD_0_wstrb(15 downto 0) => S_AXI_HP0_FPD_0_wstrb(15 downto 0),
      S_AXI_HP0_FPD_0_wvalid => S_AXI_HP0_FPD_0_wvalid,
      S_AXI_HP1_FPD_0_araddr(48 downto 0) => S_AXI_HP1_FPD_0_araddr(48 downto 0),
      S_AXI_HP1_FPD_0_arburst(1 downto 0) => S_AXI_HP1_FPD_0_arburst(1 downto 0),
      S_AXI_HP1_FPD_0_arcache(3 downto 0) => S_AXI_HP1_FPD_0_arcache(3 downto 0),
      S_AXI_HP1_FPD_0_arid(5 downto 0) => S_AXI_HP1_FPD_0_arid(5 downto 0),
      S_AXI_HP1_FPD_0_arlen(7 downto 0) => S_AXI_HP1_FPD_0_arlen(7 downto 0),
      S_AXI_HP1_FPD_0_arlock => S_AXI_HP1_FPD_0_arlock,
      S_AXI_HP1_FPD_0_arprot(2 downto 0) => S_AXI_HP1_FPD_0_arprot(2 downto 0),
      S_AXI_HP1_FPD_0_arqos(3 downto 0) => S_AXI_HP1_FPD_0_arqos(3 downto 0),
      S_AXI_HP1_FPD_0_arready => S_AXI_HP1_FPD_0_arready,
      S_AXI_HP1_FPD_0_arsize(2 downto 0) => S_AXI_HP1_FPD_0_arsize(2 downto 0),
      S_AXI_HP1_FPD_0_aruser => S_AXI_HP1_FPD_0_aruser,
      S_AXI_HP1_FPD_0_arvalid => S_AXI_HP1_FPD_0_arvalid,
      S_AXI_HP1_FPD_0_awaddr(48 downto 0) => S_AXI_HP1_FPD_0_awaddr(48 downto 0),
      S_AXI_HP1_FPD_0_awburst(1 downto 0) => S_AXI_HP1_FPD_0_awburst(1 downto 0),
      S_AXI_HP1_FPD_0_awcache(3 downto 0) => S_AXI_HP1_FPD_0_awcache(3 downto 0),
      S_AXI_HP1_FPD_0_awid(5 downto 0) => S_AXI_HP1_FPD_0_awid(5 downto 0),
      S_AXI_HP1_FPD_0_awlen(7 downto 0) => S_AXI_HP1_FPD_0_awlen(7 downto 0),
      S_AXI_HP1_FPD_0_awlock => S_AXI_HP1_FPD_0_awlock,
      S_AXI_HP1_FPD_0_awprot(2 downto 0) => S_AXI_HP1_FPD_0_awprot(2 downto 0),
      S_AXI_HP1_FPD_0_awqos(3 downto 0) => S_AXI_HP1_FPD_0_awqos(3 downto 0),
      S_AXI_HP1_FPD_0_awready => S_AXI_HP1_FPD_0_awready,
      S_AXI_HP1_FPD_0_awsize(2 downto 0) => S_AXI_HP1_FPD_0_awsize(2 downto 0),
      S_AXI_HP1_FPD_0_awuser => S_AXI_HP1_FPD_0_awuser,
      S_AXI_HP1_FPD_0_awvalid => S_AXI_HP1_FPD_0_awvalid,
      S_AXI_HP1_FPD_0_bid(5 downto 0) => S_AXI_HP1_FPD_0_bid(5 downto 0),
      S_AXI_HP1_FPD_0_bready => S_AXI_HP1_FPD_0_bready,
      S_AXI_HP1_FPD_0_bresp(1 downto 0) => S_AXI_HP1_FPD_0_bresp(1 downto 0),
      S_AXI_HP1_FPD_0_bvalid => S_AXI_HP1_FPD_0_bvalid,
      S_AXI_HP1_FPD_0_rdata(127 downto 0) => S_AXI_HP1_FPD_0_rdata(127 downto 0),
      S_AXI_HP1_FPD_0_rid(5 downto 0) => S_AXI_HP1_FPD_0_rid(5 downto 0),
      S_AXI_HP1_FPD_0_rlast => S_AXI_HP1_FPD_0_rlast,
      S_AXI_HP1_FPD_0_rready => S_AXI_HP1_FPD_0_rready,
      S_AXI_HP1_FPD_0_rresp(1 downto 0) => S_AXI_HP1_FPD_0_rresp(1 downto 0),
      S_AXI_HP1_FPD_0_rvalid => S_AXI_HP1_FPD_0_rvalid,
      S_AXI_HP1_FPD_0_wdata(127 downto 0) => S_AXI_HP1_FPD_0_wdata(127 downto 0),
      S_AXI_HP1_FPD_0_wlast => S_AXI_HP1_FPD_0_wlast,
      S_AXI_HP1_FPD_0_wready => S_AXI_HP1_FPD_0_wready,
      S_AXI_HP1_FPD_0_wstrb(15 downto 0) => S_AXI_HP1_FPD_0_wstrb(15 downto 0),
      S_AXI_HP1_FPD_0_wvalid => S_AXI_HP1_FPD_0_wvalid,
      S_AXI_HP2_FPD_0_araddr(48 downto 0) => S_AXI_HP2_FPD_0_araddr(48 downto 0),
      S_AXI_HP2_FPD_0_arburst(1 downto 0) => S_AXI_HP2_FPD_0_arburst(1 downto 0),
      S_AXI_HP2_FPD_0_arcache(3 downto 0) => S_AXI_HP2_FPD_0_arcache(3 downto 0),
      S_AXI_HP2_FPD_0_arid(5 downto 0) => S_AXI_HP2_FPD_0_arid(5 downto 0),
      S_AXI_HP2_FPD_0_arlen(7 downto 0) => S_AXI_HP2_FPD_0_arlen(7 downto 0),
      S_AXI_HP2_FPD_0_arlock => S_AXI_HP2_FPD_0_arlock,
      S_AXI_HP2_FPD_0_arprot(2 downto 0) => S_AXI_HP2_FPD_0_arprot(2 downto 0),
      S_AXI_HP2_FPD_0_arqos(3 downto 0) => S_AXI_HP2_FPD_0_arqos(3 downto 0),
      S_AXI_HP2_FPD_0_arready => S_AXI_HP2_FPD_0_arready,
      S_AXI_HP2_FPD_0_arsize(2 downto 0) => S_AXI_HP2_FPD_0_arsize(2 downto 0),
      S_AXI_HP2_FPD_0_aruser => S_AXI_HP2_FPD_0_aruser,
      S_AXI_HP2_FPD_0_arvalid => S_AXI_HP2_FPD_0_arvalid,
      S_AXI_HP2_FPD_0_awaddr(48 downto 0) => S_AXI_HP2_FPD_0_awaddr(48 downto 0),
      S_AXI_HP2_FPD_0_awburst(1 downto 0) => S_AXI_HP2_FPD_0_awburst(1 downto 0),
      S_AXI_HP2_FPD_0_awcache(3 downto 0) => S_AXI_HP2_FPD_0_awcache(3 downto 0),
      S_AXI_HP2_FPD_0_awid(5 downto 0) => S_AXI_HP2_FPD_0_awid(5 downto 0),
      S_AXI_HP2_FPD_0_awlen(7 downto 0) => S_AXI_HP2_FPD_0_awlen(7 downto 0),
      S_AXI_HP2_FPD_0_awlock => S_AXI_HP2_FPD_0_awlock,
      S_AXI_HP2_FPD_0_awprot(2 downto 0) => S_AXI_HP2_FPD_0_awprot(2 downto 0),
      S_AXI_HP2_FPD_0_awqos(3 downto 0) => S_AXI_HP2_FPD_0_awqos(3 downto 0),
      S_AXI_HP2_FPD_0_awready => S_AXI_HP2_FPD_0_awready,
      S_AXI_HP2_FPD_0_awsize(2 downto 0) => S_AXI_HP2_FPD_0_awsize(2 downto 0),
      S_AXI_HP2_FPD_0_awuser => S_AXI_HP2_FPD_0_awuser,
      S_AXI_HP2_FPD_0_awvalid => S_AXI_HP2_FPD_0_awvalid,
      S_AXI_HP2_FPD_0_bid(5 downto 0) => S_AXI_HP2_FPD_0_bid(5 downto 0),
      S_AXI_HP2_FPD_0_bready => S_AXI_HP2_FPD_0_bready,
      S_AXI_HP2_FPD_0_bresp(1 downto 0) => S_AXI_HP2_FPD_0_bresp(1 downto 0),
      S_AXI_HP2_FPD_0_bvalid => S_AXI_HP2_FPD_0_bvalid,
      S_AXI_HP2_FPD_0_rdata(127 downto 0) => S_AXI_HP2_FPD_0_rdata(127 downto 0),
      S_AXI_HP2_FPD_0_rid(5 downto 0) => S_AXI_HP2_FPD_0_rid(5 downto 0),
      S_AXI_HP2_FPD_0_rlast => S_AXI_HP2_FPD_0_rlast,
      S_AXI_HP2_FPD_0_rready => S_AXI_HP2_FPD_0_rready,
      S_AXI_HP2_FPD_0_rresp(1 downto 0) => S_AXI_HP2_FPD_0_rresp(1 downto 0),
      S_AXI_HP2_FPD_0_rvalid => S_AXI_HP2_FPD_0_rvalid,
      S_AXI_HP2_FPD_0_wdata(127 downto 0) => S_AXI_HP2_FPD_0_wdata(127 downto 0),
      S_AXI_HP2_FPD_0_wlast => S_AXI_HP2_FPD_0_wlast,
      S_AXI_HP2_FPD_0_wready => S_AXI_HP2_FPD_0_wready,
      S_AXI_HP2_FPD_0_wstrb(15 downto 0) => S_AXI_HP2_FPD_0_wstrb(15 downto 0),
      S_AXI_HP2_FPD_0_wvalid => S_AXI_HP2_FPD_0_wvalid,
      S_AXI_HP3_FPD_0_araddr(48 downto 0) => S_AXI_HP3_FPD_0_araddr(48 downto 0),
      S_AXI_HP3_FPD_0_arburst(1 downto 0) => S_AXI_HP3_FPD_0_arburst(1 downto 0),
      S_AXI_HP3_FPD_0_arcache(3 downto 0) => S_AXI_HP3_FPD_0_arcache(3 downto 0),
      S_AXI_HP3_FPD_0_arid(5 downto 0) => S_AXI_HP3_FPD_0_arid(5 downto 0),
      S_AXI_HP3_FPD_0_arlen(7 downto 0) => S_AXI_HP3_FPD_0_arlen(7 downto 0),
      S_AXI_HP3_FPD_0_arlock => S_AXI_HP3_FPD_0_arlock,
      S_AXI_HP3_FPD_0_arprot(2 downto 0) => S_AXI_HP3_FPD_0_arprot(2 downto 0),
      S_AXI_HP3_FPD_0_arqos(3 downto 0) => S_AXI_HP3_FPD_0_arqos(3 downto 0),
      S_AXI_HP3_FPD_0_arready => S_AXI_HP3_FPD_0_arready,
      S_AXI_HP3_FPD_0_arsize(2 downto 0) => S_AXI_HP3_FPD_0_arsize(2 downto 0),
      S_AXI_HP3_FPD_0_aruser => S_AXI_HP3_FPD_0_aruser,
      S_AXI_HP3_FPD_0_arvalid => S_AXI_HP3_FPD_0_arvalid,
      S_AXI_HP3_FPD_0_awaddr(48 downto 0) => S_AXI_HP3_FPD_0_awaddr(48 downto 0),
      S_AXI_HP3_FPD_0_awburst(1 downto 0) => S_AXI_HP3_FPD_0_awburst(1 downto 0),
      S_AXI_HP3_FPD_0_awcache(3 downto 0) => S_AXI_HP3_FPD_0_awcache(3 downto 0),
      S_AXI_HP3_FPD_0_awid(5 downto 0) => S_AXI_HP3_FPD_0_awid(5 downto 0),
      S_AXI_HP3_FPD_0_awlen(7 downto 0) => S_AXI_HP3_FPD_0_awlen(7 downto 0),
      S_AXI_HP3_FPD_0_awlock => S_AXI_HP3_FPD_0_awlock,
      S_AXI_HP3_FPD_0_awprot(2 downto 0) => S_AXI_HP3_FPD_0_awprot(2 downto 0),
      S_AXI_HP3_FPD_0_awqos(3 downto 0) => S_AXI_HP3_FPD_0_awqos(3 downto 0),
      S_AXI_HP3_FPD_0_awready => S_AXI_HP3_FPD_0_awready,
      S_AXI_HP3_FPD_0_awsize(2 downto 0) => S_AXI_HP3_FPD_0_awsize(2 downto 0),
      S_AXI_HP3_FPD_0_awuser => S_AXI_HP3_FPD_0_awuser,
      S_AXI_HP3_FPD_0_awvalid => S_AXI_HP3_FPD_0_awvalid,
      S_AXI_HP3_FPD_0_bid(5 downto 0) => S_AXI_HP3_FPD_0_bid(5 downto 0),
      S_AXI_HP3_FPD_0_bready => S_AXI_HP3_FPD_0_bready,
      S_AXI_HP3_FPD_0_bresp(1 downto 0) => S_AXI_HP3_FPD_0_bresp(1 downto 0),
      S_AXI_HP3_FPD_0_bvalid => S_AXI_HP3_FPD_0_bvalid,
      S_AXI_HP3_FPD_0_rdata(127 downto 0) => S_AXI_HP3_FPD_0_rdata(127 downto 0),
      S_AXI_HP3_FPD_0_rid(5 downto 0) => S_AXI_HP3_FPD_0_rid(5 downto 0),
      S_AXI_HP3_FPD_0_rlast => S_AXI_HP3_FPD_0_rlast,
      S_AXI_HP3_FPD_0_rready => S_AXI_HP3_FPD_0_rready,
      S_AXI_HP3_FPD_0_rresp(1 downto 0) => S_AXI_HP3_FPD_0_rresp(1 downto 0),
      S_AXI_HP3_FPD_0_rvalid => S_AXI_HP3_FPD_0_rvalid,
      S_AXI_HP3_FPD_0_wdata(127 downto 0) => S_AXI_HP3_FPD_0_wdata(127 downto 0),
      S_AXI_HP3_FPD_0_wlast => S_AXI_HP3_FPD_0_wlast,
      S_AXI_HP3_FPD_0_wready => S_AXI_HP3_FPD_0_wready,
      S_AXI_HP3_FPD_0_wstrb(15 downto 0) => S_AXI_HP3_FPD_0_wstrb(15 downto 0),
      S_AXI_HP3_FPD_0_wvalid => S_AXI_HP3_FPD_0_wvalid,
      S_AXI_HPC0_FPD_0_araddr(48 downto 0) => S_AXI_HPC0_FPD_0_araddr(48 downto 0),
      S_AXI_HPC0_FPD_0_arburst(1 downto 0) => S_AXI_HPC0_FPD_0_arburst(1 downto 0),
      S_AXI_HPC0_FPD_0_arcache(3 downto 0) => S_AXI_HPC0_FPD_0_arcache(3 downto 0),
      S_AXI_HPC0_FPD_0_arid(5 downto 0) => S_AXI_HPC0_FPD_0_arid(5 downto 0),
      S_AXI_HPC0_FPD_0_arlen(7 downto 0) => S_AXI_HPC0_FPD_0_arlen(7 downto 0),
      S_AXI_HPC0_FPD_0_arlock => S_AXI_HPC0_FPD_0_arlock,
      S_AXI_HPC0_FPD_0_arprot(2 downto 0) => S_AXI_HPC0_FPD_0_arprot(2 downto 0),
      S_AXI_HPC0_FPD_0_arqos(3 downto 0) => S_AXI_HPC0_FPD_0_arqos(3 downto 0),
      S_AXI_HPC0_FPD_0_arready => S_AXI_HPC0_FPD_0_arready,
      S_AXI_HPC0_FPD_0_arsize(2 downto 0) => S_AXI_HPC0_FPD_0_arsize(2 downto 0),
      S_AXI_HPC0_FPD_0_aruser => S_AXI_HPC0_FPD_0_aruser,
      S_AXI_HPC0_FPD_0_arvalid => S_AXI_HPC0_FPD_0_arvalid,
      S_AXI_HPC0_FPD_0_awaddr(48 downto 0) => S_AXI_HPC0_FPD_0_awaddr(48 downto 0),
      S_AXI_HPC0_FPD_0_awburst(1 downto 0) => S_AXI_HPC0_FPD_0_awburst(1 downto 0),
      S_AXI_HPC0_FPD_0_awcache(3 downto 0) => S_AXI_HPC0_FPD_0_awcache(3 downto 0),
      S_AXI_HPC0_FPD_0_awid(5 downto 0) => S_AXI_HPC0_FPD_0_awid(5 downto 0),
      S_AXI_HPC0_FPD_0_awlen(7 downto 0) => S_AXI_HPC0_FPD_0_awlen(7 downto 0),
      S_AXI_HPC0_FPD_0_awlock => S_AXI_HPC0_FPD_0_awlock,
      S_AXI_HPC0_FPD_0_awprot(2 downto 0) => S_AXI_HPC0_FPD_0_awprot(2 downto 0),
      S_AXI_HPC0_FPD_0_awqos(3 downto 0) => S_AXI_HPC0_FPD_0_awqos(3 downto 0),
      S_AXI_HPC0_FPD_0_awready => S_AXI_HPC0_FPD_0_awready,
      S_AXI_HPC0_FPD_0_awsize(2 downto 0) => S_AXI_HPC0_FPD_0_awsize(2 downto 0),
      S_AXI_HPC0_FPD_0_awuser => S_AXI_HPC0_FPD_0_awuser,
      S_AXI_HPC0_FPD_0_awvalid => S_AXI_HPC0_FPD_0_awvalid,
      S_AXI_HPC0_FPD_0_bid(5 downto 0) => S_AXI_HPC0_FPD_0_bid(5 downto 0),
      S_AXI_HPC0_FPD_0_bready => S_AXI_HPC0_FPD_0_bready,
      S_AXI_HPC0_FPD_0_bresp(1 downto 0) => S_AXI_HPC0_FPD_0_bresp(1 downto 0),
      S_AXI_HPC0_FPD_0_bvalid => S_AXI_HPC0_FPD_0_bvalid,
      S_AXI_HPC0_FPD_0_rdata(127 downto 0) => S_AXI_HPC0_FPD_0_rdata(127 downto 0),
      S_AXI_HPC0_FPD_0_rid(5 downto 0) => S_AXI_HPC0_FPD_0_rid(5 downto 0),
      S_AXI_HPC0_FPD_0_rlast => S_AXI_HPC0_FPD_0_rlast,
      S_AXI_HPC0_FPD_0_rready => S_AXI_HPC0_FPD_0_rready,
      S_AXI_HPC0_FPD_0_rresp(1 downto 0) => S_AXI_HPC0_FPD_0_rresp(1 downto 0),
      S_AXI_HPC0_FPD_0_rvalid => S_AXI_HPC0_FPD_0_rvalid,
      S_AXI_HPC0_FPD_0_wdata(127 downto 0) => S_AXI_HPC0_FPD_0_wdata(127 downto 0),
      S_AXI_HPC0_FPD_0_wlast => S_AXI_HPC0_FPD_0_wlast,
      S_AXI_HPC0_FPD_0_wready => S_AXI_HPC0_FPD_0_wready,
      S_AXI_HPC0_FPD_0_wstrb(15 downto 0) => S_AXI_HPC0_FPD_0_wstrb(15 downto 0),
      S_AXI_HPC0_FPD_0_wvalid => S_AXI_HPC0_FPD_0_wvalid,
      S_AXI_HPC1_FPD_0_araddr(48 downto 0) => S_AXI_HPC1_FPD_0_araddr(48 downto 0),
      S_AXI_HPC1_FPD_0_arburst(1 downto 0) => S_AXI_HPC1_FPD_0_arburst(1 downto 0),
      S_AXI_HPC1_FPD_0_arcache(3 downto 0) => S_AXI_HPC1_FPD_0_arcache(3 downto 0),
      S_AXI_HPC1_FPD_0_arid(5 downto 0) => S_AXI_HPC1_FPD_0_arid(5 downto 0),
      S_AXI_HPC1_FPD_0_arlen(7 downto 0) => S_AXI_HPC1_FPD_0_arlen(7 downto 0),
      S_AXI_HPC1_FPD_0_arlock => S_AXI_HPC1_FPD_0_arlock,
      S_AXI_HPC1_FPD_0_arprot(2 downto 0) => S_AXI_HPC1_FPD_0_arprot(2 downto 0),
      S_AXI_HPC1_FPD_0_arqos(3 downto 0) => S_AXI_HPC1_FPD_0_arqos(3 downto 0),
      S_AXI_HPC1_FPD_0_arready => S_AXI_HPC1_FPD_0_arready,
      S_AXI_HPC1_FPD_0_arsize(2 downto 0) => S_AXI_HPC1_FPD_0_arsize(2 downto 0),
      S_AXI_HPC1_FPD_0_aruser => S_AXI_HPC1_FPD_0_aruser,
      S_AXI_HPC1_FPD_0_arvalid => S_AXI_HPC1_FPD_0_arvalid,
      S_AXI_HPC1_FPD_0_awaddr(48 downto 0) => S_AXI_HPC1_FPD_0_awaddr(48 downto 0),
      S_AXI_HPC1_FPD_0_awburst(1 downto 0) => S_AXI_HPC1_FPD_0_awburst(1 downto 0),
      S_AXI_HPC1_FPD_0_awcache(3 downto 0) => S_AXI_HPC1_FPD_0_awcache(3 downto 0),
      S_AXI_HPC1_FPD_0_awid(5 downto 0) => S_AXI_HPC1_FPD_0_awid(5 downto 0),
      S_AXI_HPC1_FPD_0_awlen(7 downto 0) => S_AXI_HPC1_FPD_0_awlen(7 downto 0),
      S_AXI_HPC1_FPD_0_awlock => S_AXI_HPC1_FPD_0_awlock,
      S_AXI_HPC1_FPD_0_awprot(2 downto 0) => S_AXI_HPC1_FPD_0_awprot(2 downto 0),
      S_AXI_HPC1_FPD_0_awqos(3 downto 0) => S_AXI_HPC1_FPD_0_awqos(3 downto 0),
      S_AXI_HPC1_FPD_0_awready => S_AXI_HPC1_FPD_0_awready,
      S_AXI_HPC1_FPD_0_awsize(2 downto 0) => S_AXI_HPC1_FPD_0_awsize(2 downto 0),
      S_AXI_HPC1_FPD_0_awuser => S_AXI_HPC1_FPD_0_awuser,
      S_AXI_HPC1_FPD_0_awvalid => S_AXI_HPC1_FPD_0_awvalid,
      S_AXI_HPC1_FPD_0_bid(5 downto 0) => S_AXI_HPC1_FPD_0_bid(5 downto 0),
      S_AXI_HPC1_FPD_0_bready => S_AXI_HPC1_FPD_0_bready,
      S_AXI_HPC1_FPD_0_bresp(1 downto 0) => S_AXI_HPC1_FPD_0_bresp(1 downto 0),
      S_AXI_HPC1_FPD_0_bvalid => S_AXI_HPC1_FPD_0_bvalid,
      S_AXI_HPC1_FPD_0_rdata(127 downto 0) => S_AXI_HPC1_FPD_0_rdata(127 downto 0),
      S_AXI_HPC1_FPD_0_rid(5 downto 0) => S_AXI_HPC1_FPD_0_rid(5 downto 0),
      S_AXI_HPC1_FPD_0_rlast => S_AXI_HPC1_FPD_0_rlast,
      S_AXI_HPC1_FPD_0_rready => S_AXI_HPC1_FPD_0_rready,
      S_AXI_HPC1_FPD_0_rresp(1 downto 0) => S_AXI_HPC1_FPD_0_rresp(1 downto 0),
      S_AXI_HPC1_FPD_0_rvalid => S_AXI_HPC1_FPD_0_rvalid,
      S_AXI_HPC1_FPD_0_wdata(127 downto 0) => S_AXI_HPC1_FPD_0_wdata(127 downto 0),
      S_AXI_HPC1_FPD_0_wlast => S_AXI_HPC1_FPD_0_wlast,
      S_AXI_HPC1_FPD_0_wready => S_AXI_HPC1_FPD_0_wready,
      S_AXI_HPC1_FPD_0_wstrb(15 downto 0) => S_AXI_HPC1_FPD_0_wstrb(15 downto 0),
      S_AXI_HPC1_FPD_0_wvalid => S_AXI_HPC1_FPD_0_wvalid,
      S_AXI_LPD_0_araddr(48 downto 0) => S_AXI_LPD_0_araddr(48 downto 0),
      S_AXI_LPD_0_arburst(1 downto 0) => S_AXI_LPD_0_arburst(1 downto 0),
      S_AXI_LPD_0_arcache(3 downto 0) => S_AXI_LPD_0_arcache(3 downto 0),
      S_AXI_LPD_0_arid(5 downto 0) => S_AXI_LPD_0_arid(5 downto 0),
      S_AXI_LPD_0_arlen(7 downto 0) => S_AXI_LPD_0_arlen(7 downto 0),
      S_AXI_LPD_0_arlock => S_AXI_LPD_0_arlock,
      S_AXI_LPD_0_arprot(2 downto 0) => S_AXI_LPD_0_arprot(2 downto 0),
      S_AXI_LPD_0_arqos(3 downto 0) => S_AXI_LPD_0_arqos(3 downto 0),
      S_AXI_LPD_0_arready => S_AXI_LPD_0_arready,
      S_AXI_LPD_0_arsize(2 downto 0) => S_AXI_LPD_0_arsize(2 downto 0),
      S_AXI_LPD_0_aruser => S_AXI_LPD_0_aruser,
      S_AXI_LPD_0_arvalid => S_AXI_LPD_0_arvalid,
      S_AXI_LPD_0_awaddr(48 downto 0) => S_AXI_LPD_0_awaddr(48 downto 0),
      S_AXI_LPD_0_awburst(1 downto 0) => S_AXI_LPD_0_awburst(1 downto 0),
      S_AXI_LPD_0_awcache(3 downto 0) => S_AXI_LPD_0_awcache(3 downto 0),
      S_AXI_LPD_0_awid(5 downto 0) => S_AXI_LPD_0_awid(5 downto 0),
      S_AXI_LPD_0_awlen(7 downto 0) => S_AXI_LPD_0_awlen(7 downto 0),
      S_AXI_LPD_0_awlock => S_AXI_LPD_0_awlock,
      S_AXI_LPD_0_awprot(2 downto 0) => S_AXI_LPD_0_awprot(2 downto 0),
      S_AXI_LPD_0_awqos(3 downto 0) => S_AXI_LPD_0_awqos(3 downto 0),
      S_AXI_LPD_0_awready => S_AXI_LPD_0_awready,
      S_AXI_LPD_0_awsize(2 downto 0) => S_AXI_LPD_0_awsize(2 downto 0),
      S_AXI_LPD_0_awuser => S_AXI_LPD_0_awuser,
      S_AXI_LPD_0_awvalid => S_AXI_LPD_0_awvalid,
      S_AXI_LPD_0_bid(5 downto 0) => S_AXI_LPD_0_bid(5 downto 0),
      S_AXI_LPD_0_bready => S_AXI_LPD_0_bready,
      S_AXI_LPD_0_bresp(1 downto 0) => S_AXI_LPD_0_bresp(1 downto 0),
      S_AXI_LPD_0_bvalid => S_AXI_LPD_0_bvalid,
      S_AXI_LPD_0_rdata(127 downto 0) => S_AXI_LPD_0_rdata(127 downto 0),
      S_AXI_LPD_0_rid(5 downto 0) => S_AXI_LPD_0_rid(5 downto 0),
      S_AXI_LPD_0_rlast => S_AXI_LPD_0_rlast,
      S_AXI_LPD_0_rready => S_AXI_LPD_0_rready,
      S_AXI_LPD_0_rresp(1 downto 0) => S_AXI_LPD_0_rresp(1 downto 0),
      S_AXI_LPD_0_rvalid => S_AXI_LPD_0_rvalid,
      S_AXI_LPD_0_wdata(127 downto 0) => S_AXI_LPD_0_wdata(127 downto 0),
      S_AXI_LPD_0_wlast => S_AXI_LPD_0_wlast,
      S_AXI_LPD_0_wready => S_AXI_LPD_0_wready,
      S_AXI_LPD_0_wstrb(15 downto 0) => S_AXI_LPD_0_wstrb(15 downto 0),
      S_AXI_LPD_0_wvalid => S_AXI_LPD_0_wvalid,
      peripheral_aresetn(0) => peripheral_aresetn(0),
      pl_clk0 => pl_clk0,
      pl_ps_irq0_0(0) => pl_ps_irq0_0(0)
    );
end STRUCTURE;
