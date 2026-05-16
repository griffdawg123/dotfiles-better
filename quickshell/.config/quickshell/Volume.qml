import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
  id: volumeRoot

  property int fontSize: 18
  property int volume: 0
  property bool muted: false
  property var colors

  color: "transparent"
  radius: 8
  implicitWidth: volumeRow.implicitWidth + 8
  implicitHeight: volumeRow.implicitHeight

  Process {
    id: volumeCheck
    command: ["bash", "-c", "pactl get-sink-volume @DEFAULT_SINK@; pactl get-sink-mute @DEFAULT_SINK@"]
    stdout: StdioCollector {
      onStreamFinished: {
        var output = this.text

        var volMatch = output.match(/(\d+)%/)
        if (volMatch) {
          volumeRoot.volume = parseInt(volMatch[1])
        }

        volumeRoot.muted = output.indexOf("Mute: yes") !== -1
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: volumeCheck.running = true
  }

  Row {
    id: volumeRow
    spacing: 4
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter

    Text {
      id: volumeIcon
      font.pixelSize: volumeRoot.fontSize
      color: volumeRoot.muted ? theme.colors.offline : theme.colors.yellow
      text: {
        if (volumeRoot.muted) return "\u{1F507}"
        if (volumeRoot.volume >= 60) return "\u{1F50A}"
        if (volumeRoot.volume >= 20) return "\u{1F509}"
        return "\u{1F508}"
      }
    }

    Text {
      id: volumeText
      font.pixelSize: volumeRoot.fontSize
      font.bold: true
      color: volumeRoot.muted ? theme.colors.offline : theme.colors.yellow
      text: volumeRoot.volume + "%"

      MouseArea {
        id: volumeMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          Quickshell.execDetached(["pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle"])
          Qt.callLater(function() { volumeCheck.running = true })
        }
        onWheel: function(wheel) {
          if (wheel.angleDelta.y > 0) {
            Quickshell.execDetached(["pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%"])
          } else {
            Quickshell.execDetached(["pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%"])
          }
          Qt.callLater(function() { volumeCheck.running = true })
        }
      }
    }
  }

  Rectangle {
    id: volumeTooltip
    visible: volumeMouseArea.containsMouse
    anchors.bottom: parent.top
    anchors.bottomMargin: 6
    anchors.horizontalCenter: parent.horizontalCenter
    color: theme.colors.surface
    radius: 8
    border.width: 1
    border.color: theme.colors.barBorder
    implicitWidth: volumeTooltipText.implicitWidth + 16
    implicitHeight: volumeTooltipText.implicitHeight + 10

    Text {
      id: volumeTooltipText
      anchors.centerIn: parent
      font.pixelSize: volumeRoot.fontSize * 0.75
      color: theme.colors.foreground
      text: volumeRoot.muted ? "Muted — click to unmute" : "Scroll to adjust, click to mute"
    }
  }

  Component.onCompleted: volumeCheck.running = true

  IpcHandler {
    target: "volume"
    function volumeUpdate(): void {
      volumeCheck.running = true
    }
  }
}
