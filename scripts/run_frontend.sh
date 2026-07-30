#!/bin/bash
# ==============================================================================
# DURGA Safety App - Frontend Local Startup Script (Linux / macOS)
# Multi-device runner for Android Emulator, iOS Simulator, and Physical Phones.
# ==============================================================================

set -e

# Change directory to project root (parent directory of scripts/)
cd "$(dirname "$0")/.."

# ------------------------------------------------------------------------------
# Step 1: Fetch Flutter Dependencies
# ------------------------------------------------------------------------------
echo "[+] Running flutter pub get..."
flutter pub get

# ------------------------------------------------------------------------------
# Step 2: List Available Devices
# ------------------------------------------------------------------------------
echo ""
echo "[+] Available Flutter Devices:"
echo "--------------------------------------------------"
flutter devices
echo "--------------------------------------------------"
echo ""

# ------------------------------------------------------------------------------
# Step 3: Prompt User for Target Device & Device Type Selection
# ------------------------------------------------------------------------------
read -p "Enter target device ID (or press Enter for default): " DEVICE_ID

echo ""
echo "Select target device environment:"
echo "  1) Android Emulator (Default: http://10.0.2.2:8000/api/v1)"
echo "  2) iOS Simulator / Local Desktop (Default: http://127.0.0.1:8000/api/v1)"
echo "  3) Physical Phone (Requires computer's LAN IP address)"
read -p "Enter choice [1-3] (Default: 1): " DEV_TYPE

EXTRA_ARGS=""

case "$DEV_TYPE" in
    2)
        EXTRA_ARGS="--dart-define=API_BASE_URL=http://127.0.0.1:8000/api/v1"
        echo "[+] Target environment: iOS Simulator / Desktop (http://127.0.0.1:8000/api/v1)"
        ;;
    3)
        read -p "Enter your computer's LAN IP address (e.g., 192.168.1.100): " LAN_IP
        if [ -n "$LAN_IP" ]; then
            EXTRA_ARGS="--dart-define=API_BASE_URL=http://${LAN_IP}:8000/api/v1"
            echo "[+] Target environment: Physical Phone (http://${LAN_IP}:8000/api/v1)"
        else
            echo "[!] No IP provided. Falling back to Android Emulator URL (http://10.0.2.2:8000/api/v1)."
            EXTRA_ARGS="--dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1"
        fi
        ;;
    *)
        EXTRA_ARGS="--dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1"
        echo "[+] Target environment: Android Emulator (http://10.0.2.2:8000/api/v1)"
        ;;
esac

# ------------------------------------------------------------------------------
# Step 4: Launch Flutter Application
# ------------------------------------------------------------------------------
echo ""
if [ -n "$DEVICE_ID" ]; then
    echo "[+] Executing: flutter run -d $DEVICE_ID $EXTRA_ARGS"
    flutter run -d "$DEVICE_ID" "$EXTRA_ARGS"
else
    echo "[+] Executing: flutter run $EXTRA_ARGS"
    flutter run "$EXTRA_ARGS"
fi
