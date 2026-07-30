# 🛠️ DURGA Safety App - Local Development & Setup Guide

This document provides complete instructions for setting up, configuring, and running the DURGA Women Safety Application backend and frontend locally without Docker across **Android Emulators, iOS Simulators, Desktop/Web, and Physical Phones**.

---

## 📋 Prerequisites

1. **Python 3.12+**
2. **PostgreSQL 16+** (or SQLite `sqlite:///./test.db` for zero-setup local runs)
3. **Flutter SDK 3.x / Dart SDK 3.x**
4. **Android Studio / VS Code** (with Flutter & Dart plugins)

---

## 🗄️ Database Setup (One-Time)

1. Connect to your local PostgreSQL instance:
   ```bash
   psql -U postgres
   ```
2. Create the application database:
   ```sql
   CREATE DATABASE durga_db;
   ```
3. Copy the example environment configuration in `backend/`:
   ```bash
   cd backend
   cp .env.example .env     # On Linux / macOS
   copy .env.example .env   # On Windows
   ```
4. Verify database credentials inside `backend/.env`:
   ```env
   DATABASE_URL=postgresql+psycopg://durga:durga_secret@localhost:5432/durga_db
   ```
   *(Or for zero-dependency local runs: `DATABASE_URL=sqlite:///./test.db`)*

---

## 📱 Multi-Device Target Reference

| Target Environment | `API_BASE_URL` | CLI Parameter |
| :--- | :--- | :--- |
| **Android Emulator** | `http://10.0.2.2:8000/api/v1` | *(Default — no flag needed)* |
| **iOS Simulator** | `http://127.0.0.1:8000/api/v1` | `--dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1` |
| **Desktop / Web** | `http://127.0.0.1:8000/api/v1` | `--dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1` |
| **Physical Phone** | `http://<LAN_IP>:8000/api/v1` | `--dart-define=API_BASE_URL=http://<LAN_IP>:8000/api/v1` |

---

## 🚀 Running the App (One-Command CLI)

### 1. Start Backend (Terminal 1)
```bash
# macOS / Linux:
backend/run_local.sh

# Windows:
backend\run_local.bat
```
*What this script does:*
- Checks and sets up Python virtual environment (`venv`) automatically.
- Installs dependencies from `requirements.txt` if needed.
- Confirms `backend/.env` exists.
- Runs database migrations (`alembic upgrade head`).
- Launches FastAPI server at `http://localhost:8000`.

### 2. Start Frontend (Terminal 2)
```bash
# macOS / Linux:
scripts/run_frontend.sh

# Windows:
scripts\run_frontend.bat
```
*What this script does:*
- Runs `flutter pub get`.
- Lists all connected devices and emulators.
- Prompts to select environment (1: Android Emulator, 2: iOS Simulator/Desktop, 3: Physical Phone).
- Launches Flutter app targeting the selected device seamlessly.

---

## 💻 Running via IDEs

### VS Code (One-Click Launch & Debug)
1. **Run Task (Start Everything)**:
   - Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (macOS) ➔ **Tasks: Run Task** ➔ **Start Everything**.
2. **Run & Debug (F5)**:
   - Open VS Code **Run & Debug** tab (`Ctrl+Shift+D` / `Cmd+Shift+D`).
   - Select configuration:
     - `DURGA App (Android Emulator)`
     - `DURGA App (iOS Simulator / Desktop / Web)`
     - `DURGA App (Physical Phone - Change IP in args)`
   - Press **F5** to start debugging.

---

### Android Studio Run/Debug Configurations

For developers using Android Studio, follow these steps to configure your Run/Debug configurations:

#### Configuration 1: Start Backend from Android Studio
1. Open the project in Android Studio.
2. From the main menu bar, navigate to: **Run** ➔ **Edit Configurations...**
3. In the top-left of the dialog, click the **+** (Add New Configuration) button.
4. Select **Shell Script** from the dropdown list.
5. Fill in the following fields:
   - **Name**: `Start Backend`
   - **Execute**: Select **Script file**
   - **Script path**: Browse to and select `backend/run_local.sh` (Linux/macOS) or `backend\run_local.bat` (Windows).
   - **Working directory**: Select your project's `backend` folder.
6. Click **Apply**. Now you can start the FastAPI backend server directly from Android Studio's top Run toolbar button.

#### Configuration 2: Flutter App (Multi-Device Setup)
1. In **Run** ➔ **Edit Configurations...**, select your existing Flutter run configuration (e.g., `main.dart`).
2. **For Android Emulator (Default):**
   - No additional arguments are required. The app defaults to `http://10.0.2.2:8000/api/v1`.
3. **For iOS Simulator / Local Desktop:**
   - Add to **Additional run args**:
     ```text
     --dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1
     ```
4. **For Physical Device Testing:**
   - Add to **Additional run args**:
     ```text
     --dart-define=API_BASE_URL=http://<YOUR_LAN_IP>:8000/api/v1
     ```
     *(Example: `--dart-define=API_BASE_URL=http://192.168.1.100:8000/api/v1`)*
5. Click **Apply** and **OK**.
