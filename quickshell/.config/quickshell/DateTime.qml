import Quickshell
import QtQuick

Text {
  required property string format
  id: clock
  color: theme.colors.foreground
  font.pixelSize: 18
  font.bold: true
  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: clock.text = Qt.formatDateTime(new Date(), clock.format)
  }
}
