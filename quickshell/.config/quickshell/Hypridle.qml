import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
  id: hypridleContainer

  property int fontSize: 18
  property bool isRunning: false

  color: "transparent"
  radius: 8
  implicitWidth: hypridleRow.implicitWidth
  implicitHeight: hypridleRow.implicitHeight

  Behavior on color { ColorAnimation { duration: 150 } }

  Process {
    id: statusCheck
    command: ["pgrep", "-x", "hypridle"]
    stdout: StdioCollector {
      onStreamFinished: {
        hypridleContainer.isRunning = this.text.trim() !== ""
      }
    }
  }

  Process {
    id: killProcess
    command: ["pkill", "-x", "hypridle"]
    onExited: statusCheck.exec(["pgrep", "-x", "hypridle"])
  }

  Timer {
    id: updateTimer
    interval: 2000
    running: true
    repeat: true
    onTriggered: statusCheck.exec(["pgrep", "-x", "hypridle"])
  }

  Row {
    id: hypridleRow
    spacing: 6
    anchors.verticalCenter: parent.verticalCenter

    Text {
      id: hypridleIcon
      font.pixelSize: hypridleContainer.fontSize
      color: hypridleContainer.isRunning ? theme.colors.idleOn : theme.colors.idleOff
      text: hypridleContainer.isRunning ? "\u23FE" : "\u23FB"
    }

    Text {
      id: hypridleText
      font.pixelSize: hypridleContainer.fontSize
      font.bold: true
      color: hypridleContainer.isRunning ? theme.colors.idleOn : theme.colors.idleOff
      text: hypridleContainer.isRunning ? "Idle" : "Awake"
    }
  }

  MouseArea {
    id: hypridleMouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: {
      if (hypridleContainer.isRunning) {
        killProcess.running = true
      } else {
        Quickshell.execDetached(["hypridle"])
        Qt.callLater(function() {
          statusCheck.exec(["pgrep", "-x", "hypridle"])
        })
      }
    }
  }

  Rectangle {
    id: hypridleTooltip
    visible: hypridleMouseArea.containsMouse
    anchors.bottom: parent.top
    anchors.bottomMargin: 6
    anchors.horizontalCenter: parent.horizontalCenter
    color: theme.colors.surface
    radius: 8
    border.width: 1
    border.color: theme.colors.barBorder
    implicitWidth: tooltipText.implicitWidth + 16
    implicitHeight: tooltipText.implicitHeight + 10

    Text {
      id: tooltipText
      anchors.centerIn: parent
      font.pixelSize: hypridleContainer.fontSize * 0.75
      color: theme.colors.foreground
      text: hypridleContainer.isRunning
        ? "Hypridle active — click to disable"
        : "Hypridle stopped — click to enable"
    }
  }

  Component.onCompleted: statusCheck.exec(["pgrep", "-x", "hypridle"])
}
