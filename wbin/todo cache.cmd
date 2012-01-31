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
::* FILE_SCCS = "@(#)tt cache.cmd	005	(12-Nov-2011)	tools";
::
::* REVISION	DATE		REMARKS 
::	005	12-Nov-2011	Replace invocation of "what" and "summary" with
::				dedicated "dashboard" add-on. 
::	004	25-May-2011	XXX: Inexplicable caching of the former day's
::				todos yet correctly updated modification date in
::				conjunction with Dropbox sync, when run at the
::				beginning of a new day. Strangely, the problem
::				doesn't show when run under a wrapper that turns
::				on debug output. Trying to workaround this via a
::				30 second delay. 
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
setlocal enableextensions

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
:: Note: This assumes a date format that starts with the day,
:: i.e. 12-May-2011 10:53
if not "%date:~0,2%" == "%cacheModificationDate:~0,2%" (ping -n 30 localhost >NUL 2>&1 & goto:run)

:: Use the cache when the data file has not been changed today. 
if "%oldModificationDate%" == "%modificationDate%" (
    type "%cacheFile%"
    (goto:EOF)
)

:run
:: Record current modification date of data file for next run. 
echo.%modificationDate%> "%dateStore%"

:: Refresh cache contents. 
set DEBUG=&call tt.cmd -p dashboard > "%cacheFile%"
:: And print them. 
type "%cacheFile%"

endlocal
