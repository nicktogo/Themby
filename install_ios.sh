#!/bin/bash

# Install iOS app to device without losing data
# Usage: ./install_ios.sh [device_id]

set -e

DEVICE_ID="${1:-00008110-000654E93AE1801E}"

echo "Building iOS release..."
flutter build ios --release

echo ""
echo "Installing to device ${DEVICE_ID}..."
xcrun devicectl device install app --device "${DEVICE_ID}" build/ios/iphoneos/Runner.app

echo ""
echo "✅ App installed successfully! Your Emby config is preserved."
