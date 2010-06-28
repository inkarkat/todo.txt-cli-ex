@echo off %DEBUG%
::/*****************************************************************************
::**
::* FILE: 	tt cache.cmd
::* PRODUCT:	tools
::* AUTHOR: 	/^--
::* DATE CREATED:29-Jun-2010
::*
::******************************************************************************
::* CONTENTS: 
::	Running the todo.txt commands under Cygwin is costly under Windows; the
::	CPU is maxed for a couple of seconds, as many lightweight Unix processes
::	are launched. 
::	This script caches the output as long as the todo.txt data file hasn't
::	been changed. 
::* REMARKS: 
::       	
::* FILE_SCCS = "@(#)tt cache.cmd	001	(29-Jun-2010)	tools";
::
::* REVISION	DATE		REMARKS 
::	001	29-Jun-2010	file creation
::*****************************************************************************/

set dateStore=%TEMP%\%~n0.dat
set cacheFile=%TEMP%\%~n0.txt
set isModified=

for %%f in (%HOME%\todo\todo.txt) do set modificationDate=%%~tf
if not exist "%dateStore%" (goto:run)
if not exist "%cacheFile%" (goto:run)

for /F "delims=" %%o in ('type "%dateStore%"') do set oldDate=%%o
if "%oldDate%" == "%modificationDate%" (
    type "%cacheFile%"
    (goto:EOF)
)

:run
echo.%modificationDate%> "%dateStore%"

(call tt.cmd -p what && call tt.cmd -p summary)>"%cacheFile%"
type "%cacheFile%"
