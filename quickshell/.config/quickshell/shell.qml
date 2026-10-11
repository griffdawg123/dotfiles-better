import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Widgets

// Desktop, two monitors: DP-1 (BenQ GL2580, right-hand, facing straight) is
// primary and gets the full bar. HDMI-A-1 (BenQ GL2480, left-hand, angled —
// YouTube/Discord/Spotify duty) gets a slim strip: workspaces, clock, and
// now-playing, since that's the media monitor.
ShellRoot {
  Variants {
    model: Quickshell.screens

    delegate: Component {
      PanelWindow {
        id: root
        property var modelData
        screen: modelData
        property int fontSize: 14
        property bool isPrimary: modelData.name === "DP-1"

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
            console.log("Colors changed:", colors)
            if (colors && colors.length > 0) {
              var hex = "#" + colors[0].toString(16).slice(-6)
              theme.setAccentColor(hex)
              console.log("Set accent to:", hex)
            }
          }
        }

        Component.onCompleted: {
          Qt.callLater(loadWallpaperPath)
        }

        // Reads this screen's wallpaper straight out of hyprpaper's own
        // config — falls back to the shared `preload` entry if this output
        // has no monitor-specific `wallpaper` line.
        Process {
          id: wallpaperLookup
          command: ["sh", "-c",
            "grep -m1 '^wallpaper = " + root.modelData.name + ",' ~/.config/hypr/hyprpaper.conf | cut -d, -f2- || grep -m1 '^preload = ' ~/.config/hypr/hyprpaper.conf | cut -d= -f2-"]
          stdout: StdioCollector {
            onStreamFinished: {
              var path = this.text.trim()
              if (path) {
                quantizer.source = path.startsWith("file://") ? path : "file://" + path
              }
            }
          }
        }

        function loadWallpaperPath() {
          wallpaperLookup.running = true
        }

        // Semi-transparent background with rounded corners
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
                id: divider
                width: 1
                height: 16
                color: theme.colors.subtle
                radius: 1
              }
            }

            Loader {
              active: root.isPrimary
              sourceComponent: CurrentApplication {
                id: application
                fontSize: root.fontSize
              }
            }

            Rectangle {
              id: npDivider
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
            id: centerSection
            anchors.centerIn: parent

            DateTime {
              id: datetime
              format: "HH:mm  ddd dd MMM"
              fontSize: root.fontSize
              anchors.centerIn: parent
            }
          }

          // Right section — primary monitor only. Loader so Volume/Internet
          // (and their IPC handlers / pollers) aren't even instantiated on
          // the secondary screen — a plain `visible: false` would still
          // create them, which double-registers Volume's IPC handler.
          Loader {
            id: rightSection
            active: root.isPrimary
            anchors.right: parent.right
            anchors.rightMargin: 12
            anchors.verticalCenter: parent.verticalCenter
            height: parent.height - 16

            sourceComponent: Item {
              width: volume.width + 16 + sysMonitor.width + 14 + storageMount.width + 14 + llamaServer.width + 14 + idleInhibit.width + 14 + internet.width
              height: parent.height

              Volume {
                id: volume
                anchors.right: sysMonitor.left
                anchors.rightMargin: 16
                anchors.verticalCenter: parent.verticalCenter
                fontSize: root.fontSize
                colors: theme.colors
              }

              // Battery/Brightness dropped: this is a desktop tower with no
              // battery and no backlight device, so both widgets would just
              // sit there showing "No Battery" / stuck "0%".

              SysMonitor {
                id: sysMonitor
                anchors.right: storageMount.left
                anchors.rightMargin: 14
                anchors.verticalCenter: parent.verticalCenter
                fontSize: root.fontSize
              }

              StorageMount {
                id: storageMount
                anchors.right: llamaServer.left
                anchors.rightMargin: 14
                anchors.verticalCenter: parent.verticalCenter
                fontSize: root.fontSize
              }

              LlamaServer {
                id: llamaServer
                anchors.right: idleInhibit.left
                anchors.rightMargin: 14
                anchors.verticalCenter: parent.verticalCenter
                fontSize: root.fontSize
              }

              IdleInhibit {
                id: idleInhibit
                anchors.right: internet.left
                anchors.rightMargin: 14
                anchors.verticalCenter: parent.verticalCenter
                fontSize: root.fontSize
              }

              Internet {
                id: internet
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                fontSize: root.fontSize
              }
            }
          }
        }
      }
    }
  }
}
