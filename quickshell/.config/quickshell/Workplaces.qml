import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts

RowLayout {
  id: workspaces
  property int fontSize: 18
  spacing: 4

  Repeater {
    model: 9
    Rectangle {
      property var ws: Hyprland.workspaces.values.find(e => e.id === index + 1)
      property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
      property bool isOccupied: ws !== undefined && ws !== null

      Layout.preferredWidth: isActive ? workspaceText.implicitWidth + 20 : (isOccupied ? workspaceText.implicitWidth + 14 : workspaceText.implicitWidth + 12)
      Layout.preferredHeight: 28
      radius: isActive ? 14 : 8
      color: isActive ? theme.colors.selection : (isOccupied ? theme.colors.surface : "transparent")
      border.width: isActive ? 1 : 0
      border.color: isActive ? theme.colors.blue : "transparent"

      Behavior on Layout.preferredWidth { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
      Behavior on color { ColorAnimation { duration: 150 } }
      Behavior on border.color { ColorAnimation { duration: 150 } }

      Text {
        id: workspaceText
        anchors.centerIn: parent
        text: " " + (index + 1) + " "
        color: parent.isActive ? theme.colors.blue : (parent.isOccupied ? theme.colors.foreground : theme.colors.muted)
        font.bold: parent.isActive
        font.pixelSize: workspaces.fontSize
      }

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: Hyprland.dispatch("workspace " + (index + 1))
      }
    }
  }
}
