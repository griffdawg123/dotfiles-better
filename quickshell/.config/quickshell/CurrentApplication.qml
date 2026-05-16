import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

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
      " nautilus": "Files",
      "org.freedesktop.Nautilus": "Files",
      "foot": "Foot",
      "wezterm": "WezTerm"
    }
    var lower = appId.toLowerCase()
    return nameMap[lower] || appId
  }

  function updateApp() {
    var toplevel = Hyprland.activeToplevel
    if (toplevel && toplevel.wayland) {
      var appId = toplevel.wayland.appId || ""
      currentApplication.text = " " + getAppName(appId) + " "
    }
  }

  Socket {
    path: `${Quickshell.env("XDG_RUNTIME_DIR")}/hypr/${Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")}/.socket2.sock`
    connected: true

    parser: SplitParser {
      property var regex: new RegExp("\(activewindow>>(.+),.*\)");
      onRead: msg => {
        const match = regex.exec(msg);
        if (match != null) {
          Qt.callLater(updateApp)
        }
      }
    }
  }

  Component.onCompleted: updateApp()
}
