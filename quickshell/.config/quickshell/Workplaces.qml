import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts

RowLayout {
  id: workspaces
  property int fontSize: 18
  Repeater {
    model: 9
    Text {
      property var ws: Hyprland.workspaces.values.find(e => e.id === index + 1)
      property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
      text: " " + (index + 1) + " "
      color: isActive ? "#f7768e" : "#c0caf5"
      font.bold: isActive
      font.pixelSize: workspaces.fontSize
      MouseArea {
        anchors.fill: parent
        onClicked: Hyprland.dispatch("workspace " + (index + 1))
      }
    }
  }
}

