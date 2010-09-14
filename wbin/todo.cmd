@echo off %DEBUG%
setlocal enableextensions

set TODO_APP=%HOME%\bin\todo.sh
:: The ~/.todo.actions.d/ plugins that use $TODO_FULL_SH cannot cope with
:: backslashes.  
"C:\cygwin\bin\bash" --login "%TODO_APP:\=/%" %*

endlocal
