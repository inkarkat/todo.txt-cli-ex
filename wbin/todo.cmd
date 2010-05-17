@echo off %DEBUG%
setlocal enableextensions

:: MSYS provides an old grep 2.4.2 that doesn't understand the -o option used by
:: todo.sh; so put the gnuwin32 Unix environment (with grep 2.5.4) in front of
:: the PATH. 
:: call msys-bash "%HOME%\bin\todo.sh" %*
set PATH=%~dp0gnuwin32\bin;%~dp0msys\bin;%PATH%
"%~dp0msys\bin\bash.exe" "%HOME%\bin\todo.sh" %*

endlocal
