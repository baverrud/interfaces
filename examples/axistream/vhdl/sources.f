# =====================================================================
# sources.f - AXI4-Stream VHDL project source manifest
# =====================================================================
design  ../../../lib/vhdl/axis_pkg.vhd           # shared AXI4-Stream package (axis_t + mode views)
design  rtl/payload_pkg.vhd                     # structured payload types + pack/unpack
design  ../../COMMON/sync_fifo/sync_fifo.vhd      # generic-width FWFT synchronous FIFO
design  ../../COMMON/stream_fifo/stream_fifo.vhd  # AXI-Stream wrapper around sync_fifo
design  rtl/pixel_producer.vhd                     # RGB pixel stream source
design  rtl/pixel_consumer.vhd                     # RGB pixel stream sink
design  rtl/top.vhd                               # top: producer -> stream_fifo -> consumer
sim     tb/top_tb.vhd                             # self-checking TB (pack/unpack, IQ, pixel)

# ---- Configuration --------------------------------------------------
top     top_tb
name    top
part    xc7s6cpga196-1
simdir  sim
vivdir  viv
top     top_tb
name    top
part    xc7s6cpga196-1
simdir  sim
vivdir  viv
