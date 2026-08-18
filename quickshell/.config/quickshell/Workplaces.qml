import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts

// KDE/KWin port: Hyprland exposed workspaces over its own IPC socket.
// KWin exposes virtual desktops over the standard org.kde.KWin.VirtualDesktopManager
// D-Bus interface instead, so this polls that (same Process+Timer idiom the
// rest of this bar already uses for Hypridle) rather than subscribing to a socket.
RowLayout {
  id: workspaces
  property int fontSize: 18
  property var desktops: []   // [{id, name}]
  property string currentId: ""
  spacing: 4

  function refresh() {
    getState.running = true
  }

  Process {
    id: getCurrent
    command: ["qdbus6", "org.kde.KWin", "/VirtualDesktopManager", "org.kde.KWin.VirtualDesktopManager.current"]
    stdout: StdioCollector {
      onStreamFinished: {
        workspaces.currentId = this.text.trim()
      }
    }
  }

  Process {
    id: getDesktops
    command: ["sh", "-c",
      "qdbus6 --literal org.kde.KWin /VirtualDesktopManager org.freedesktop.DBus.Properties.Get org.kde.KWin.VirtualDesktopManager desktops"]
    stdout: StdioCollector {
      onStreamFinished: {
        // Output looks like: [Argument: a(uss) {[Argument: (uss) 0, "<uuid>", "Desktop 1"], ...}]
        var text = this.text
        var list = []
        var re = /\(uss\)\s+\d+,\s+"([^"]+)",\s+"([^"]*)"/g
        var m
        while ((m = re.exec(text)) !== null) {
          list.push({ id: m[1], name: m[2] })
        }
        workspaces.desktops = list
      }
    }
  }

  Timer {
    interval: 400
    running: true
    repeat: true
    onTriggered: {
      getCurrent.running = true
      getDesktops.running = true
    }
  }

  Component.onCompleted: {
    getCurrent.running = true
    getDesktops.running = true
  }

  Repeater {
    model: workspaces.desktops
    Rectangle {
      required property var modelData
      required property int index
      property bool isActive: modelData.id === workspaces.currentId

      Layout.preferredWidth: isActive ? label.implicitWidth + 20 : label.implicitWidth + 14
      Layout.preferredHeight: 28
      radius: isActive ? 14 : 8
      color: isActive ? theme.colors.selection : theme.colors.surface
      border.width: isActive ? 1 : 0
      border.color: isActive ? theme.colors.blue : "transparent"

      Behavior on Layout.preferredWidth { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
      Behavior on color { ColorAnimation { duration: 150 } }
      Behavior on border.color { ColorAnimation { duration: 150 } }

      Text {
        id: label
        anchors.centerIn: parent
        text: " " + (index + 1) + " "
        color: parent.isActive ? theme.colors.blue : theme.colors.foreground
        font.bold: parent.isActive
        font.pixelSize: workspaces.fontSize
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: {
          switchDesktop.command = ["qdbus6", "org.kde.KWin", "/VirtualDesktopManager",
            "org.freedesktop.DBus.Properties.Set", "org.kde.KWin.VirtualDesktopManager",
            "current", modelData.id]
          switchDesktop.running = true
        }
      }
    }
  }

  Process {
    id: switchDesktop
  }
}
