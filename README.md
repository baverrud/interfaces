# FPGA Interfaces

FPGA interface projects using SystemVerilog and VHDL.

## Repository Structure

```
interfaces/
├── scripts/              ← shared Tcl scripts (modelsim, vivado)
├── axistream/            ← AXI-Stream interface project
└── ...                   ← future sub-projects
```

## Prerequisites

Run the appropriate environment setup before launching any scripts.

## Workflow

```cmd
cd <sub-project>\sv
scripts\sim.bat              # batch simulation
scripts\sim_gui.bat          # GUI simulation
scripts\sim_prj.bat          # GUI simulation (project mode)
scripts\viv.bat              # batch Vivado (synth + sim)
scripts\viv_gui.bat          # GUI Vivado
```

Each sub-project contains its own `sources.f` that lists source files and configuration.
