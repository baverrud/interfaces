@echo off
:: synth.bat - synthesize a top.  See common\scripts\engine.py for full usage.
::   synth <top|all> [vivado] [gui]
python "%~dp0..\..\..\common\scripts\engine.py" synth "%~dp0." %*
