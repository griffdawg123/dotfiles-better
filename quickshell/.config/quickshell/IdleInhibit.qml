import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
  id: idleInhibitContainer

  property int fontSize: 18
  // "active"   -> hypridle running, auto-lock/screen-off timers enabled
  // "inactive" -> hypridle killed, screen forced to stay awake
  property string state: "unknown"
  property bool busy: false

  readonly property bool idling: state === "active"

  color: "transparent"
  implicitWidth: idleRow.implicitWidth + 8
  implicitHeight: idleRow.implicitHeight

  Process {
    id: stateCheck
    command: ["sh", "-c", "pgrep -x hypridle >/dev/null && echo active || echo inactive"]
    stdout: StdioCollector {
      onStreamFinished: {
        idleInhibitContainer.state = this.text.trim() || "unknown"
        idleInhibitContainer.busy = false
      }
    }
  }

  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: stateCheck.running = true
  }

  // hypridle is autostarted directly (exec-once in config/autostart.conf),
  // not a systemd unit, so inhibiting = killing the process outright and
  // resuming = respawning it detached. Killing it also drops before_sleep_cmd
  // (lock-before-suspend), which is an acceptable trade for "stay awake now".
  Process {
    id: inhibitProc
    command: ["pkill", "-x", "hypridle"]
    onExited: Qt.callLater(function() { stateCheck.running = true })
  }

  Timer {
    id: resumeRecheck
    interval: 300
    onTriggered: stateCheck.running = true
  }

  function resume() {
    Quickshell.execDetached(["hypridle"])
    resumeRecheck.start()
  }

  Row {
    id: idleRow
    spacing: 5
    anchors.verticalCenter: parent.verticalCenter

    Text {
      anchors.verticalCenter: parent.verticalCenter
      font.pixelSize: idleInhibitContainer.fontSize
      opacity: idleInhibitContainer.busy ? 0.5 : 1
      color: idleInhibitContainer.idling ? theme.colors.idleOn : theme.colors.idleOff
      text: idleInhibitContainer.idling ? "🔒" : "☕"
    }

    Text {
      id: idleLabel
      anchors.verticalCenter: parent.verticalCenter
      font.pixelSize: idleInhibitContainer.fontSize
      opacity: idleInhibitContainer.busy ? 0.5 : 1
      color: idleInhibitContainer.idling ? theme.colors.foreground : theme.colors.idleOff
      text: idleInhibitContainer.idling ? "Idle" : "Awake"

      MouseArea {
        id: idleMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          if (idleInhibitContainer.busy) return
          idleInhibitContainer.busy = true
          if (idleInhibitContainer.idling) {
            inhibitProc.running = true
          } else {
            idleInhibitContainer.resume()
          }
        }
      }
    }
  }

  Rectangle {
    id: idleTooltip
    visible: idleMouseArea.containsMouse
    anchors.bottom: parent.top
    anchors.bottomMargin: 6
    anchors.horizontalCenter: parent.horizontalCenter
    color: theme.colors.surface
    radius: 8
    border.width: 1
    border.color: theme.colors.barBorder
    implicitWidth: idleTooltipText.implicitWidth + 16
    implicitHeight: idleTooltipText.implicitHeight + 10

    Text {
      id: idleTooltipText
      anchors.centerIn: parent
      font.pixelSize: idleInhibitContainer.fontSize * 0.75
      color: theme.colors.foreground
      text: idleInhibitContainer.idling
          ? "Auto-lock/screen-off enabled — click to keep the screen awake"
          : "Screen forced awake — click to re-enable auto-lock"
    }
  }

  Component.onCompleted: stateCheck.running = true
}
