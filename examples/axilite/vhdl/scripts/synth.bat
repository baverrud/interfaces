@echo off
:: synth.bat - synthesize a top.  See common\scripts\engine.bat for full usage.
::   synth <top|all> [vivado] [gui]
call "%~dp0..\..\..\..\common\scripts\engine.bat" synth "%~dp0" %*
