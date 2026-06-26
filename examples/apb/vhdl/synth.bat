@echo off
:: synth.bat - synthesize a top.
python "%~dp0..\..\..\common\scripts\engine.py" synth "%~dp0." %*
