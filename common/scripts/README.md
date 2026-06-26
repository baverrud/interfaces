# Build Scripts

Cross-platform Python dispatcher with EDA tool Tcl backends.

| File | Purpose |
|------|---------|
| `engine.py` | Python dispatcher — parses `sources.f`, invokes backend |
| `modelsim.tcl` | ModelSim/Questa simulation backend |
| `modelsim_prj.tcl` | ModelSim project-mode GUI backend |
| `vivado.tcl` | Vivado synthesis and xsim simulation backend |

Usage: `python engine.py <sim|synth> <proj_dir> <target> [options]`
