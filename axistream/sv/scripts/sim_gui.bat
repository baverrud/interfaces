@echo off
:: =====================================================================
:: sim_gui.bat - launch ModelSim simulation (GUI, non-project)
:: =====================================================================
:: Run from the project root:
::   scripts\sim_gui.bat
::
:: Prerequisite: run 'm20' or 'q25' first to set PATH.
:: =====================================================================

setlocal

set "SCRIPT_DIR=%~dp0..\..\..\scripts"
set "PROJ_DIR=%~dp0"

vsim.exe -gui -do "set GUI 1; do {%SCRIPT_DIR%\modelsim.tcl}"

endlocal
