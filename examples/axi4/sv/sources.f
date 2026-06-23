# =====================================================================
# sources.f - AXI4 project source manifest
# =====================================================================
design  ../../../lib/sv/axi4_if.sv
design  rtl/axi4_master.sv
design  rtl/axi4_write_master.sv
design  rtl/axi4_read_master.sv
design  rtl/axi4_slave.sv
design  rtl/axi4_write_slave.sv
design  rtl/axi4_read_slave.sv
design  rtl/top.sv
design  rtl/top_sub.sv
design  rtl/top_sub_slave.sv
sim     tb/top_tb.sv
sim     tb/top_sub_tb.sv
sim     tb/top_sub_slave_tb.sv

# ---- Configuration --------------------------------------------------
top     top_tb
name    top
part    xc7s6cpga196-1
simdir  sim
vivdir  viv
