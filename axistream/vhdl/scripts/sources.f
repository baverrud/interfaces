# =====================================================================
# sources.f - source manifest and project configuration
# =====================================================================
# Format:  <keyword>  <value>
#
# File list (ORDER MATTERS: dependencies first):
#   design  <path>   synthesis + simulation source
#   sim     <path>   simulation-only (testbench)
#
# Configuration:
#   top     <module> top-level simulation module
#   name    <name>   project name (ModelSim .mpf / Vivado project)
#   part    <part>   FPGA part number (Vivado)
#   simdir  <dir>    simulation output dir (relative to this file)
#   vivdir  <dir>    Vivado output dir (relative to this file)
#
# Paths are relative to this file's directory.
# Blank lines and lines starting with '#' are ignored.
# =====================================================================
#
# ---- File list ------------------------------------------------------
design  ../../../lib/vhdl/stream_pkg.vhd
design  ../../../common/axistream_pkg/rtl/payload_pkg.vhd
design  ../../../common/sync_fifo/rtl/sync_fifo.vhd
design  ../../../common/stream_fifo/rtl/stream_fifo.vhd
design  ../../../common/pixel/rtl/pixel_producer.vhd
design  ../../../common/pixel/rtl/pixel_consumer.vhd
design  ../rtl/top.vhd
sim     ../tb/top_tb.vhd

# ---- Configuration --------------------------------------------------
top     top_tb
name    top
part    xc7s6cpga196-1
simdir  ../sim
vivdir  ../viv
