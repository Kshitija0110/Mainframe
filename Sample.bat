@echo off
echo Starting JCL backup and Git commit process...

REM Set variables

git config --global user.email "kshitudeshmukh3@gmail.com"
git config --global user.name "Kshitija0110"
git config --global --add safe.directory %REPO_DIR%

set BACKUP_DIR=C:\JCLBackup
set REPO_DIR=C:\GitRepo\jcl-backup
set DATE_STAMP=%date:~10,4%%date:~4,2%%date:~7,2%
set TIME_STAMP=%time:~0,2%%time:~3,2%%time:~6,2%

REM Create backup directory if it doesn't exist
if not exist "%BACKUP_DIR%" mkdir "%BACKUP_DIR%"

REM Run FTP script to download JCL members
echo Downloading JCL members...
ftp -s:"%WORKSPACE%\SampleFTP.txt"

REM Navigate to repo and perform git pull
cd "%REPO_DIR%"
if exist ".git\MERGE_HEAD" (
    git merge --abort
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

<<<<<<< HEAD
REM Perform Git operation
=======
REM Perform Git operations
>>>>>>> a96d7144bf8d1a118a493a659415af60ecb41b97
git add .
git commit -m "JCL backup %DATE_STAMP%_%TIME_STAMP%"
git push origin main

echo Backup and commit complete!
pause