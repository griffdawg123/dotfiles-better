import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts

PanelWindow {

  id: root
  property int fontSize: 18

  anchors.top: true
  anchors.left: true
  anchors.right: true
  implicitHeight: 40
  color: "#1a1b26"

  Item {
    anchors.fill: parent
    anchors.margins: 4

    // Left side: Workspaces
    Workplaces {
      id: workspaces
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      fontSize: root.fontSize
    }

    // Divider
    Rectangle {
      id: divider
      anchors.left: workspaces.right
      anchors.leftMargin: 8
      anchors.verticalCenter: parent.verticalCenter
      width: 1
      height: parent.height * 0.6
      color: "#565f89"
    }

    CurrentApplication {
      id: application
      fontSize: root.fontSize
      anchors.left: divider.right
      anchors.leftMargin: 8
      anchors.verticalCenter: parent.verticalCenter
    }

    // Center: DateTime
    DateTime {
      id: datetime
      format: "HH:mm:ss dd/MM"
      anchors.centerIn: parent
    }

    // Right side: Brightness
    Brightness {
      id: brightness
      anchors.right: internet.left
      anchors.rightMargin: 180
      anchors.verticalCenter: parent.verticalCenter
      fontSize: root.fontSize
    }
    
    // Right side: Internet
    Internet {
      id: internet
      anchors.right: battery.left
      anchors.rightMargin: 120
      anchors.verticalCenter: parent.verticalCenter
      fontSize: root.fontSize
    }
    
    // Right side: Battery
    Battery {
      id: battery
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
    }
  }
}
