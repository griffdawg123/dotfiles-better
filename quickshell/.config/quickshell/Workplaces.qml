import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
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
      id: wsRect

      property var ws: Hyprland.workspaces.values.find(e => e.id === index + 1)
      property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
      property bool isOccupied: ws !== undefined && ws !== null

      // Get all clients on this workspace
      property var wsClients: Hyprland.clients.values.filter(c => c.workspace?.id === index + 1)
      property bool hasSingleWindow: isOccupied && wsClients.length === 1

      // Look up desktop entry icon for the single window's app class
      property string appClass: hasSingleWindow ? wsClients[0].class : ""
      property var desktopEntry: appClass !== "" ? DesktopEntries.heuristicLookup(appClass) : null
      property string iconName: desktopEntry?.icon ?? ""
      property bool showIcon: hasSingleWindow && iconName !== ""

      Layout.preferredWidth: isActive ? innerContent.implicitWidth + 20 : (isOccupied ? innerContent.implicitWidth + 14 : innerContent.implicitWidth + 12)
      Layout.preferredHeight: 28
      radius: isActive ? 14 : 8
      color: isActive ? theme.colors.selection : (isOccupied ? theme.colors.surface : "transparent")
      border.width: isActive ? 1 : 0
      border.color: isActive ? theme.colors.blue : "transparent"

      Behavior on Layout.preferredWidth { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
      Behavior on color { ColorAnimation { duration: 150 } }
      Behavior on border.color { ColorAnimation { duration: 150 } }

      Item {
        id: innerContent
        anchors.centerIn: parent
        implicitWidth: wsRect.showIcon ? wsIcon.implicitWidth : workspaceText.implicitWidth
        implicitHeight: wsRect.showIcon ? wsIcon.implicitHeight : workspaceText.implicitHeight

        IconImage {
          id: wsIcon
          anchors.centerIn: parent
          implicitSize: workspaces.fontSize
          source: wsRect.iconName
          visible: wsRect.showIcon
          opacity: wsRect.showIcon ? 1 : 0
          Behavior on opacity { NumberAnimation { duration: 100 } }
        }

        Text {
          id: workspaceText
          anchors.centerIn: parent
          text: " " + (index + 1) + " "
          color: wsRect.isActive ? theme.colors.blue : (wsRect.isOccupied ? theme.colors.foreground : theme.colors.muted)
          font.bold: wsRect.isActive
          font.pixelSize: workspaces.fontSize
          visible: !wsRect.showIcon
          opacity: wsRect.showIcon ? 0 : 1
          Behavior on opacity { NumberAnimation { duration: 100 } }
        }
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
