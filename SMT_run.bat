@echo off
setlocal enabledelayedexpansion

for /f "tokens=2 delims==" %%I in ('wmic os get localdatetime /format:list') do set datetime=%%I
set datetime=!datetime:~0,8!-!datetime:~8,6!
set LOGFILE=%~dp0maintenance_log_%datetime%.txt

echo !date! !time:~0,8! - System Maintenance Start >> "%LOGFILE%"

echo !date! !time:~0,8! - Running System File Checker... >> "%LOGFILE%"
sfc /scannow >> "%LOGFILE%"

echo !date! !time:~0,8! - Running Disk Check... >> "%LOGFILE%"
echo Y | chkdsk >> "%LOGFILE%"

echo !date! !time:~0,8! - Running DISM... >> "%LOGFILE%"
DISM /Online /Cleanup-Image /RestoreHealth >> "%LOGFILE%"

echo !date! !time:~0,8! - Running Disk Cleanup... >> "%LOGFILE%"
cleanmgr /sagerun:1 >> "%LOGFILE%"

echo !date! !time:~0,8! - System Maintenance End >> "%LOGFILE%"

for /f "skip=10 delims=" %%F in ('dir /b /o-d "%~dp0\maintenance_log_*.txt"') do del "%~dp0\%%F"

endlocal
exit