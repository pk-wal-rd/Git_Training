@echo off
setlocal

REM 1) Try a portable TCC copy first (expected in a "tcc" subfolder next to this script)
if exist "%~dp0tcc\tcc.exe" (
    "%~dp0tcc\tcc.exe" main.c -o main.exe
    if errorlevel 1 (
        echo Compilation failed with TCC.
        pause
        exit /b 1
    )
    goto run
)

:run
main.exe
pause