@echo off
echo Starting JCL backup and Git commit process...

REM Set variables
set BACKUP_DIR=C:\JCLBackup
set REPO_DIR=C:\GitRepo\jcl-backup
set DATE_STAMP=%date:~10,4%%date:~4,2%%date:~7,2%
set TIME_STAMP=%time:~0,2%%time:~3,2%%time:~6,2%

REM Create backup directory if it doesn't exist
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

REM Configure Git to trust the directory when running as SYSTEM
git config --global --add safe.directory %REPO_DIR%

REM Run FTP script to download JCL members
echo Downloading JCL members...
ftp -s:SampleFTP.txt

REM Navigate to repo and perform git pull
cd "%REPO_DIR%" || (
    echo Error: Cannot access repository directory
    exit /b 1
)
echo Pulling latest changes from remote repository...
git pull origin main

REM Copy files to Git repository
echo Copying files to Git repository...
if not exist "%REPO_DIR%" (
    mkdir "%REPO_DIR%"
    cd "%REPO_DIR%"
    git init
)

REM Copy new files to repo directory
echo Copying files to Git repository...
xcopy /Y "%BACKUP_DIR%\*.*" "%REPO_DIR%"

REM Perform Git operations
git add .
git commit -m "JCL backup %DATE_STAMP%_%TIME_STAMP%"
git push origin main

echo Backup and commit complete!
pause