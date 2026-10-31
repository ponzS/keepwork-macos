import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private let normalItem = NSMenuItem(title: "正常模式", action: #selector(selectNormal), keyEquivalent: "")
    private let serverItem = NSMenuItem(title: "服务器模式（合盖不睡）", action: #selector(selectServer), keyEquivalent: "")

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        let menu = NSMenu()
        menu.delegate = self
        normalItem.target = self
        serverItem.target = self
        menu.addItem(normalItem)
        menu.addItem(serverItem)
        menu.addItem(.separator())
        menu.addItem(NSMenuItem(title: "退出", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        statusItem.menu = menu

        refresh()
    }

    // 每次打开菜单时重新读取系统状态，防止被终端里的 pmset 改过
    func menuWillOpen(_ menu: NSMenu) { refresh() }

    @objc private func selectNormal() { setSleepDisabled(false) }
    @objc private func selectServer() { setSleepDisabled(true) }

    private func refresh() {
        let server = Self.isSleepDisabled()
        normalItem.state = server ? .off : .on
        serverItem.state = server ? .on : .off

        let symbol = server ? "bolt.fill" : "moon.zzz"
        let image = NSImage(systemSymbolName: symbol, accessibilityDescription: server ? "服务器模式" : "正常模式")
        image?.isTemplate = true
        statusItem.button?.image = image
        statusItem.button?.toolTip = server ? "KeepWork：服务器模式（合盖不睡）" : "KeepWork：正常模式"
    }

    private func setSleepDisabled(_ disabled: Bool) {
        guard Self.isSleepDisabled() != disabled else { refresh(); return }

        // pmset disablesleep 需要 root，这里通过系统授权弹窗执行
        let source = "do shell script \"/usr/bin/pmset -a disablesleep \(disabled ? 1 : 0)\" with administrator privileges"
        var error: NSDictionary?
        NSAppleScript(source: source)?.executeAndReturnError(&error)

        if let error, (error[NSAppleScript.errorNumber] as? Int) != -128 { // -128 = 用户取消
            let alert = NSAlert()
            alert.messageText = "切换失败"
            alert.informativeText = (error[NSAppleScript.errorMessage] as? String) ?? "未知错误"
            NSApp.activate(ignoringOtherApps: true)
            alert.runModal()
        }
        refresh()
    }

    static func isSleepDisabled() -> Bool {
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/pmset")
        task.arguments = ["-g"]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = Pipe()
        do { try task.run() } catch { return false }
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        task.waitUntilExit()
        let output = String(decoding: data, as: UTF8.self)
        for line in output.split(separator: "\n") {
            let parts = line.split(whereSeparator: { $0 == " " || $0 == "\t" })
            if parts.count >= 2, parts[0] == "SleepDisabled" { return parts[1] == "1" }
        }
        return false
    }
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.setActivationPolicy(.accessory)
app.run()
