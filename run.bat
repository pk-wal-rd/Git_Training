@echo off
setlocal

set "SKIP_PAUSE=0"
if defined CI set "SKIP_PAUSE=1"

REM 1) Try a portable TCC copy first (expected in a "tcc" subfolder next to this script)
if exist "%~dp0tcc\tcc.exe" (
    "%~dp0tcc\tcc.exe" main.c -o main.exe
    if errorlevel 1 (
        echo Compilation failed with TCC.
        if "%SKIP_PAUSE%"=="0" pause
        exit /b 1
    )
    goto run
)

REM 2) Fall back to gcc on PATH or in common install locations
where gcc >nul 2>nul
if %errorlevel%==0 goto compile_gcc

for %%P in (
    "C:\msys64\ucrt64\bin"
    "C:\msys64\mingw64\bin"
    "C:\MinGW\bin"
    "C:\TDM-GCC-64\bin"
) do (
    if exist "%%~P\gcc.exe" (
        set "PATH=%%~P;%PATH%"
        goto compile_gcc
    )
)

echo No compiler found.
echo Option A (recommended, no install): download Tiny C Compiler (TCC) from
echo   https://download.savannah.gnu.org/releases/tinycc/
echo   (grab the "tcc-x.x.x-win64-bin.zip"), unzip it, and rename the
echo   extracted folder to "tcc" so it sits right next to this run.bat,
echo   i.e. this folder should then contain:  tcc\tcc.exe
echo Option B: install MinGW-w64 via MSYS2 (https://www.msys2.org)
if "%SKIP_PAUSE%"=="0" pause
exit /b 1

:compile_gcc
gcc main.c -o main.exe
if errorlevel 1 (
    echo Compilation failed.
    if "%SKIP_PAUSE%"=="0" pause
    exit /b 1
)

:run
main.exe
set "EXITCODE=%ERRORLEVEL%"
if "%SKIP_PAUSE%"=="0" pause
exit /b %EXITCODE%
