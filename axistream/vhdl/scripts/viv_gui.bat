@echo off
:: =====================================================================
:: viv_gui.bat - launch Vivado (GUI mode: create project, leave open)
:: =====================================================================
:: Run from the project root:
::   scripts\viv_gui.bat
::
:: Prerequisite: run 'v25' first to set PATH.
:: =====================================================================

setlocal

set "SCRIPT_DIR=%~dp0..\..\..\common\scripts"
set "PROJ_DIR=%~dp0"

if not exist "%PROJ_DIR%..\viv" mkdir "%PROJ_DIR%..\viv"
cd /d "%PROJ_DIR%..\viv"

vivado -source "%SCRIPT_DIR%\vivado.tcl"

endlocal
