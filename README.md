English | [简体中文](README.zh-CN.md)

# KeepWork

KeepWork is a small macOS menu bar app that keeps your Mac awake with the lid closed. It has no window. It only shows an icon in the menu bar.

By default, a MacBook goes to sleep when you close the lid, even when it is plugged in. This stops downloads, builds, servers, and other long-running tasks. KeepWork lets you switch your Mac into "server mode" so it keeps running with the lid closed.

## Modes

| Mode | Icon | Behavior |
| --- | --- | --- |
| Normal | moon with zzz | Default macOS behavior. Closing the lid puts the Mac to sleep. |
| Server | lightning bolt | The Mac does not sleep, even with the lid closed. |

Click the menu bar icon to pick a mode. The current mode has a checkmark. The menu also has a Quit item.

## How it works

KeepWork runs `pmset -a disablesleep 1` for server mode and `pmset -a disablesleep 0` for normal mode. This setting needs administrator rights, so macOS asks for your password each time you switch.

Each time you open the menu, KeepWork reads the current state from `pmset -g`. The checkmark stays correct even if you change the setting from Terminal.

## Important

- **Quitting KeepWork does not switch back to normal mode.** Server mode stays on, even after a restart, until you switch back.
- **Server mode also applies on battery.** Switch back to normal mode before you put the Mac in a bag. Otherwise it keeps running, drains the battery, and heats up.
- With the lid closed the Mac cools less well. Keep it on a hard, open surface.

## Install

1. Download `KeepWork-x.y.z.dmg` from [Releases](https://github.com/ponzS/keepwork-macos/releases/latest).
2. Open the DMG and drag `KeepWork.app` into the `Applications` folder.
3. Open KeepWork from `Applications`.

KeepWork is not signed with an Apple Developer ID or notarized, so macOS blocks it on first launch. To allow it, choose one:

- Open System Settings → Privacy & Security, scroll down, and click **Open Anyway** next to the KeepWork message.
- Or run this in Terminal:

  ```bash
  xattr -dr com.apple.quarantine /Applications/KeepWork.app
  ```

Requires macOS 13 or later. Works on both Apple Silicon and Intel Macs.

## Build from source

Requires Xcode or the Xcode Command Line Tools (for `swiftc`).

```bash
git clone https://github.com/ponzS/keepwork-macos.git
cd keepwork-macos
./build.sh
open build/KeepWork.app
```

The app is written to `build/KeepWork.app`. You can move it to `/Applications`.

To build the DMG, run `./package.sh`. It writes `build/KeepWork-<version>.dmg`, using the version in `Info.plist`.

## Launch at login

Open System Settings → General → Login Items and add `KeepWork.app`.

## Project layout

```
Sources/main.swift   All app code
Info.plist           App metadata (menu bar only, no Dock icon)
build.sh             Builds the app (universal: arm64 + x86_64)
package.sh           Builds the app and packages it into a DMG
```

## License

[MIT](LICENSE)
