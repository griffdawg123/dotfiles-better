import Quickshell
import QtQuick

Text {
  required property string format
  property int fontSize: 18
  id: clock
  color: theme.colors.foreground
  font.pixelSize: fontSize
  font.bold: true
  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: clock.text = Qt.formatDateTime(new Date(), clock.format)
  }
}
