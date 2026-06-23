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
design  ../../../lib/sv/axis_if.sv
design  ../../../common/hdl/axistream_pkg/stream_pkg.sv
design  ../../../common/hdl/sync_fifo/sync_fifo.sv
design  ../../../common/hdl/stream_fifo/stream_fifo.sv
design  ../../../common/hdl/pixel/pixel_producer.sv
design  ../../../common/hdl/pixel/pixel_consumer.sv
design  ../rtl/top.sv
sim     ../tb/top_tb.sv

# ---- Configuration --------------------------------------------------
top     top_tb
name    top
part    xc7s6cpga196-1
simdir  ../sim
vivdir  ../viv
