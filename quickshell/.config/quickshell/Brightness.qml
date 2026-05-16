import Quickshell
import Quickshell.Io
import QtQuick

Text {
  id: brightness
  property int fontSize: 18
  property string brightnessValue: "0%"
  property var brightnessCommand: ["brightnessctl", "info"]

  text: "\u2600 " + brightnessValue
  color: theme.colors.yellow
  font.bold: true
  font.pixelSize: fontSize

  Process {
    id: brightnessProcess
    command: brightness.brightnessCommand
    stdout: StdioCollector {
      onStreamFinished: {
        var match = this.text.match(/\((\d+)%\)/)
        if (match) {
          brightnessValue = match[1] + "%"
        }
      }
    }
  }

  IpcHandler {
    target: "brightness"
    function brightnessUpdate(): void {
        brightnessProcess.exec(brightness.brightnessCommand)
    }
  }

  Component.onCompleted: brightnessProcess.exec(brightness.brightnessCommand)
}
