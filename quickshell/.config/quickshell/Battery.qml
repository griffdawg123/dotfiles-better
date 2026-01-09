import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Controls

Rectangle {
  id: batteryContainer
  
  // Color scheme variables
  property color textColor: "#c0caf5"
  property color lowBatteryTextColor: "#f7768e"
  property color borderColor: "#c0caf5"
  property color lowBatteryBorderColor: "#f7768e"
  property color iconBackgroundColor: "#1a1b26"
  property color noBatteryFillColor: "#565f89"
  property color lowBatteryFillColor: "#f7768e"
  property color mediumBatteryFillColor: "#e0af68"
  property color highBatteryFillColor: "#9ece6a"
  property color tooltipBgColor: "#1a1b26"
  property color tooltipTextColor: "#c0caf5"
  property color tooltipBorderColor: "#565f89"
  property int fontSize: 18
  
  color: "transparent"
  radius: 8
  border.width: 2
  border.color: "transparent"
  
  property var battery: UPower.devices.values.find(device => device.type === UPowerDeviceType.Battery)
  property bool lowBattery: battery && Math.round(battery.percentage * 100) <= 15
  
  // Time formatting functions
  function formatTime(seconds) {
    if (seconds <= 0) return "Unknown"
    var hours = Math.floor(seconds / 3600)
    var minutes = Math.floor((seconds % 3600) / 60)
    if (hours > 0) {
      return hours + "h " + minutes + "m"
    } else {
      return minutes + "m"
    }
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
  
  // Flashing red border when battery is low
  Timer {
    id: flashTimer
    interval: 500
    running: batteryContainer.lowBattery
    repeat: true
    onTriggered: batteryContainer.border.color = batteryContainer.border.color === "transparent" ? lowBatteryBorderColor : "transparent"
  }
  
  Row {
    id: batteryRow
    spacing: 8
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: 8
    
    // Battery icon
    Rectangle {
      id: batteryIcon
      width: 30
      height: 16
      anchors.verticalCenter: parent.verticalCenter
      color: iconBackgroundColor
      border.color: borderColor
      border.width: 1
      radius: 2
      
      // Battery tip
      Rectangle {
        width: 3
        height: 6
        anchors.right: parent.left
        anchors.rightMargin: -3
        anchors.verticalCenter: parent.verticalCenter
        color: borderColor
        radius: 1
      }
      
      // Battery fill
      Rectangle {
        id: batteryFill
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.margins: 2
        color: batteryContainer.battery ? 
               (batteryContainer.battery.percentage <= 0.15 ? lowBatteryFillColor : 
                batteryContainer.battery.percentage <= 0.30 ? mediumBatteryFillColor : highBatteryFillColor) : noBatteryFillColor
        width: batteryContainer.battery ? (parent.width - 4) * batteryContainer.battery.percentage : 0
        
        Behavior on width { NumberAnimation { duration: 300 } }
      }
    }
    
    // Battery text with integrated mouse area
    Text {
      id: batteryText
      color: batteryContainer.lowBattery ? lowBatteryTextColor : textColor
      font.pixelSize: batteryContainer.fontSize
      anchors.verticalCenter: parent.verticalCenter
      
      text: {
        if (!batteryContainer.battery) {
          return "No Battery"
        }
        
        var percentage = Math.round(batteryContainer.battery.percentage * 100)
        var isCharging = !UPower.onBattery
        var chargingIcon = isCharging ? "⚡" : ""
        
        return percentage + "% " + chargingIcon
      }
      
      MouseArea {
        id: batteryMouseArea
        anchors.fill: parent
        hoverEnabled: true
      }
    }
  }

  ToolTip {
    id: batteryTooltip
    visible: batteryMouseArea.containsMouse && batteryContainer.battery 
    text: batteryContainer.timeInfo
  }
}
