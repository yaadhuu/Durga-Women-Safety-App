@echo off
rem ==============================================================================
rem DURGA Safety App - Backend Local Startup Script (Windows)
rem Runs virtual environment setup, migrations, and FastAPI uvicorn server.
rem ==============================================================================

rem Change directory to backend folder (where this batch file resides)
cd /d "%~dp0"

rem Set PYTHONPATH so alembic and app modules resolve correctly
set PYTHONPATH=.

rem ------------------------------------------------------------------------------
rem Step 1: Virtual Environment Setup (Idempotent)
rem Check if venv exists. If missing, create it and install requirements.txt.
rem ------------------------------------------------------------------------------
if exist "venv\Scripts\activate.bat" (
    echo [+] Virtual environment found. Activating...
    call venv\Scripts\activate.bat
) else (
    echo [+] Virtual environment not found. Creating venv...
    python -m venv venv
    if errorlevel 1 (
        echo [!] ERROR: Failed to create virtual environment using 'python'.
        echo [!] Please verify Python is installed and added to PATH.
        exit /b 1
    )
    echo [+] Activating virtual environment...
    call venv\Scripts\activate.bat
    echo [+] Installing backend dependencies from requirements.txt...
    pip install -r requirements.txt
)

rem Ensure uvicorn is installed in the active venv
where uvicorn >nul 2>nul
if errorlevel 1 (
    echo [+] Installing/refreshing backend requirements...
    pip install -r requirements.txt
)

rem ------------------------------------------------------------------------------
rem Step 2: Environment Configuration (.env Check)
rem Confirm backend\.env exists. If missing, exit with instructions.
rem ------------------------------------------------------------------------------
if not exist ".env" (
    echo.
    echo [!] ERROR: backend\.env file is missing!
    echo [!] Please copy backend\.env.example to backend\.env before starting the server.
    echo [!] Run command: copy .env.example .env
    echo.
    exit /b 1
)
echo [+] backend\.env verified.

rem ------------------------------------------------------------------------------
rem Step 3: Run Database Migrations
rem Apply all pending Alembic database migrations to head.
rem ------------------------------------------------------------------------------
echo [+] Running Alembic database migrations (alembic upgrade head)...
alembic upgrade head
if errorlevel 1 (
    echo [!] ERROR: Alembic database migration failed.
    exit /b 1
)

rem ------------------------------------------------------------------------------
rem Step 4: Start FastAPI Backend Server
rem Launch uvicorn with hot-reloading on port 8000.
rem ------------------------------------------------------------------------------
echo [+] Starting FastAPI server on http://0.0.0.0:8000 ...
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
