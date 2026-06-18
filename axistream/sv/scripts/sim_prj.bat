@echo off
:: =====================================================================
:: sim_prj.bat - launch ModelSim in PROJECT mode
:: =====================================================================
:: Run from the project root:
::   scripts\sim_prj.bat
::
:: Prerequisite: run 'm20' or 'q25' first to set PATH.
:: =====================================================================

setlocal

set "SCRIPT_DIR=%~dp0..\..\..\scripts"
set "PROJ_DIR=%~dp0"

vsim.exe -gui -do "set GUI 1; do {%SCRIPT_DIR%\modelsim_prj.tcl}"

endlocal
