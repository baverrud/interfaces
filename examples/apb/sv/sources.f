# sources.f - APB project source manifest
design  ../../../lib/sv/apb_if.sv          # shared APB interface
design  rtl/master.sv
design  rtl/slave.sv
design  rtl/top.sv
sim     tb/top_tb.sv                     # self-checking testbench
top     top_tb
name    top
part    xc7s6cpga196-1
simdir  sim
vivdir  viv
