# =====================================================================
# sources.f - AXI4-Stream SV project source manifest
# =====================================================================
design  ../../../lib/sv/axis_if.sv               # shared AXI4-Stream interface (tx/rx modports)
design  rtl/payload_pkg.sv                     # packed struct types (pixel_t, iq_t)
design  ../../COMMON/sync_fifo/sync_fifo.sv      # type-generic FWFT synchronous FIFO
design  ../../COMMON/stream_fifo/stream_fifo.sv  # AXI-Stream wrapper around sync_fifo
design  rtl/pixel_producer.sv                     # RGB pixel stream source
design  rtl/pixel_consumer.sv                     # RGB pixel stream sink
design  rtl/top.sv                               # top: producer -> stream_fifo -> consumer
sim     tb/top_tb.sv                             # self-checking TB (pack/unpack, IQ, pixel)

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
