@echo off
:: =====================================================================
:: sim.bat - launch ModelSim simulation (batch, non-project)
:: =====================================================================
:: Run from the project root:
::   scripts\sim.bat
::
:: Prerequisite: run 'm20' or 'q25' first to set PATH.
:: =====================================================================

setlocal

set "SCRIPT_DIR=%~dp0..\..\..\scripts"
set "PROJ_DIR=%~dp0"

vsim.exe -c -do "%SCRIPT_DIR%\modelsim.tcl"

endlocal
