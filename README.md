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

## Requirements

- macOS 13 or later
- Apple Silicon (the build script targets `arm64`)
- Xcode or the Xcode Command Line Tools (for `swiftc`)

## Build

```bash
git clone https://github.com/ponzS/keepwork-macos.git
cd keepwork-macos
./build.sh
open build/KeepWork.app
```

The app is written to `build/KeepWork.app`. You can move it to `/Applications`.

The app is ad-hoc signed, not notarized. If macOS blocks it on first launch, right-click the app and choose Open.

## Launch at login

Open System Settings → General → Login Items and add `KeepWork.app`.

## Project layout

```
Sources/main.swift   All app code
Info.plist           App metadata (menu bar only, no Dock icon)
build.sh             Build script
```

## License

[MIT](LICENSE)
