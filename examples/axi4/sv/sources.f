# =====================================================================
# sources.f - AXI4 project source manifest
# =====================================================================
design  ../../../lib/sv/axi4_if.sv          # shared AXI4 interface (full + sub-channel modports)
design  rtl/axi4_master.sv                  # full master (drives all channels)
design  rtl/axi4_write_master.sv            # write-only master (aw_src/w_src/b_sink)
design  rtl/axi4_read_master.sv             # read-only master  (ar_src/r_sink)
design  rtl/axi4_slave.sv                   # full slave  (responds on all channels)
design  rtl/axi4_write_slave.sv             # write-only slave (aw_sink/w_sink/b_src)
design  rtl/axi4_read_slave.sv              # read-only slave  (ar_sink/r_src)
design  rtl/top.sv                          # full master + full slave (master/slave modports)
design  rtl/top_sub.sv                      # split masters + full slave (sub-channel modports)
design  rtl/top_sub_slave.sv                # split masters + split slaves (full sub-channel)
sim     tb/top_tb.sv                        # tests top: full write/read burst, pattern 0xA0
sim     tb/top_sub_tb.sv                    # tests top_sub: split masters, pattern 0xB0
sim     tb/top_sub_slave_tb.sv              # tests top_sub_slave: full split, pattern 0xC0

# ---- Configuration --------------------------------------------------
top     top_tb
name    top
part    xc7s6cpga196-1
simdir  sim
vivdir  viv
