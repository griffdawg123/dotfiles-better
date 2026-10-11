import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
  id: llamaContainer

  property int fontSize: 18
  // "active" | "inactive" | "failed" | "activating" | "deactivating" | "unknown"
  property string state: "unknown"
  property bool busy: false

  readonly property bool running: state === "active"

  color: "transparent"
  implicitWidth: llamaRow.implicitWidth + 8
  implicitHeight: llamaRow.implicitHeight

  Process {
    id: stateCheck
    command: ["systemctl", "--user", "is-active", "llama-server"]
    stdout: StdioCollector {
      onStreamFinished: {
        llamaContainer.state = this.text.trim() || "unknown"
        llamaContainer.busy = false
      }
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: stateCheck.running = true
  }

  // llama-server runs as a user unit (~/.config/systemd/user/), so no
  // sudo/root involved at all — same account as quickshell itself.
  Process {
    id: stopProc
    command: ["systemctl", "--user", "stop", "llama-server"]
    onExited: Qt.callLater(function() { stateCheck.running = true })
  }

  Process {
    id: startProc
    command: ["systemctl", "--user", "start", "llama-server"]
    onExited: Qt.callLater(function() { stateCheck.running = true })
  }

  Row {
    id: llamaRow
    spacing: 5
    anchors.verticalCenter: parent.verticalCenter

    Text {
      anchors.verticalCenter: parent.verticalCenter
      font.pixelSize: llamaContainer.fontSize
      opacity: llamaContainer.busy ? 0.5 : 1
      color: llamaContainer.state === "failed" ? theme.colors.red
           : llamaContainer.running ? theme.colors.online
           : theme.colors.offline
      text: "🦙"
    }

    Text {
      id: llamaLabel
      anchors.verticalCenter: parent.verticalCenter
      font.pixelSize: llamaContainer.fontSize
      opacity: llamaContainer.busy ? 0.5 : 1
      color: llamaContainer.state === "failed" ? theme.colors.red
           : llamaContainer.running ? theme.colors.foreground
           : theme.colors.offline
      text: llamaContainer.running ? "LLM" : "LLM off"

      MouseArea {
        id: llamaMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          if (llamaContainer.busy) return
          llamaContainer.busy = true
          if (llamaContainer.running) {
            stopProc.running = true
          } else {
            startProc.running = true
          }
        }
      }
    }
  }

  Rectangle {
    id: llamaTooltip
    visible: llamaMouseArea.containsMouse
    anchors.bottom: parent.top
    anchors.bottomMargin: 6
    anchors.horizontalCenter: parent.horizontalCenter
    color: theme.colors.surface
    radius: 8
    border.width: 1
    border.color: theme.colors.barBorder
    implicitWidth: llamaTooltipText.implicitWidth + 16
    implicitHeight: llamaTooltipText.implicitHeight + 10

    Text {
      id: llamaTooltipText
      anchors.centerIn: parent
      font.pixelSize: llamaContainer.fontSize * 0.75
      color: theme.colors.foreground
      text: llamaContainer.state === "failed" ? "llama-server crashed — click to retry"
          : llamaContainer.running ? "llama-server running — click to stop (free VRAM)"
          : "llama-server stopped — click to start"
    }
  }

  Component.onCompleted: stateCheck.running = true
}
