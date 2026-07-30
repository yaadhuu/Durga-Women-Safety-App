#!/bin/bash
# ==============================================================================
# DURGA Safety App - Frontend Local Startup Script (Linux / macOS)
# Installs dependencies, lists devices, prompts target & LAN IP, and runs Flutter.
# ==============================================================================

set -e

# Change directory to project root (parent directory of scripts/)
cd "$(dirname "$0")/.."

# ------------------------------------------------------------------------------
# Step 1: Fetch Flutter Dependencies
# Runs flutter pub get to ensure all packages are up to date.
# ------------------------------------------------------------------------------
echo "[+] Running flutter pub get..."
flutter pub get

# ------------------------------------------------------------------------------
# Step 2: List Available Devices
# Print available emulators and connected physical devices.
# ------------------------------------------------------------------------------
echo ""
echo "[+] Available Flutter Devices:"
echo "--------------------------------------------------"
flutter devices
echo "--------------------------------------------------"
echo ""

# ------------------------------------------------------------------------------
# Step 3: Prompt User for Target Device & Network Configuration
# Ask for device ID and whether target is a physical device (requires LAN IP).
# ------------------------------------------------------------------------------
read -p "Enter target device ID (or press Enter for default): " DEVICE_ID
read -p "Are you deploying to a physical device? (y/N): " IS_PHYSICAL

EXTRA_ARGS=""

if [[ "$IS_PHYSICAL" =~ ^[Yy]$ ]]; then
    read -p "Enter your computer's LAN IP address (e.g., 192.168.1.100): " LAN_IP
    if [ -n "$LAN_IP" ]; then
        EXTRA_ARGS="--dart-define=API_BASE_URL=http://${LAN_IP}:8000/api/v1"
        echo "[+] Configured custom API base URL for physical device: http://${LAN_IP}:8000/api/v1"
    else
        echo "[!] No IP provided. Using default API base URL."
    fi
else
    echo "[+] Using default API base URL (Android emulator 10.0.2.2 / localhost)."
fi

# ------------------------------------------------------------------------------
# Step 4: Launch Flutter Application
# Start flutter run with specified device target and optional dart defines.
# ------------------------------------------------------------------------------
echo ""
if [ -n "$DEVICE_ID" ]; then
    if [ -n "$EXTRA_ARGS" ]; then
        echo "[+] Executing: flutter run -d $DEVICE_ID $EXTRA_ARGS"
        flutter run -d "$DEVICE_ID" "$EXTRA_ARGS"
    else
        echo "[+] Executing: flutter run -d $DEVICE_ID"
        flutter run -d "$DEVICE_ID"
    fi
else
    if [ -n "$EXTRA_ARGS" ]; then
        echo "[+] Executing: flutter run $EXTRA_ARGS"
        flutter run "$EXTRA_ARGS"
    else
        echo "[+] Executing: flutter run"
        flutter run
    fi
fi
