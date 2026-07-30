# 🛡️ DURGA - SafeConnect



### Women's Safety & Emergency Response Application

A modern Flutter application designed to enhance women's safety through instant SOS alerts, live location sharing, emergency contacts, AI-powered threat analysis, and quick access to emergency services.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-blue?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android-green)
![License](https://img.shields.io/badge/License-MIT-orange)

</div>

---

# 📱 Overview

**DURGA - SafeConnect** is a mobile safety application built using Flutter that helps users quickly access emergency services during unsafe situations.

The app combines real-time location services, emergency contact management, evidence collection, and AI-assisted threat analysis into one intuitive interface.

---

# ✨ Features

## 🚨 SOS Emergency Alert

- One-tap SOS button
- Sends emergency alert
- Shares current location
- Designed for rapid response

---

## 👥 Trusted Contacts

- Add multiple emergency contacts
- Save contacts locally
- Easy management
- Future SMS integration

---

## 🤖 AI Threat Analysis

Analyze the user's situation based on entered keywords.

Example keywords:

- Help
- Attack
- Threat
- Followed
- Harassment

Displays

- 🟢 Low Risk
- 🟠 Medium Risk
- 🔴 High Risk

---

## 📍 Live Location

- GPS Location
- Latitude & Longitude
- Refresh Location
- Open directly in Google Maps

---

## 📷 Evidence Collection

Capture emergency evidence using:

- Camera
- Video Recorder

Useful during emergency situations.

---

## ☎ Emergency Helplines

Quick access to

- 112 National Emergency
- 181 Women Helpline

---

## 📋 Copy Last SOS

Copies the latest SOS message to clipboard.

Useful if messaging services are unavailable.

---

## 🌐 Multi-language Support

Planned support

- English
- Telugu
- Tamil

---

## 🌙 Dark Mode

Upcoming feature.

---



# 🏗️ Project Structure

```
lib/
│
├── models/
├── services/
├── screens/
│   ├── home_screen.dart
│   ├── safety_screen.dart
│   ├── safezone_screen.dart
│   └── settings_screen.dart
│
├── theme/
│   ├── colors.dart
│   └── app_theme.dart
│
├── widgets/
│   ├── buttons/
│   ├── cards/
│   ├── common/
│   └── navigation/
│
├── utils/
│
└── main.dart
```

---

# 🛠️ Built With

- Flutter
- Dart
- Material Design 3

Packages used

- provider
- geolocator
- geocoding
- permission_handler
- image_picker
- url_launcher
- shared_preferences
- google_fonts
- flutter_svg
- google_maps_flutter
- intl

---

# 🚀 Installation

### Frontend (Flutter App)

1. Clone the repository:
   ```bash
   git clone https://github.com/yaadhuu/Durga-Women-Safety-App.git
   ```
2. Go to project directory:
   ```bash
   cd Durga-Women-Safety-App
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```

### Backend (FastAPI API Server)

### Quick Start (Local, No Docker)
1. **One-time Setup:** Create local Postgres DB `durga_db` and copy `backend/.env.example` to `backend/.env` (see [LOCAL_SETUP.md](LOCAL_SETUP.md) for full guide).
2. **Everyday Run (Choose one):**
   - **VS Code:** Press `Ctrl+Shift+P` (or `Cmd+Shift+P`) ➔ **Tasks: Run Task** ➔ **Start Everything**.
   - **CLI (Two Terminals):**
     - Terminal 1 (Backend): `backend/run_local.sh` (or `backend\run_local.bat` on Windows)
     - Terminal 2 (Frontend): `scripts/run_frontend.sh` (or `scripts\run_frontend.bat` on Windows)

The backend code is located inside the `/backend` folder.

1. Go to the backend folder:
   ```bash
   cd backend
   ```
2. Make sure you copy `.env.example` to `.env` and fill in the necessary keys.
3. Start the containers (PostgreSQL database + Python FastAPI app) using Docker Compose:
   ```bash
   docker compose up -d --build
   ```
4. Run database migrations:
   ```bash
   alembic upgrade head
   ```

---

# 📦 Requirements

* **Frontend:** Flutter SDK 3.x, Dart SDK 3.x
* **Backend:** Python 3.12+, Docker Desktop (for Postgres database)

---

# 📌 Future Improvements

* **Phase 3 Frontend Integration:** Complete wiring up the remaining UI screens to talk to the new FastAPI endpoints (In Progress).
* **Native FCM Push Alerts:** Add Firebase setup to broadcast SOS notifications to emergency contacts (Planned).
* **Cloud Evidence Storage:** Store uploaded audio/video clips securely on AWS S3 or Google Cloud (Planned).
* **Rate Limiting & Abuse Prevention:** Implement brute-force protection on the Login and SOS endpoints.
* **Offline Emergency Mode:** Allow triggering local SMS fallback if the network is disconnected.

---

# 🎯 Application Workflow

```
User Opens App
        │
        ▼
 Home Dashboard
        │
        ├──────────► SOS Alert
        │
        ├──────────► Threat Analysis
        │
        ├──────────► Live Location
        │
        ├──────────► Evidence Collection
        │
        └──────────► Emergency Calls
```

---

# 📄 License

This project is licensed under the MIT License.

---

# 👨‍💻 Developer

**Arun K**

B.Tech Computer Science Engineering

Flutter Developer

---

# ❤️ Acknowledgements

- Flutter Team
- Material Design
- Android Location Services
- Open Source Community

---

## ⭐ Support

If you like this project, consider giving it a **⭐ Star** on GitHub.

It helps others discover the project!

---

<div align="center">

### DURGA - SafeConnect

**Empowering Safety Through Technology**

</div>
