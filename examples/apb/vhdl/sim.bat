@echo off
:: sim.bat - simulate a testbench.
python "%~dp0..\..\..\common\scripts\engine.py" sim "%~dp0." %*
