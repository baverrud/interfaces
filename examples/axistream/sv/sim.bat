@echo off
:: sim.bat - simulate a testbench.  See common\scripts\engine.py for full usage.
::   sim <tb|all> [modelsim|xsim] [gui|prj]
python "%~dp0..\..\..\common\scripts\engine.py" sim "%~dp0." %*
