import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Services.UPower
import Quickshell.Widgets

// One bar per screen. The primary screen — the BenQ GL2580 at the desk,
// whichever machine it's plugged into, otherwise the first screen (laptop
// undocked) — gets the full bar. Others get a slim strip: workspaces,
// clock and now-playing.
//
// Hardware-dependent widgets (battery, backlight, the llama-server unit)
// only load where that hardware/service exists, so one file serves every
// machine.
ShellRoot {
  id: shell

  readonly property string primaryModel: "BenQ GL2580"

  readonly property var primaryScreen: {
    const screens = Quickshell.screens
    for (let i = 0; i < screens.length; i++) {
      if (screens[i].model === primaryModel) return screens[i]
    }
    return screens.length > 0 ? screens[0] : null
  }

  property bool hasBacklight: false
  property bool hasLlamaServer: false

  Process {
    running: true
    command: ["sh", "-c", "ls /sys/class/backlight | grep -q . && echo yes"]
    stdout: StdioCollector { onStreamFinished: shell.hasBacklight = this.text.trim() === "yes" }
  }

  Process {
    running: true
    command: ["sh", "-c", "systemctl --user cat llama-server.service >/dev/null 2>&1 && echo yes"]
    stdout: StdioCollector { onStreamFinished: shell.hasLlamaServer = this.text.trim() === "yes" }
  }

  Variants {
    model: Quickshell.screens

    delegate: Component {
      PanelWindow {
        id: root
        property var modelData
        screen: modelData
        property int fontSize: 14
        property bool isPrimary: modelData === shell.primaryScreen

        anchors.top: true
        anchors.left: true
        anchors.right: true
        implicitHeight: 34
        WlrLayershell.exclusiveZone: implicitHeight + 4
        color: "transparent"

        Theme { id: theme }

        ColorQuantizer {
          id: quantizer
          onColorsChanged: {
            if (colors && colors.length > 0) {
              // QML colours stringify as #rrggbb or #aarrggbb; keep the rgb part.
              theme.setAccentColor("#" + colors[0].toString().slice(-6))
            }
          }
        }

        Component.onCompleted: Qt.callLater(() => wallpaperLookup.running = true)

        // Accent colour comes from the wallpaper: the first `path =` in
        // hyprpaper's config (a single fallback block covers every screen).
        Process {
          id: wallpaperLookup
          command: ["sh", "-c",
            "sed -n 's/^[[:space:]]*path[[:space:]]*=[[:space:]]*//p' ~/.config/hypr/hyprpaper.conf | head -1 | sed \"s|^~|$HOME|\""]
          stdout: StdioCollector {
            onStreamFinished: {
              var path = this.text.trim()
              if (path) quantizer.source = "file://" + path
            }
          }
        }

        Rectangle {
          id: barBg
          anchors.fill: parent
          color: theme.colors.barBg
          radius: 0
          border.width: 1
          border.color: theme.colors.barBorder

          // Left section
          Row {
            id: leftRow
            anchors.left: parent.left
            anchors.leftMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            spacing: 10

            Workplaces {
              id: workspaces
              fontSize: root.fontSize
            }

            Loader {
              active: root.isPrimary
              anchors.verticalCenter: parent.verticalCenter
              sourceComponent: Rectangle {
                width: 1
                height: 16
                color: theme.colors.subtle
                radius: 1
              }
            }

            Loader {
              active: root.isPrimary
              sourceComponent: CurrentApplication {
                fontSize: root.fontSize
              }
            }

            Rectangle {
              width: 1
              height: 20
              color: theme.colors.subtle
              radius: 1
              anchors.verticalCenter: parent.verticalCenter
              visible: nowPlaying.trackText !== ""
            }

            NowPlaying {
              id: nowPlaying
              fontSize: root.fontSize
            }
          }

          // Center section
          Item {
            anchors.centerIn: parent

            DateTime {
              format: "HH:mm  ddd dd MMM"
              fontSize: root.fontSize
              anchors.centerIn: parent
            }
          }

          // Right section — primary screen only. Loaders rather than
          // `visible: false` so widgets that aren't shown don't run their
          // pollers or register duplicate IPC handlers (volume, brightness).
          Loader {
            active: root.isPrimary
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter

            sourceComponent: Row {
              spacing: 14

              Volume {
                anchors.verticalCenter: parent.verticalCenter
                fontSize: root.fontSize
                colors: theme.colors
              }

              Loader {
                active: shell.hasBacklight
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: Brightness { fontSize: root.fontSize }
              }

              SysMonitor {
                anchors.verticalCenter: parent.verticalCenter
                fontSize: root.fontSize
              }

              StorageMount {
                anchors.verticalCenter: parent.verticalCenter
                fontSize: root.fontSize
              }

              Loader {
                active: shell.hasLlamaServer
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: LlamaServer { fontSize: root.fontSize }
              }

              IdleInhibit {
                anchors.verticalCenter: parent.verticalCenter
                fontSize: root.fontSize
              }

              Internet {
                anchors.verticalCenter: parent.verticalCenter
                fontSize: root.fontSize
              }

              Loader {
                active: UPower.displayDevice.isLaptopBattery
                anchors.verticalCenter: parent.verticalCenter
                sourceComponent: Battery { fontSize: root.fontSize }
              }
            }
          }
        }
      }
    }
  }
}
