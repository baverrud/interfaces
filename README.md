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

Run the appropriate environment setup in a **cmd.exe** window before launching any scripts:

| Tool            | Command | Installed at                     |
|-----------------|---------|----------------------------------|
| ModelSim 2020.1 | `m20`   | `C:\intelFPGA\20.1\modelsim_ase` |
| Questa 2025.2   | `q25`   | `C:\altera\25.1std\questa_fse`   |
| Vivado 2025.2   | `v25`   | `C:\Xilinx\2025.2\Vivado`        |
| Vivado 2023.2   | `v23`   | `C:\Xilinx\Vivado\2023.2`        |

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
