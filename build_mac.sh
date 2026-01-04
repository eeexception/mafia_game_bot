#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting MacOS Build Process..."

# 1. Clean build
echo "🧹 Cleaning previous builds..."
flutter clean

# 2. Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# 3. Build Client PWA
echo "🌐 Building Client PWA..."
flutter build web --release

# 4. Build Host MacOS App
echo "🖥️  Building Host MacOS App..."
flutter build macos --release

echo "✅ Build Complete!"
echo "📂 App Bundle: build/macos/Build/Products/Release/mafia_game.app"
echo "📂 Web Assets: build/web"

# 5. Run the app
echo "🚀 Launching Game..."
# We run the binary directly to preserve CWD so it can find build/web
./build/macos/Build/Products/Release/mafia_game.app/Contents/MacOS/mafia_game
