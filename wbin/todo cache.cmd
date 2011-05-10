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
::* FILE_SCCS = "@(#)tt cache.cmd	003	(14-Aug-2010)	tools";
::
::* REVISION	DATE		REMARKS 
::	003	14-Aug-2010	Simplified by determining the cache's age from
::				the modification date of the dateStore instead
::				of explicitly reading it. 
::	002	14-Aug-2010	BUG: No caching when the modification date is
::				from yesterday; the refresh for a new day runs
::				all the time (until todo.txt is updated). Now
::				storing both oldModificationDate and lastRunDay
::				in the dateStore. 
::	001	29-Jun-2010	file creation
::*****************************************************************************/

set dateStore=%TEMP%\%~n0.dat
set cacheFile=%TEMP%\%~n0.txt
set isModified=

:: Read modification date of data file. 
for %%f in ("%HOME%\todo\todo.txt") do set modificationDate=%%~tf
:: Check that cache is still existent.  
if not exist "%dateStore%" (goto:run)
if not exist "%cacheFile%" (goto:run)

:: Read recorded data file modification date from cache and the cache's age. 
for /F "delims=" %%o in ('type "%dateStore%"') do set oldModificationDate=%%o
for %%f in ("%dateStore%") do set cacheModificationDate=%%~tf

:: Refresh the cache when a new day has started, to avoid showing stale data. 
:: (New tasks may have been scheduled on a new day.) 
if not "%date:~0,2%" == "%cacheModificationDate:~0,2%" (goto:run)

:: Use the cache when the data file has not been changed today. 
if "%oldModificationDate%" == "%modificationDate%" (
    type "%cacheFile%"
    (goto:EOF)
)

:run
:: Record current modification date of data file for next run. 
echo.%modificationDate%> "%dateStore%"

:: Refresh cache contents. 
(call tt.cmd -p what && call tt.cmd -p summary)>"%cacheFile%"
:: And print them. 
type "%cacheFile%"
