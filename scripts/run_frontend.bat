@echo off
rem ==============================================================================
rem DURGA Safety App - Frontend Local Startup Script (Windows)
rem Installs dependencies, lists devices, prompts target & LAN IP, and runs Flutter.
rem ==============================================================================

rem Change directory to repo root (parent of scripts\)
cd /d "%~dp0.."

rem ------------------------------------------------------------------------------
rem Step 1: Fetch Flutter Dependencies
rem Runs flutter pub get to ensure all packages are up to date.
rem ------------------------------------------------------------------------------
echo [+] Running flutter pub get...
call flutter pub get

rem ------------------------------------------------------------------------------
rem Step 2: List Available Devices
rem Print available emulators and connected physical devices.
rem ------------------------------------------------------------------------------
echo.
echo [+] Available Flutter Devices:
echo --------------------------------------------------
call flutter devices
echo --------------------------------------------------
echo.

rem ------------------------------------------------------------------------------
rem Step 3: Prompt User for Target Device & Network Configuration
rem Ask for device ID and whether target is a physical device (requires LAN IP).
rem ------------------------------------------------------------------------------
set DEVICE_ID=
set /p DEVICE_ID="Enter target device ID (or press Enter for default): "

set IS_PHYSICAL=
set /p IS_PHYSICAL="Are you deploying to a physical device? (y/n) [Default: n]: "

set EXTRA_ARGS=

if /i "%IS_PHYSICAL%"=="y" (
    set /p LAN_IP="Enter your computer's LAN IP address (e.g., 192.168.1.100): "
    if not "%LAN_IP%"=="" (
        set EXTRA_ARGS=--dart-define=API_BASE_URL=http://%LAN_IP%:8000/api/v1
        echo [+] Configured custom API base URL for physical device: http://%LAN_IP%:8000/api/v1
    )
) else (
    echo [+] Using default API base URL (Android emulator 10.0.2.2 / localhost).
)

rem ------------------------------------------------------------------------------
rem Step 4: Launch Flutter Application
rem Start flutter run with specified device target and optional dart defines.
rem ------------------------------------------------------------------------------
echo.
if not "%DEVICE_ID%"=="" (
    if not "%EXTRA_ARGS%"=="" (
        echo [+] Executing: flutter run -d %DEVICE_ID% %EXTRA_ARGS%
        call flutter run -d %DEVICE_ID% %EXTRA_ARGS%
    ) else (
        echo [+] Executing: flutter run -d %DEVICE_ID%
        call flutter run -d %DEVICE_ID%
    )
) else (
    if not "%EXTRA_ARGS%"=="" (
        echo [+] Executing: flutter run %EXTRA_ARGS%
        call flutter run %EXTRA_ARGS%
    ) else (
        echo [+] Executing: flutter run
        call flutter run
    )
)
