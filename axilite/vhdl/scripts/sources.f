# =====================================================================
# sources.f - AXI4-Lite VHDL project source manifest
# =====================================================================
design  ../../../lib/vhdl/axilite_pkg.vhd
design  ../../../common/axil_reg/rtl/axil_reg.vhd
design  ../rtl/top.vhd
sim     ../tb/top_tb.vhd

# ---- Configuration --------------------------------------------------
top     top_tb
name    top
part    xc7s6cpga196-1
simdir  ../sim
vivdir  ../viv
