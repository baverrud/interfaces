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
design  rtl/top_subtype.vhd                       # top with pixel_stream_t subtype
design  rtl/top_constrained.vhd                   # self-contained 32-bit constrained record demo
design  rtl/top_array.vhd                         # N parallel pixel lanes via axis_array_t
sim     tb/top_tb.vhd                             # self-checking TB (pack/unpack, IQ, pixel)
sim     tb/top_subtype_tb.vhd                     # TB for the subtype-based top
sim     tb/top_constrained_tb.vhd                 # TB for the constrained record demo
sim     tb/top_array_tb.vhd                       # TB for the array-of-streams demo

# ---- Configuration --------------------------------------------------
top     top_tb
top     top_subtype_tb
top     top_constrained_tb
top     top_array_tb
name    top
part    xc7s6cpga196-1
simdir  sim
vivdir  viv
