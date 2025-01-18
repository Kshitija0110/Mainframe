@echo off
setlocal enabledelayedexpansion

REM Set Git configurations
git config --global user.email "kshitudeshmukh3@gmail.com"
git config --global user.name "Kshitija0110"
git config --global --add safe.directory C:/GitRepo/jcl-backup
git config --global pull.rebase false
git config --global merge.autoStash true

REM Set variables
set BACKUP_DIR=C:\JCLBackup
set REPO_DIR=C:\GitRepo\jcl-backup
set DATE_STAMP=%date:~10,4%%date:~4,2%%date:~7,2%
set TIME_STAMP=%time:~0,2%%time:~3,2%%time:~6,2%

cd "%REPO_DIR%"

REM Handle any existing merge
if exist ".git\MERGE_HEAD" (
    git merge --abort
    echo Aborting previous merge...
)

REM Stash any local changes
git stash

REM Pull with automatic merge message
git pull origin main -m "Merge remote-tracking branch 'origin/main'"

REM Copy new files and commit
xcopy /Y "%BACKUP_DIR%\*.*" "%REPO_DIR%"
git add .
git commit -m "JCL backup update %DATE_STAMP%_%TIME_STAMP%"
git push origin main

REM Cleanup
git stash clear

echo Backup and merge complete!
if defined JENKINS_HOME (exit 0) else pause