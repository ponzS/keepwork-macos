#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
APP="build/KeepWork.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
cp Info.plist "$APP/Contents/Info.plist"
# Universal binary: Apple Silicon + Intel
swiftc -O -target arm64-apple-macosx13.0 Sources/main.swift -o build/KeepWork-arm64
swiftc -O -target x86_64-apple-macosx13.0 Sources/main.swift -o build/KeepWork-x86_64
lipo -create build/KeepWork-arm64 build/KeepWork-x86_64 -output "$APP/Contents/MacOS/KeepWork"
rm build/KeepWork-arm64 build/KeepWork-x86_64
codesign --force --sign - "$APP"
echo "Built $APP"
