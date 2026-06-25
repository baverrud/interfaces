# =====================================================================
# sources.f - AXI3 VHDL project source manifest
# =====================================================================
design  ../../../lib/vhdl/axi3_pkg.vhd       # shared AXI3 package (per-channel + HP views)
design  rtl/axi3_master.vhd                  # full master (drives all channel views)
design  rtl/axi3_write_master.vhd            # write-only master (master_aw/w/b)
design  rtl/axi3_read_master.vhd             # read-only master  (master_ar/r)
design  rtl/axi3_slave.vhd                   # full slave  (all slave_* views)
design  rtl/axi3_write_slave.vhd             # write-only slave (slave_aw/w/b)
design  rtl/axi3_read_slave.vhd              # read-only slave  (slave_ar/r)
design  rtl/top.vhd                          # full master + full slave (per-channel records)
design  rtl/top_split.vhd                    # split masters +/- split slaves (generate)
design  rtl/axi3_master_hp.vhd               # HP master  (composite master_hp view)
design  rtl/axi3_slave_hp.vhd                # HP slave   (composite slave_hp view)
design  rtl/top_hp.vhd                       # HP constrained bus (axi3_hp_t, 64b data)
sim     tb/top_tb.vhd                        # tests top: full write/read burst, pattern 0xA0
sim     tb/top_split_tb.vhd                  # tests top_split: split masters, pattern 0xB0/0xC0
sim     tb/top_hp_tb.vhd                     # tests top_hp: HP bus, completion check

# ---- Unified-record bus (intentionally broken - >6 unconstrained elements) ----
# design  rtl/axi3_master_unified.vhd          # full master with unified axi3_t view (BROKEN)
# design  rtl/axi3_slave_unified.vhd           # full slave  with unified axi3_t view (BROKEN)
# design  rtl/top_unified.vhd                  # top with unified axi3_t bus (BROKEN)
# sim     tb/top_unified_tb.vhd                # TB for top_unified (BROKEN)

# ---- Configuration --------------------------------------------------
top     top_tb
name    top
part    xc7s6cpga196-1
simdir  sim
vivdir  viv
