#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
APP="build/KeepWork.app"
rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"
cp Info.plist "$APP/Contents/Info.plist"
swiftc -O -target arm64-apple-macosx13.0 Sources/main.swift -o "$APP/Contents/MacOS/KeepWork"
codesign --force --sign - "$APP"
echo "Built $APP"
