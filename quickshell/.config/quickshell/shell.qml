import Quickshell
import Quickshell.Wayland
import QtQuick
import Quickshell.Hyprland
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Widgets

PanelWindow {
  id: root
  property int fontSize: 17

  anchors.top: true
  anchors.left: true
  anchors.right: true
  implicitHeight: 42
  WlrLayershell.exclusiveZone: implicitHeight + 4
  color: "transparent"

  Theme { id: theme }

  ColorQuantizer {
    id: quantizer
    onColorsChanged: {
      console.log("Colors changed:", colors)
      if (colors && colors.length > 0) {
        var hex = "#" + colors[0].toString(16).slice(-6)
        theme.setAccentColor(hex)
        console.log("Set accent to:", hex)
      }
    }
  }

  Component.onCompleted: {
    Qt.callLater(loadWallpaperPath)
  }

  function loadWallpaperPath() {
    quantizer.source = "file:///home/griffdawg/Downloads/wallpaper.jpg"
  }

  // Semi-transparent background with rounded corners
  Rectangle {
    id: barBg
    anchors.fill: parent
    color: theme.colors.barBg
    radius: 0
    border.width: 1
    border.color: theme.colors.barBorder

    // Left section
    Row {
      id: leftRow
      anchors.left: parent.left
      anchors.leftMargin: 12
      anchors.verticalCenter: parent.verticalCenter
      spacing: 10

      Workplaces {
        id: workspaces
        fontSize: root.fontSize
      }

      Rectangle {
        id: divider
        width: 1
        height: 20
        color: theme.colors.subtle
        radius: 1
        anchors.verticalCenter: parent.verticalCenter
      }

      CurrentApplication {
        id: application
        fontSize: root.fontSize
      }

      Rectangle {
        id: npDivider
        width: 1
        height: 20
        color: theme.colors.subtle
        radius: 1
        anchors.verticalCenter: parent.verticalCenter
      }

      NowPlaying {
        id: nowPlaying
      }
    }

    // Center section
    Item {
      id: centerSection
      anchors.centerIn: parent

      DateTime {
        id: datetime
        format: "HH:mm:ss dd/MM"
        anchors.centerIn: parent
      }
    }

    // Right section
    Item {
      id: rightSection
      anchors.right: parent.right
      anchors.rightMargin: 12
      anchors.verticalCenter: parent.verticalCenter
      height: parent.height - 16

      Volume {
        id: volume
        anchors.right: brightness.left
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        fontSize: root.fontSize
        colors: theme.colors
      }

      Brightness {
        id: brightness
        anchors.right: hypridle.left
        anchors.rightMargin: 16
        anchors.verticalCenter: parent.verticalCenter
        fontSize: root.fontSize
      }

      Hypridle {
        id: hypridle
        anchors.right: internet.left
        anchors.rightMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        fontSize: root.fontSize
      }

      Internet {
        id: internet
        anchors.right: battery.left
        anchors.rightMargin: 14
        anchors.verticalCenter: parent.verticalCenter
        fontSize: root.fontSize
      }

      Battery {
        id: battery
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
      }
    }
  }
}
