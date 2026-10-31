[English](README.md) | 简体中文

# KeepWork

KeepWork 是一个 macOS 顶部菜单栏小工具，用来让 Mac 合盖后也不睡眠。它没有窗口，只在菜单栏显示一个图标。

默认情况下，MacBook 合盖就会睡眠，即使插着电源也一样。下载、编译、服务器等长时间运行的任务都会因此中断。KeepWork 可以把 Mac 切换到“服务器模式”，合盖后继续运行。

## 模式

| 模式 | 图标 | 行为 |
| --- | --- | --- |
| 正常模式 | 月亮带 zzz | macOS 默认行为，合盖即睡眠。 |
| 服务器模式 | 闪电 | 合盖也不睡眠。 |

点击菜单栏图标即可选择模式，当前模式前面会打勾。菜单里还有“退出”选项。

## 原理

KeepWork 在服务器模式下执行 `pmset -a disablesleep 1`，在正常模式下执行 `pmset -a disablesleep 0`。这个设置需要管理员权限，所以每次切换时系统都会弹窗要求输入密码。

每次打开菜单，KeepWork 都会通过 `pmset -g` 重新读取当前状态。即使你在终端里手动改过设置，菜单里的勾选也是准确的。

## 注意事项

- **退出 KeepWork 不会自动切回正常模式。** 服务器模式会一直生效，重启后也是，直到你手动切回。
- **服务器模式在用电池时同样生效。** 把电脑放进包里之前请切回正常模式，否则它会一直运行，耗电发热。
- 合盖时散热会变差，请把电脑放在坚硬、通风的平面上。

## 安装

1. 从 [Releases](https://github.com/ponzS/keepwork-macos/releases/latest) 下载 `KeepWork-x.y.z.dmg`。
2. 打开 DMG，把 `KeepWork.app` 拖进 `Applications`（应用程序）文件夹。
3. 在“应用程序”里打开 KeepWork。

KeepWork 没有用 Apple Developer ID 签名，也没有经过公证，所以首次打开会被系统拦截。任选一种方式放行：

- 打开“系统设置 → 隐私与安全性”，往下滑，在 KeepWork 的提示旁点击 **仍要打开**。
- 或者在终端里运行：

  ```bash
  xattr -dr com.apple.quarantine /Applications/KeepWork.app
  ```

需要 macOS 13 或更高版本，Apple Silicon 和 Intel 芯片的 Mac 都支持。

## 从源码构建

需要 Xcode 或 Xcode Command Line Tools（提供 `swiftc`）。

```bash
git clone https://github.com/ponzS/keepwork-macos.git
cd keepwork-macos
./build.sh
open build/KeepWork.app
```

编译好的应用在 `build/KeepWork.app`，可以拖到“应用程序”文件夹里。

运行 `./package.sh` 可以打出 DMG 安装包，输出为 `build/KeepWork-<版本号>.dmg`，版本号取自 `Info.plist`。

## 开机自启

打开“系统设置 → 通用 → 登录项”，把 `KeepWork.app` 加进去。

## 项目结构

```
Sources/main.swift   全部应用代码
Info.plist           应用配置（只在菜单栏显示，不出现在 Dock）
build.sh             构建应用（通用二进制：arm64 + x86_64）
package.sh           构建应用并打包成 DMG
```

## 许可证

[MIT](LICENSE)
