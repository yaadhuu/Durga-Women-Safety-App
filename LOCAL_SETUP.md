# 🛠️ DURGA Safety App - Local Development & Setup Guide

This document provides complete instructions for setting up, configuring, and running the DURGA Women Safety Application backend and frontend locally without Docker.

---

## 📋 Prerequisites

1. **Python 3.12+**
2. **PostgreSQL 16+** (running locally on standard port `5432` or via local service)
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
   DATABASE_URL=postgresql://postgres:postgres@localhost:5432/durga_db
   SECRET_KEY=your-super-secret-jwt-key-change-in-production
   ```

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
- Prompts for target device ID and physical device LAN IP configuration.
- Launches Flutter app targeting the selected device.

---

## 💻 Running via IDEs

### VS Code (One-Click Start Everything)
1. Open the repository root in VS Code.
2. Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (macOS).
3. Type and select **Tasks: Run Task**.
4. Select **Start Everything**.
   - This launches the backend in panel 1 and the frontend in panel 2.

---

### Android Studio Run/Debug Configurations

For developers using Android Studio, follow these steps to configure two Run/Debug configurations:

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

#### Configuration 2: Flutter App (with Physical Device LAN IP support)
1. In **Run** ➔ **Edit Configurations...**, select your existing Flutter run configuration (e.g., `main.dart`).
2. **For Android Emulator (Default):**
   - No additional arguments are required. The app defaults to `http://10.0.2.2:8000/api/v1`.
3. **For Physical Device Testing:**
   - Locate the **Additional run args** text field.
   - Enter your computer's LAN IP address:
     ```text
     --dart-define=API_BASE_URL=http://<YOUR_LAN_IP>:8000/api/v1
     ```
     *(Example: `--dart-define=API_BASE_URL=http://192.168.1.100:8000/api/v1`)*
4. Click **Apply** and **OK**.
