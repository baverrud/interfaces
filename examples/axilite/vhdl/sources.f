# =====================================================================
# sources.f - AXI4-Lite VHDL project source manifest
# =====================================================================
design  ../../../lib/vhdl/axilite_pkg.vhd       # shared AXI4-Lite package (per-channel + M40 views)
design  rtl/axilite_master.vhd                  # full master (per-channel views)
design  rtl/axilite_write_master.vhd            # write-only master (master_aw/w/b)
design  rtl/axilite_read_master.vhd             # read-only master  (master_ar/r)
design  rtl/axilite_slave.vhd                   # full slave  (all slave_* views)
design  rtl/axilite_write_slave.vhd             # write-only slave (slave_aw/w/b)
design  rtl/axilite_read_slave.vhd              # read-only slave  (slave_ar/r)
design  rtl/top.vhd                             # full master + full slave (per-channel records)
design  rtl/top_split.vhd                       # split masters +/- split slaves (generate)
design  rtl/axilite_master_m40.vhd              # M40 master  (composite master_m40 view)
design  rtl/axilite_slave_m40.vhd               # M40 slave   (composite slave_m40 view)
design  rtl/top_m40.vhd                         # M40 constrained bus (axilite_m40_t, 40b addr)
sim     tb/top_tb.vhd                           # tests top: full write/read, pattern 0xA5A5A5A5
sim     tb/top_split_tb.vhd                     # tests top_split: split masters, pattern 0xB0/0xC0
sim     tb/top_m40_tb.vhd                       # tests top_m40: M40 bus, completion + data check

# ---- Configuration --------------------------------------------------
top     top_tb
name    top
part    xc7s6cpga196-1
simdir  sim
vivdir  viv
