@echo off %DEBUG%
setlocal enableextensions

:: XXX: Even the login shell doesn't seem to source my .bashrc. 
set PATH=%HOME:\=/%/bin;%PATH%

set TODO_APP=%HOME%\bin\todo.sh
:: The ~/.todo.actions.d/ plugins that use $TODO_FULL_SH cannot cope with
:: backslashes.  
"C:\cygwin\bin\bash" --login "%TODO_APP:\=/%" %*

endlocal
