@echo off
@REM Copyright 2018-present, Yudong (Dom) Wang
@REM
@REM Licensed under the Apache License, Version 2.0 (the "License");
@REM you may not use this file except in compliance with the License.
@REM You may obtain a copy of the License at
@REM
@REM      http://www.apache.org/licenses/LICENSE-2.0
@REM
@REM Unless required by applicable law or agreed to in writing, software
@REM distributed under the License is distributed on an "AS IS" BASIS,
@REM WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@REM See the License for the specific language governing permissions and
@REM limitations under the License.

@REM -----------------------------------------------------------------------------
@REM Holer Startup
@REM -----------------------------------------------------------------------------
title holer-client
setlocal enabledelayedexpansion
set errorlevel=

set HOLER_OK=0
set HOLER_ERR=1
set JAVA_BIN=java

if "!HOLER_HOME!" equ "" (
    set HOLER_HOME=%~dp0\..
)

set HOLER_ARGS=-Dapp.home=!HOLER_HOME!
set HOLER_APP=!HOLER_HOME!\holer-client.jar
set HOLER_LOG_DIR=!HOLER_HOME!\logs
set HOLER_LOG=!HOLER_LOG_DIR!\holer-client.log
set HOLER_LINE=------------------------------------------

@REM Create logs directory
if not exist "!HOLER_LOG_DIR!" (
    mkdir "!HOLER_LOG_DIR!"
)

@REM Check if Java is correctly installed and set
"!JAVA_BIN!" -version 1>nul 2>nul
if !errorlevel! neq 0 (
    @echo.
    @echo Please install Java 1.7 or higher and make sure the Java is set correctly.
    @echo.
    @echo You can execute command [ !JAVA_BIN! -version ] to check if Java is correctly installed and set.
    @echo.
    pause
    goto:eof
)

@REM  Asking for the HOLER_ACCESS_KEY
if "!HOLER_ACCESS_KEY!" equ "" (
    @echo !HOLER_LINE!
    set /p HOLER_ACCESS_KEY="Enter holer access key: "
    if "!HOLER_ACCESS_KEY!" == "" (
        @echo Please enter holer access key
        @echo !HOLER_LINE!
        pause
        exit /b !HOLER_ERR!
    )
)

@REM  Asking for the HOLER_SERVER_HOST
if "!HOLER_SERVER_HOST!" equ "" (
    @echo !HOLER_LINE!
    set /p HOLER_SERVER_HOST="Enter holer server host: "
    if "!HOLER_SERVER_HOST!" == "" (
        @echo Please enter holer server host
        @echo !HOLER_LINE!
        pause
        exit /b !HOLER_ERR!
    )
)

@echo !HOLER_LINE!
@echo Starting holer client...

start /b !JAVA_BIN!w !HOLER_ARGS! -jar !HOLER_APP! >> !HOLER_LOG!
timeout /T 4 /NOBREAK

@echo !HOLER_LINE!
tasklist | findstr !JAVA_BIN!w

if !errorlevel! equ 0 (
    @echo !HOLER_LINE!
    @echo Started holer client.
    @echo.
    @echo The holer client is running.
    @echo !HOLER_LINE!
) else (
    @echo Holer client is stopped.
    @echo Please check the log file for details [ !HOLER_LOG! ]
    @echo !HOLER_LINE!
)

pause
goto:eof