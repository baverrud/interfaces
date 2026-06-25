# =====================================================================
# sources.f - AXI4-Lite SV project source manifest
# =====================================================================
design  ../../../lib/sv/axilite_if.sv          # shared AXI4-Lite interface (full + sub-channel modports)
design  rtl/axilite_master.sv                  # full master (drives all channels)
design  rtl/axilite_write_master.sv            # write-only master (aw_src/w_src/b_sink)
design  rtl/axilite_read_master.sv             # read-only master  (ar_src/r_sink)
design  rtl/axilite_slave.sv                   # full slave  (responds on all channels)
design  rtl/axilite_write_slave.sv             # write-only slave (aw_sink/w_sink/b_src)
design  rtl/axilite_read_slave.sv              # read-only slave  (ar_sink/r_src)
design  rtl/top.sv                             # full master + full slave (master/slave modports)
design  rtl/top_sub.sv                         # split masters + full slave (sub-channel modports)
design  rtl/top_sub_slave.sv                   # split masters + split slaves (full sub-channel)
sim     tb/top_tb.sv                           # tests top: full write/read, pattern 0xA5A5A5A5
sim     tb/top_sub_tb.sv                       # tests top_sub: split masters, pattern 0xB0B0B0B0
sim     tb/top_sub_slave_tb.sv                 # tests top_sub_slave: full split, pattern 0xC0C0C0C0

# ---- Configuration --------------------------------------------------
top     top_tb
name    top
part    xc7s6cpga196-1
simdir  sim
vivdir  viv
