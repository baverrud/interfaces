@echo off
:: sim.bat - simulate a testbench.  See common\scripts\engine.bat for full usage.
::   sim <tb|all> [modelsim|xsim] [gui|prj]
call "%~dp0..\..\..\common\scripts\engine.bat" sim "%~dp0" %*
