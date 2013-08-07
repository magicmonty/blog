@ECHO OFF
ECHO Compiling CSS ...
cmd /C compass compile
IF ERRORLEVEL 1 GOTO compass_error

ECHO Building blog ...
node_modules\.bin\wintersmith build
IF ERRORLEVEL 1 GOTO build_error
GOTO quit

:compass_error
ECHO Error compiling css files
PAUSE
GOTO quit

:build_error
ECHO Error building blog
PAUSE
GOTO quit

:quit