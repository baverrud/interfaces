@echo off
:: =====================================================================
:: viv.bat - launch Vivado (batch mode: synth + sim, then exit)
:: =====================================================================
:: Run from the project root:
::   scripts\viv.bat
::
:: Prerequisite: run 'v25' first to set PATH.
:: =====================================================================

setlocal

set "SCRIPT_DIR=%~dp0..\..\..\common\scripts"
set "PROJ_DIR=%~dp0"

if not exist "%PROJ_DIR%..\viv" mkdir "%PROJ_DIR%..\viv"
cd /d "%PROJ_DIR%..\viv"

vivado -mode batch -source "%SCRIPT_DIR%\vivado.tcl" -tclargs -run

endlocal
