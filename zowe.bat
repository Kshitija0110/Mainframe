@echo off
setlocal enabledelayedexpansion
cd C:\Users\DELL\AppData\Roaming\npm
REM Set your connection details
set HOST=204.90.115.200
set PORT=443
set USER=Z55188
set JCL_DATASET=Z55188.JCL(HELLOWD)

REM Submit the JCL and capture the job ID
echo Submitting JCL job...
for /f "tokens=*" %%i in ('zowe zos-jobs submit ds "%JCL_DATASET%" --rff jobid --rft string') do set JOBID=%%i
echo Job ID: !JOBID!
for /f "tokens=*" %%i in ('zowe zos-jobs submit ds "%JCL_DATASET%" --wfo --rff retcode --rft string') do set RC=%%i


REM Check if job is still running
echo !RETCODE! | findstr /C:"AC" >nul
if not errorlevel 1 (
    echo Job is still running...
    goto CHECKJOB
)


REM Check return code
if "%RC%"=="CC 0000" (
    echo Success: Job completed with RC=0000
) else (
    echo Failure: Job completed with RC=%RC%
)

echo.
echo Window will close in:
for /l %%i in (5,-1,1) do (
    echo %%i seconds...
    timeout /t 1 >nul
)

endlocal