import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.Mpris
import QtQuick.Controls

Rectangle {
  id: audioRoot

  color: theme.colors.surface
  implicitWidth: 320
  implicitHeight: 350

  Column {
    id: mainColumn
    anchors.fill: parent
    anchors.margins: 12
    spacing: 12

    // Volume Section
    Rectangle {
      width: parent.width
      height: 80
      color: theme.colors.overlay
      radius: 8

      Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        Text {
          text: "Volume"
          color: theme.colors.foreground
          font.bold: true
          font.pixelSize: 14
        }

        Row {
          spacing: 8
          height: 32

          Text {
            id: volIcon
            font.pixelSize: 18
            color: audioRoot.muted ? theme.colors.offline : theme.colors.yellow
            text: {
              if (audioRoot.muted) return "\u{1F507}"
              if (audioRoot.volume >= 60) return "\u{1F50A}"
              if (audioRoot.volume >= 20) return "\u{1F509}"
              return "\u{1F508}"
            }
          }

          Slider {
            id: volSlider
            width: 160
            height: 32
            from: 0
            to: 100
            value: audioRoot.volume
            onMoved: {
              Quickshell.execDetached(["pactl", "set-sink-volume", "@DEFAULT_SINK@", value + "%"])
            }
          }

          Text {
            text: audioRoot.volume + "%"
            color: theme.colors.foreground
            font.pixelSize: 14
            width: 40
          }
        }
      }
    }

    // Audio Outputs Section
    Rectangle {
      width: parent.width
      height: 100
      color: theme.colors.overlay
      radius: 8

      Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        Text {
          text: "Audio Output"
          color: theme.colors.foreground
          font.bold: true
          font.pixelSize: 14
        }

        Text {
          text: "Built-in Audio"
          color: theme.colors.blue
          font.pixelSize: 12
        }
      }
    }

    // Bluetooth Section
    Rectangle {
      width: parent.width
      height: 120
      color: theme.colors.overlay
      radius: 8

      Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        Text {
          text: "Bluetooth"
          color: theme.colors.foreground
          font.bold: true
          font.pixelSize: 14
        }

        Text {
          text: "No devices connected"
          color: theme.colors.muted
          font.pixelSize: 12
        }
      }
    }
  }

  property int volume: 0
  property bool muted: false

  Process {
    id: volumeCheck
    command: ["bash", "-c", "pactl get-sink-volume @DEFAULT_SINK@; pactl get-sink-mute @DEFAULT_SINK@"]
    stdout: StdioCollector {
      onStreamFinished: {
        var output = this.text
        var volMatch = output.match(/(\d+)%/)
        if (volMatch) {
          audioRoot.volume = parseInt(volMatch[1])
        }
        audioRoot.muted = output.indexOf("Mute: yes") !== -1
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: volumeCheck.running = true
  }

  Component.onCompleted: {
    volumeCheck.running = true
  }
}
