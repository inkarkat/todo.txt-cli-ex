@echo off %DEBUG%
::/*****************************************************************************
::**
::* FILE: 	todo cache.cmd
::* PRODUCT:	tools
::* AUTHOR: 	Ingo Karkat <ingo@karkat.de>
::* DATE CREATED:29-Jun-2010
::*
::******************************************************************************
::* CONTENTS:
::	Running the todo.txt commands under Cygwin is costly under Windows; the
::	CPU is maxed for a couple of seconds, as many lightweight Unix processes
::	are launched.
::	This script caches the output as long as the todo.txt data file hasn't
::	been changed.
::
::* DEPENDENCIES:
::  - Unix "tee" command.
::
::* COPYRIGHT: (C) 2010-2014 Ingo Karkat
::	This program is free software; you can redistribute it and/or modify it
::	under the terms of the GNU General Public License.
::	See http://www.gnu.org/copyleft/gpl.txt
::
::* FILE_SCCS = "@(#)todo cache.cmd	013	(20-Jun-2014)	todo.txt-cli-ex";
::
::* REVISION	DATE		REMARKS
::	013	20-Jun-2014	Rename the dataStore into recordStore; the file
::				so far already stored the todo file size in
::				addition to the modification date.
::				As the script arguments affect the task
::				filtering, these are added to the record, so
::				when there's a change in them, the cache is
::				invalidated.
::				Avoid the use of type command via usebackq
::				option.
::	012	13-Nov-2013	Show the previous cache (with a warning) when
::				the todo.sh command yields no output at all.
::				XXX: Capturing stderr has the strange side
::				effect (but only when running under Samurize!)
::				that the final type "%cacheFile%" is also
::				captured in the cache file itself, leading to
::				duplicated output. Couldn't find the root cause,
::				but working around with "tee" prevents the
::				problem, and has the slight advantage that
::				now partial information is shown before the next
::				full update, at the cost of an added dependency.
::	011	06-Nov-2013	Also capture stderr in the cache file. I've
::				implemented a check for Dropbox conflicts and
::				want that visible on my Desktop, too.
::	010	25-Nov-2012	Add the size of todo.txt to the timestamp to
::				avoid that updates within the same minute are
::				overlooked due to the low precision of the
::				file's modification date.
::	009	26-May-2012	Rename to todo.cmd, and have separate tt alias.
::	008	13-Mar-2012	Allow to override todo.txt location via
::				TODO_FILE.
::	007	03-Feb-2012	Don't use relative times in todo.txt.
::	006	01-Feb-2012	Pass command-line arguments along.
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

set recordStore=%TEMP%\%~n0.dat
set cacheFile=%TEMP%\%~n0.txt
set backupFile=%TEMP%\%~n0.bak
set isModified=

if not defined TODO_FILE (
    set TODO_FILE=%HOME%\todo\todo.txt
)

:: Read cache record (modification date, file size, script arguments) of data
:: file.
:: Note: Because the precision of the returned value is just one minute, let's
:: add the file's size to it. This prevents overlooking an update within the
:: same minute (as long as it changes the file size).
:: As the script arguments affect the task filtering, these are added to the
:: record, so when there's a change in them, the cache is invalidated.
for %%f in ("%TODO_FILE%") do set todoRecord=%%~tzf %*
:: Check that cache is still existent.
if not exist "%recordStore%" (goto:run)
if not exist "%cacheFile%" (goto:run)

:: Read recorded data file modification date from cache and the cache's age.
for /F "delims= usebackq" %%o in ("%recordStore%") do set oldCacheRecord=%%o

:: Refresh the cache when a new day has started, to avoid showing stale data.
:: (New tasks may have been scheduled on a new day.)
:: Note: This assumes a date format that starts with the day,
:: i.e. 12-May-2011 10:53 31337
for %%f in ("%recordStore%") do set cacheModificationDate=%%~tf
if not "%date:~0,2%" == "%cacheModificationDate:~0,2%" (ping -n 30 localhost >NUL 2>&1 & goto:run)

:: Use the cache when the data file has not been changed today.
if "%oldCacheRecord%" == "%todoRecord%" (
    type "%cacheFile%"
    (goto:EOF)
)

:run
:: Record current modification date of data file for next run.
echo.%todoRecord%> "%recordStore%"

:: Save the old cache contents in case the task report now fails.
move /Y "%cacheFile%" "%backupFile%" >NUL 2>&1

:: Immediately create a new empty cache file so that when this script is invoked
:: concurrently, it won't create a race to refresh the cache.
copy /Y NUL "%cacheFile%" >NUL 2>&1

:: Refresh cache contents.
:: Don't use relative times ("5 minutes ago"), because the output is cached.
:: Relative dates ("yesterday") are fine, because the cache is refreshed every
:: day, anyway.
set DEBUG=&set TODOTXT_RELTIME=0&call todo.cmd -p dashboard %* 2>&1 | tee "%cacheFile%"

:: Rather than showing no tasks or errors, re-use the old cache file, with an
:: added warning. Drop the date store so that the refresh is attempted again on
:: the following run.
for %%s in ("%cacheFile%") do set cacheFileSize=%%~zs
if not exist "%cacheFile%" set cacheFileSize=0
if %cacheFileSize% EQU 0 (
    del /Q "%recordStore%"
    echo.TODO CACHE: Update of tasks failed, showing outdated tasks!
    move /Y "%backupFile%" "%cacheFile%" >NUL 2>&1
    type "%cacheFile%"
)

endlocal
