import Quickshell
import Quickshell.Services.UPower
import QtQuick

Rectangle {
  id: batteryContainer

  property int fontSize: 18

  color: "transparent"
  radius: 8
  implicitWidth: batteryRow.implicitWidth + 8
  implicitHeight: batteryRow.implicitHeight

  property var battery: UPower.devices && UPower.devices.values ? UPower.devices.values.find(device => device.type === UPowerDeviceType.Battery) : null
  property bool lowBattery: battery ? Math.round(battery.percentage * 100) <= 15 : null

  function formatTime(seconds) {
    if (seconds <= 0) return "Unknown"
    var hours = Math.floor(seconds / 3600)
    var minutes = Math.floor((seconds % 3600) / 60)
    if (hours > 0) return hours + "h " + minutes + "m"
    return minutes + "m"
  }

  property string timeInfo: {
    if (!batteryContainer.battery) return ""
    var isCharging = !UPower.onBattery
    if (isCharging) {
      return "Charging: " + formatTime(batteryContainer.battery.timeToFull)
    } else {
      return "Remaining: " + formatTime(batteryContainer.battery.timeToEmpty)
    }
  }

  property color fillColor: {
    if (!battery) return theme.colors.muted
    if (!UPower.onBattery) return theme.colors.charging
    if (battery.percentage <= 0.15) return theme.colors.lowBattery
    if (battery.percentage <= 0.30) return theme.colors.mediumBattery
    return theme.colors.highBattery
  }

  Timer {
    id: flashTimer
    interval: 500
    running: batteryContainer.lowBattery
    repeat: true
    onTriggered: batteryContainer.border.color = batteryContainer.border.color === "transparent" ? theme.colors.lowBattery : "transparent"
  }

  Row {
    id: batteryRow
    spacing: 8
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter

    Rectangle {
      id: batteryIcon
      width: 32
      height: 16
      anchors.verticalCenter: parent.verticalCenter
      color: "transparent"
      border.color: batteryContainer.lowBattery ? theme.colors.lowBattery : theme.colors.muted
      border.width: 1
      radius: 3

      Rectangle {
        width: 3
        height: 7
        anchors.right: parent.left
        anchors.rightMargin: -1
        anchors.verticalCenter: parent.verticalCenter
        color: batteryContainer.lowBattery ? theme.colors.lowBattery : theme.colors.muted
        radius: 1
      }

      Rectangle {
        id: batteryFill
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 2
        color: batteryContainer.fillColor
        width: batteryContainer.battery ? (parent.width - 4) * batteryContainer.battery.percentage : 0
        radius: 1

        Behavior on width { NumberAnimation { duration: 300 } }
      }
    }

    Text {
      id: batteryText
      color: batteryContainer.lowBattery ? theme.colors.lowBattery : theme.colors.foreground
      font.pixelSize: batteryContainer.fontSize
      anchors.verticalCenter: parent.verticalCenter

      text: {
        if (!batteryContainer.battery) return "No Battery"
        var percentage = Math.round(batteryContainer.battery.percentage * 100)
        var isCharging = !UPower.onBattery
        return percentage + "%" + (isCharging ? " \u26A1" : "")
      }

      MouseArea {
        id: batteryMouseArea
        anchors.fill: parent
        hoverEnabled: true
      }
    }
  }

  Rectangle {
    id: batteryTooltip
    visible: batteryMouseArea.containsMouse && batteryContainer.battery
    anchors.bottom: parent.top
    anchors.bottomMargin: 6
    anchors.horizontalCenter: parent.horizontalCenter
    color: theme.colors.surface
    radius: 8
    border.width: 1
    border.color: theme.colors.barBorder
    implicitWidth: batteryTooltipText.implicitWidth + 16
    implicitHeight: batteryTooltipText.implicitHeight + 10

    Text {
      id: batteryTooltipText
      anchors.centerIn: parent
      font.pixelSize: batteryContainer.fontSize * 0.75
      color: theme.colors.foreground
      text: batteryContainer.timeInfo
    }
  }
}
