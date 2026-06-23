# =====================================================================
# sources.f - AXI4-Lite project source manifest
# =====================================================================
design  ../../../lib/sv/axilite_if.sv
design  ../../../common/axil_reg/rtl/axil_reg.sv
design  ../rtl/top.sv
sim     ../tb/top_tb.sv

# ---- Configuration --------------------------------------------------
top     top_tb
name    top
part    xc7s6cpga196-1
simdir  ../sim
vivdir  ../viv
