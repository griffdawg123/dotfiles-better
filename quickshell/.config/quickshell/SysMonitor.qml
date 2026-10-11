import Quickshell
import Quickshell.Io
import QtQuick

Row {
  id: root
  property int fontSize: 18
  spacing: 10

  // CPU
  property real cpuPercent: 0
  property var _cpuTotal: 0
  property var _cpuIdle: 0

  // RAM
  property real ramPercent: 0

  // Disk
  property real diskPercent: 0

  // Only surface CPU/RAM alerts above this threshold
  property real alertThreshold: 80

  // One bash pass reads both /proc/stat (CPU) and /proc/meminfo (RAM)
  Process {
    id: sysRead
    running: false
    command: ["bash", "-c",
      "awk '/^cpu /{t=$2+$3+$4+$5+$6+$7+$8+$9;i=$5+$6;printf \"cpu %s %s\\n\",t,i}" +
      " /^MemTotal:/{tot=$2} /^MemAvailable:/{av=$2}" +
      " END{printf \"mem %s %s\\n\",tot,av}' /proc/stat /proc/meminfo"
    ]
    stdout: StdioCollector {
      onStreamFinished: {
        var lines = this.text.trim().split("\n")
        for (var i = 0; i < lines.length; i++) {
          var p = lines[i].trim().split(" ")
          if (p[0] === "cpu" && p.length >= 3) {
            var total = parseFloat(p[1])
            var idle  = parseFloat(p[2])
            if (root._cpuTotal > 0) {
              var dt = total - root._cpuTotal
              var di = idle  - root._cpuIdle
              if (dt > 0)
                root.cpuPercent = Math.max(0, Math.min(100, (1 - di / dt) * 100))
            }
            root._cpuTotal = total
            root._cpuIdle  = idle
          } else if (p[0] === "mem" && p.length >= 3) {
            var memTotal = parseFloat(p[1])
            var memAvail = parseFloat(p[2])
            if (memTotal > 0)
              root.ramPercent = (memTotal - memAvail) / memTotal * 100
          }
        }
      }
    }
  }

  // Disk changes slowly — poll every 30s
  Process {
    id: diskRead
    running: false
    command: ["bash", "-c", "df / | awk 'NR==2{sub(/%/,\"\"); print $5}'"]
    stdout: StdioCollector {
      onStreamFinished: {
        var v = parseFloat(this.text.trim())
        if (!isNaN(v)) root.diskPercent = v
      }
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    onTriggered: sysRead.running = true
  }

  Timer {
    interval: 30000
    running: true
    repeat: true
    onTriggered: diskRead.running = true
  }

  // Disk — always visible; muted when healthy, yellow >75%, red >90%
  Text {
    font.pixelSize: root.fontSize
    anchors.verticalCenter: parent.verticalCenter
    color: root.diskPercent >= 90 ? theme.colors.red
         : root.diskPercent >= 75 ? theme.colors.yellow
         : theme.colors.muted
    text: "/ " + Math.round(root.diskPercent) + "%"
  }

  // CPU — only shows when ≥ alertThreshold
  Text {
    visible: root.cpuPercent >= root.alertThreshold
    font.pixelSize: root.fontSize
    anchors.verticalCenter: parent.verticalCenter
    color: root.cpuPercent >= 95 ? theme.colors.red : theme.colors.yellow
    text: "CPU " + Math.round(root.cpuPercent) + "%"
  }

  // RAM — only shows when ≥ alertThreshold
  Text {
    visible: root.ramPercent >= root.alertThreshold
    font.pixelSize: root.fontSize
    anchors.verticalCenter: parent.verticalCenter
    color: root.ramPercent >= 95 ? theme.colors.red : theme.colors.yellow
    text: "MEM " + Math.round(root.ramPercent) + "%"
  }

  Component.onCompleted: {
    sysRead.running = true
    diskRead.running = true
  }
}
