#!/bin/bash

# run_test_game.sh
# Automates building the web client and launching the host with 10 test clients.

# Exit on error
set -e

# Get player count from argument, default to 10
NUM_PLAYERS=${1:-10}

echo "🚀 Step 1: Preparing Web Support..."
# Enable web if not enabled
flutter config --enable-web > /dev/null

# Create web folder if missing
if [ ! -d "web" ]; then
  echo "📦 Adding web support to the project..."
  flutter create --platforms=web .
fi

echo "🚀 Step 2: Building Web Client (PWA)..."
flutter build web -t lib/main_client.dart

echo "🚀 Step 3: Starting MacOS Host Application..."
# We run in the background to allow opening clients
# Using 'flutter run' to see logs easily
# We pass the absolute path to build/web via dart-define to bypass sandbox issues
flutter run -d macos -t lib/main_host.dart --dart-define=WEB_ROOT="$(pwd)/build/web" &
HOST_PID=$!

echo "⏳ Step 4: Waiting for the server to initialize (15 seconds)..."
sleep 15

echo "👥 Step 5: Launching $NUM_PLAYERS Test Clients in Chrome..."
# Note: This assumes Chrome is installed.
for i in $(seq 1 $NUM_PLAYERS); do
  # We use --new-window to avoid tab overload in one window
  open -na "Google Chrome" --args --new-window "http://localhost:8080/?nickname=Player_$i"
done

echo "✅ Test environment is ready!"
echo "--------------------------------------------------"
echo "Host App PID: $HOST_PID"
echo "To stop everything, press Ctrl+C in this terminal."
echo "--------------------------------------------------"

# Wait for the host process to finish
wait $HOST_PID
