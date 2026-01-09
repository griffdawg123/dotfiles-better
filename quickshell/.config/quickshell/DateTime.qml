import Quickshell
import QtQuick

Text {
  required property string format
  id: clock
  color: "#c0caf5"
  font.pixelSize: 18
  Timer {
    interval: 1000 // every second
    running: true
    repeat: true
    onTriggered: clock.text = Qt.formatDateTime(new Date(), clock.format)
  }
}
