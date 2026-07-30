#!/bin/bash
# ==============================================================================
# DURGA Safety App - Backend Local Startup Script (Linux / macOS)
# Runs virtual environment setup, migrations, and FastAPI uvicorn server.
# ==============================================================================

set -e

# Change directory to backend folder (where this script resides)
cd "$(dirname "$0")"

# Set PYTHONPATH so alembic and app modules resolve correctly
export PYTHONPATH=.

# ------------------------------------------------------------------------------
# Step 1: Virtual Environment Setup (Idempotent)
# Check if venv exists. If missing, create it and install requirements.
# ------------------------------------------------------------------------------
if [ -d "venv" ]; then
    echo "[+] Virtual environment found. Activating..."
    source venv/bin/activate
else
    echo "[+] Virtual environment not found. Creating venv..."
    python3 -m venv venv
    source venv/bin/activate
    echo "[+] Installing dependencies from requirements.txt..."
    pip install -r requirements.txt
fi

# Ensure key dependencies are available in activated environment
if ! command -v uvicorn &> /dev/null; then
    echo "[+] Installing/refreshing backend requirements..."
    pip install -r requirements.txt
fi

# ------------------------------------------------------------------------------
# Step 2: Environment Configuration (.env Check)
# Remind user to verify backend/.env exists, pointing to .env.example if missing.
# ------------------------------------------------------------------------------
if [ ! -f ".env" ]; then
    echo ""
    echo "[!] ERROR: backend/.env file is missing!"
    echo "[!] Please copy backend/.env.example to backend/.env and update configuration as needed."
    echo "[!] Run: cp .env.example .env"
    echo ""
    exit 1
fi
echo "[+] backend/.env verified."

# ------------------------------------------------------------------------------
# Step 3: Run Database Migrations
# Apply all pending Alembic database migrations to head.
# ------------------------------------------------------------------------------
echo "[+] Running Alembic database migrations (alembic upgrade head)..."
alembic upgrade head

# ------------------------------------------------------------------------------
# Step 4: Start FastAPI Backend Server
# Launch uvicorn with hot-reloading on port 8000.
# ------------------------------------------------------------------------------
echo "[+] Starting FastAPI server on http://0.0.0.0:8000 ..."
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
