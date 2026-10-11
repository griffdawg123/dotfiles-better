import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
  id: storageContainer

  property int fontSize: 18
  property bool mounted: false
  property bool checking: false

  color: "transparent"
  implicitWidth: storageRow.implicitWidth + 8
  implicitHeight: storageRow.implicitHeight

  Process {
    id: mountCheck
    // mountpoint -q confirms it's a real mount; the stat ensures it's actually responsive
    command: ["bash", "-c", "mountpoint -q /mnt/stowage-share && stat /mnt/stowage-share > /dev/null 2>&1 && echo ok || echo error"]
    stdout: StdioCollector {
      onStreamFinished: {
        storageContainer.mounted = this.text.trim() === "ok"
        storageContainer.checking = false
      }
    }
  }

  Timer {
    interval: 15000
    running: true
    repeat: true
    onTriggered: mountCheck.running = true
  }

  Row {
    id: storageRow
    spacing: 5
    anchors.verticalCenter: parent.verticalCenter

    Text {
      anchors.verticalCenter: parent.verticalCenter
      font.pixelSize: storageContainer.fontSize
      color: storageContainer.mounted ? theme.colors.online : theme.colors.offline
      text: storageContainer.mounted ? "󰋊" : "󰋚"
    }

    Text {
      anchors.verticalCenter: parent.verticalCenter
      font.pixelSize: storageContainer.fontSize
      color: storageContainer.mounted ? theme.colors.foreground : theme.colors.offline
      text: storageContainer.mounted ? "stowage" : "stowage!"
    }
  }

  Component.onCompleted: mountCheck.running = true
}
