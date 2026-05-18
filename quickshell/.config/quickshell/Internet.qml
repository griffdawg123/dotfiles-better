import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
  id: internetContainer

  property int fontSize: 18
  property string connectionType: "none"
  property string wifiName: ""
  property int wifiStrength: 0
  property bool vpnConnected: false

  color: "transparent"
  radius: 8
  implicitWidth: internetRow.implicitWidth + 8
  implicitHeight: internetRow.implicitHeight

  Behavior on color { ColorAnimation { duration: 150 } }

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

  Process {
    id: vpnCheck
    command: ["bash", "-c", "ip link show | grep -qE ' (proton|tun)[0-9]*:' && echo 'connected' || echo 'disconnected'"]
    stdout: StdioCollector {
      onStreamFinished: {
        internetContainer.vpnConnected = this.text.trim() === "connected"
      }
    }
  }

  Timer {
    id: updateTimer
    interval: 2000
    running: true
    repeat: true
    onTriggered: {
      wiredCheck.running = true
      vpnCheck.running = true
    }
  }

  Row {
    id: internetRow
    spacing: 6
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter

    Text {
      id: connectionIcon
      anchors.verticalCenter: parent.verticalCenter
      font.pixelSize: internetContainer.fontSize

      color: {
        if (internetContainer.connectionType === "none") return theme.colors.offline
        if (internetContainer.connectionType === "wireless") {
          if (internetContainer.wifiStrength < 20) return theme.colors.red
          if (internetContainer.wifiStrength < 50) return theme.colors.yellow
        }
        return theme.colors.online
      }

      text: {
        if (internetContainer.connectionType === "wired") {
          return "\u{1F50C}"
        } else if (internetContainer.connectionType === "wireless") {
          if (internetContainer.wifiStrength >= 80) return "\u25CF\u25CF\u25CF\u25CF"
          else if (internetContainer.wifiStrength >= 50) return "\u25CF\u25CF\u25CF\u25CB"
          else if (internetContainer.wifiStrength >= 20) return "\u25CF\u25CF\u25CB\u25CB"
          else return "\u25CF\u25CB\u25CB\u25CB"
        } else {
          return "\u26D4"
        }
      }
    }

    Text {
      id: connectionText
      color: internetContainer.connectionType === "none" ? theme.colors.offline : theme.colors.foreground
      font.pixelSize: internetContainer.fontSize
      anchors.verticalCenter: parent.verticalCenter

      text: {
        if (internetContainer.connectionType === "wired") {
          return "Wired"
        } else if (internetContainer.connectionType === "wireless") {
          return internetContainer.wifiName || "Unknown"
        } else {
          return "Offline"
        }
      }

      MouseArea {
        id: internetMouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: {
          nmtuiProc.exec(["alacritty", "-e", "nmtui"])
        }
      }

      Process {
        id: nmtuiProc
        command: ["alacritty", "-e", "nmtui"]
      }
    }

    Text {
      id: vpnIcon
      visible: internetContainer.vpnConnected
      anchors.verticalCenter: parent.verticalCenter
      font.pixelSize: internetContainer.fontSize
      color: theme.colors.online
      text: "\u{1F512}"
    }
  }

  Rectangle {
    id: internetTooltip
    visible: internetMouseArea.containsMouse
    anchors.bottom: parent.top
    anchors.bottomMargin: 6
    anchors.horizontalCenter: parent.horizontalCenter
    color: theme.colors.surface
    radius: 8
    border.width: 1
    border.color: theme.colors.barBorder
    implicitWidth: internetTooltipText.implicitWidth + 16
    implicitHeight: internetTooltipText.implicitHeight + 10

    Text {
      id: internetTooltipText
      anchors.centerIn: parent
      font.pixelSize: internetContainer.fontSize * 0.75
      color: theme.colors.foreground
      text: {
        var status = ""
        if (internetContainer.connectionType === "wireless") {
          status = internetContainer.wifiName + " (" + internetContainer.wifiStrength + "%)"
        } else if (internetContainer.connectionType === "wired") {
          status = "Wired Connection"
        } else {
          status = "No Internet Connection"
        }
        if (internetContainer.vpnConnected) {
          status += "\nVPN Connected"
        }
        return status
      }
    }
  }

  Component.onCompleted: {
    wiredCheck.running = true
    vpnCheck.running = true
  }
}
