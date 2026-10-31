#!/bin/bash
# Build KeepWork.app and package it into a DMG with an Applications shortcut.
set -euo pipefail
cd "$(dirname "$0")"
./build.sh
VERSION=$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" Info.plist)
DMG="build/KeepWork-$VERSION.dmg"
STAGE="build/dmg"
rm -rf "$STAGE" "$DMG"
mkdir -p "$STAGE"
cp -R build/KeepWork.app "$STAGE/"
ln -s /Applications "$STAGE/Applications"
hdiutil create -volname "KeepWork" -srcfolder "$STAGE" -ov -format UDZO "$DMG" >/dev/null
rm -rf "$STAGE"
echo "Built $DMG"
