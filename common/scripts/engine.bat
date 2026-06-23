@echo off
:: =====================================================================
:: engine.bat - shared simulate / synthesize dispatcher
:: =====================================================================
:: Invoked by a subproject's sim.bat / synth.bat wrapper:
::
::   call engine.bat <verb> <scriptsdir> <target> [tokens...]
::
::   verb     : sim | synth
::   target   : <name> | all
::   tokens   : modelsim | xsim | vivado | gui | prj   (order-independent)
::
:: Examples (as exposed by sim.bat / synth.bat):
::   sim   top_tb              default tool (ModelSim), batch
::   sim   top_tb gui          ModelSim GUI
::   sim   top_tb prj          ModelSim project-mode GUI
::   sim   top_tb xsim         Vivado xsim, batch
::   sim   top_tb xsim gui     Vivado xsim, GUI
::   sim   all                 every testbench, batch
::   synth top                 default tool (Vivado), batch
::   synth top gui             Vivado GUI (project left open)
::   synth all                 every top, batch
:: =====================================================================
setlocal enabledelayedexpansion

set "COMMON=%~dp0"
set "VERB=%~1"
set "PROJ_DIR=%~2"
set "TARGET=%~3"

if "%VERB%"==""   goto :usage
if "%TARGET%"=="" goto :usage

:: ---- defaults -------------------------------------------------------
if /i "%VERB%"=="sim" ( set "BACKEND=modelsim" ) else ( set "BACKEND=vivado" )
set "DISPLAY=batch"
set "FLAVOR=lib"

:: ---- scan optional, order-independent tokens ------------------------
shift
shift
shift
:scan
if "%~1"=="" goto :scandone
set "TOK=%~1"
set "KNOWN="
if /i "!TOK!"=="modelsim" ( set "BACKEND=modelsim" & set "KNOWN=1" )
if /i "!TOK!"=="xsim"     ( set "BACKEND=vivado"   & set "KNOWN=1" )
if /i "!TOK!"=="vivado"   ( set "BACKEND=vivado"   & set "KNOWN=1" )
if /i "!TOK!"=="gui"      ( set "DISPLAY=gui"      & set "KNOWN=1" )
if /i "!TOK!"=="prj"      ( set "FLAVOR=prj" & set "DISPLAY=gui" & set "KNOWN=1" )
if not defined KNOWN (
    echo.
    echo ERROR: unknown option '!TOK!'
    goto :usage
)
shift
goto :scan
:scandone

:: ---- validation rules ----------------------------------------------
if /i "%VERB%"=="synth" if "%BACKEND%"=="modelsim" (
    echo ERROR: 'synth' requires Vivado ^(ModelSim cannot synthesize^).
    exit /b 1
)
if "%FLAVOR%"=="prj" (
    if /i not "%VERB%"=="sim" (
        echo ERROR: 'prj' is a simulation mode, not valid for synth.
        exit /b 1
    )
    if not "%BACKEND%"=="modelsim" (
        echo ERROR: 'prj' is a ModelSim-only mode.
        exit /b 1
    )
)
if /i "%TARGET%"=="all" if "%DISPLAY%"=="gui" (
    echo ERROR: 'gui'/'prj' require a single target, not 'all'.
    exit /b 1
)

:: ---- file-existence check (single target only) ---------------------
if /i not "%TARGET%"=="all" (
    if /i "%VERB%"=="sim" ( set "CHKDIR=tb" ) else ( set "CHKDIR=rtl" )
    set "CHKNAME=%TARGET%"
    if /i "%VERB%"=="synth" if /i "%TARGET:~-3%"=="_tb" set "CHKNAME=%TARGET:_tb=%"
    set "FOUND="
    if exist "%PROJ_DIR%..\!CHKDIR!\!CHKNAME!.sv"   set "FOUND=1"
    if exist "%PROJ_DIR%..\!CHKDIR!\!CHKNAME!.vhd"  set "FOUND=1"
    if exist "%PROJ_DIR%..\!CHKDIR!\!CHKNAME!.vhdl" set "FOUND=1"
    if not defined FOUND (
        echo.
        echo ERROR: %VERB% target '%TARGET%' not found in !CHKDIR!\
        echo        ^(looked for !CHKNAME!.sv / .vhd / .vhdl^)
        exit /b 1
    )
)

:: ---- launch ---------------------------------------------------------
echo INFO: %VERB% target=%TARGET% backend=%BACKEND% display=%DISPLAY% flavor=%FLAVOR%

if "%BACKEND%"=="modelsim" (
    set "SIM_TOP_OVERRIDE=%TARGET%"
    if "%FLAVOR%"=="prj" ( set "TCL=%COMMON%modelsim_prj.tcl" ) else ( set "TCL=%COMMON%modelsim.tcl" )
    if "%DISPLAY%"=="gui" (
        vsim.exe -gui -do "set GUI 1; do {!TCL!}"
    ) else (
        vsim.exe -c -do "!TCL!"
    )
) else (
    set "VIV_TOP_OVERRIDE=%TARGET%"
    if not exist "%PROJ_DIR%..\viv" mkdir "%PROJ_DIR%..\viv"
    pushd "%PROJ_DIR%..\viv"
    if /i "%VERB%"=="sim" ( set "MODEFLAG=-sim" ) else ( set "MODEFLAG=-synth" )
    set "ALLFLAG="
    if /i "%TARGET%"=="all" set "ALLFLAG=-all"
    if "%DISPLAY%"=="gui" (
        vivado -source "%COMMON%vivado.tcl" -tclargs !MODEFLAG! !ALLFLAG! -gui
    ) else (
        vivado -mode batch -source "%COMMON%vivado.tcl" -tclargs !MODEFLAG! !ALLFLAG!
    )
    popd
)

endlocal
exit /b 0

:usage
echo.
echo Usage:
echo   sim   ^<tb^|all^>   [modelsim^|xsim] [gui^|prj]
echo   synth ^<top^|all^>  [vivado]        [gui]
echo.
echo Tokens (order-independent):
echo   modelsim   simulate with ModelSim/Questa   (sim default)
echo   xsim       simulate with Vivado xsim
echo   vivado     synthesize with Vivado          (synth default)
echo   gui        launch the tool GUI (single target only)
echo   prj        ModelSim project-mode GUI (single target only)
echo.
echo Examples:
echo   sim   top_tb
echo   sim   top_tb gui
echo   sim   top_tb prj
echo   sim   top_tb xsim
echo   sim   top_tb xsim gui
echo   sim   all
echo   synth top
echo   synth top gui
echo   synth all
echo.
endlocal
exit /b 1
