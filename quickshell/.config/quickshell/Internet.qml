import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls

Rectangle {
  id: internetContainer
  
  // Color scheme variables
  property color textColor: "#c0caf5"
  property color noConnectionTextColor: "#f7768e"
  property color iconColor: "#9ece6a"
  property color noConnectionIconColor: "#f7768e"
  property color tooltipBgColor: "#1a1b26"
  property color tooltipTextColor: "#c0caf5"
  property color tooltipBorderColor: "#565f89"
  property int fontSize: 18
  
  color: "transparent"
  radius: 8
  border.width: 2
  border.color: "transparent"
  
  // Network information
  property string connectionType: "none"
  property string wifiName: ""
  property int wifiStrength: 0
  
  // Process to check for wired connection
  Process {
    id: wiredCheck
    command: ["bash", "-c", "nmcli -t -f TYPE,DEVICE connection show --active | grep ethernet"]
    stdout: StdioCollector {
      onStreamFinished: {
        if (this.text.trim() !== "") {
          internetContainer.connectionType = "wired"
          internetContainer.wifiName = ""
          internetContainer.wifiStrength = 0
        } else {
          wifiCheck.running = true
        }
      }
    }
  }
  
  // Process to check for WiFi connection
  Process {
    id: wifiCheck
    command: ["bash", "-c", "nmcli -t -f TYPE,DEVICE,NAME connection show --active | grep wireless"]
    stdout: StdioCollector {
      onStreamFinished: {
        var wifiOutput = this.text.trim()
        if (wifiOutput !== "") {
          internetContainer.connectionType = "wireless"
          var parts = wifiOutput.split(":")
          internetContainer.wifiName = parts.length >= 3 ? parts[2] : "Unknown"
          signalCheck.running = true
        } else {
          internetContainer.connectionType = "none"
          internetContainer.wifiName = ""
          internetContainer.wifiStrength = 0
        }
      }
    }
  }
  
  // Process to get WiFi signal strength
  Process {
    id: signalCheck
    command: ["bash", "-c", "nmcli -t -f IN-USE,SIGNAL device wifi list | grep '*'"]
    stdout: StdioCollector {
      onStreamFinished: {
        var signalOutput = this.text.trim()
        if (signalOutput !== "") {
          var signalParts = signalOutput.split(":")
          internetContainer.wifiStrength = signalParts.length >= 2 ? parseInt(signalParts[1]) : 0
        }
      }
    }
  }
  
  // Timer to update network status
  Timer {
    id: updateTimer
    interval: 2000
    running: true
    repeat: true
    onTriggered: wiredCheck.running = true;
  }
  
  Row {
    id: internetRow
    spacing: 8
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    anchors.margins: 8
    
    // Connection icon
    Text {
      id: connectionIcon
      anchors.verticalCenter: parent.verticalCenter
      font.pixelSize: internetContainer.fontSize
      color: internetContainer.connectionType === "none" ? noConnectionIconColor : iconColor
      
      text: {
        if (internetContainer.connectionType === "wired") {
          return "🔌"
        } else if (internetContainer.connectionType === "wireless") {
          // WiFi strength icons
          if (internetContainer.wifiStrength >= 80) return "📶"
          else if (internetContainer.wifiStrength >= 60) return "📡"
          else if (internetContainer.wifiStrength >= 40) return "📶"
          else if (internetContainer.wifiStrength >= 20) return "📡"
          else return "📶"
        } else {
          return "❌"
        }
      }
    }
    
    // Connection text
    Text {
      id: connectionText
      color: internetContainer.connectionType === "none" ? noConnectionTextColor : textColor
      font.pixelSize: internetContainer.fontSize
      anchors.verticalCenter: parent.verticalCenter
      
      text: {
        if (internetContainer.connectionType === "wired") {
          return "Wired"
        } else if (internetContainer.connectionType === "wireless") {
          return internetContainer.wifiName || "Unknown"
        } else {
          return "No Connection"
        }
      }
      
      MouseArea {
        id: internetMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
          nmtuiProc.exec(["alacritty", "-e", "nmtui"])
        }
      }

      Process {
        id: nmtuiProc
        command: ["alacritty", "-e", "nmtui"]
      }
    }
  }
  
  ToolTip {
    id: internetTooltip
    visible: internetMouseArea.containsMouse
    text: {
      if (internetContainer.connectionType === "wireless") {
        return "WiFi: " + internetContainer.wifiName + " (" + internetContainer.wifiStrength + "%)"
      } else if (internetContainer.connectionType === "wired") {
        return "Wired Connection"
      } else {
        return "No Internet Connection"
      }
    }
  }
  
  Component.onCompleted: wiredCheck.running = true
}
