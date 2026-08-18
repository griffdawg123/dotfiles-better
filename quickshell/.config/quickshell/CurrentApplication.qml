import QtQuick
import Quickshell
import Quickshell.Io

// KDE/KWin port: Hyprland pushed activewindow events over its own IPC socket.
// KWin doesn't expose the focused window over any public D-Bus API (by design,
// for privacy), and its scripting engine can't write files or spawn processes
// to bridge that out either -- so this shells out to `kdotool` (an xdotool-alike
// for KDE Wayland, AUR: kdotool-bin) on a short poll instead of a live event feed.
// Needs: yay -S kdotool-bin
Text {
  property int fontSize: 18
  id: currentApplication
  font.pixelSize: fontSize
  color: theme.colors.purple
  text: ""

  function getAppName(appId) {
    if (!appId) return ""
    var nameMap = {
      "zen": "Zen Browser",
      "firefox": "Firefox",
      "chromium": "Chromium",
      "chrome": "Chrome",
      "alacritty": "Alacritty",
      "kitty": "Kitty",
      "ghostty": "Ghostty",
      "code": "VS Code",
      "code-oss": "VS Code",
      "spotify": "Spotify",
      "discord": "Discord",
      "slack": "Slack",
      "thunderbird": "Thunderbird",
      "org.kde.dolphin": "Dolphin",
      "org.kde.konsole": "Konsole",
      "steam": "Steam",
      "foot": "Foot",
      "wezterm": "WezTerm"
    }
    var lower = appId.toLowerCase()
    return nameMap[lower] || appId
  }

  Process {
    id: getActiveClass
    command: ["sh", "-c", "kdotool getactivewindow getwindowclassname 2>/dev/null"]
    stdout: StdioCollector {
      onStreamFinished: {
        var appId = this.text.trim()
        currentApplication.text = appId ? " " + currentApplication.getAppName(appId) + " " : ""
      }
    }
  }

  Timer {
    interval: 600
    running: true
    repeat: true
    onTriggered: getActiveClass.running = true
  }

  Component.onCompleted: getActiveClass.running = true
}
