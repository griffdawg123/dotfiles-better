import Quickshell
import Quickshell.Io
import QtQuick

Item {
  id: nowPlayingRoot
  property int fontSize: 16
  height: 30
  implicitWidth: nowPlayingText.implicitWidth + 10

  function getProviderColor(playerName, title) {
    var combined = (playerName + " " + (title || "")).toLowerCase()
    if (combined.indexOf("spotify") !== -1) return theme.colors.green
    if (combined.indexOf("youtube") !== -1) return theme.colors.red
    if (combined.indexOf("firefox") !== -1) return theme.colors.red
    return theme.colors.yellow
  }

  Process {
    id: playerctlProc
    command: ["playerctl", "-p", "spotify", "metadata", "--format", "{{status}}|{{title}}|{{artist}}"]
    stdout: StdioCollector {
      onStreamFinished: {
        var output = this.text.trim()
        
        if (!output || output.indexOf("No players found") !== -1) {
          spotifyCheck.running = true
          return
        }
        
        var parts = output.split("|")
        var status = parts[0] || ""
        var title = parts[1] || ""
        var artist = parts[2] || ""
        
        if (status === "Playing" && title) {
          nowPlayingRoot.activePlayer = "spotify"
          nowPlayingRoot.providerColor = getProviderColor("spotify", title)
          if (artist) {
            nowPlayingText.text = title + " - " + artist
          } else {
            nowPlayingText.text = title
          }
        } else {
          firefoxCheck.running = true
        }
      }
    }
  }

  Process {
    id: firefoxCheck
    command: ["playerctl", "-p", "firefox.instance_1_38", "metadata", "--format", "{{status}}|{{title}}|{{artist}}"]
    stdout: StdioCollector {
      onStreamFinished: {
        var output = this.text.trim()
        
        if (!output || output.indexOf("No players found") !== -1) {
          nowPlayingText.text = ""
          nowPlayingRoot.providerColor = theme.colors.muted
          nowPlayingRoot.activePlayer = ""
          return
        }
        
        var parts = output.split("|")
        var status = parts[0] || ""
        var title = parts[1] || ""
        var artist = parts[2] || ""
        
        if (status === "Playing" && title) {
          nowPlayingRoot.activePlayer = "firefox"
          nowPlayingRoot.providerColor = getProviderColor("firefox", title)
          if (artist) {
            nowPlayingText.text = title + " - " + artist
          } else {
            nowPlayingText.text = title
          }
        } else {
          nowPlayingText.text = ""
          nowPlayingRoot.providerColor = theme.colors.muted
          nowPlayingRoot.activePlayer = ""
        }
      }
    }
  }

  Process {
    id: spotifyCheck
    command: ["playerctl", "-p", "spotify", "status"]
    stdout: StdioCollector {
      onStreamFinished: {
        var output = this.text.trim()
        if (output === "Playing") {
          playerctlProc.running = true
        } else {
          firefoxCheck.running = true
        }
      }
    }
  }

  property color providerColor: theme.colors.muted
  property string activePlayer: ""

  Text {
    id: nowPlayingText
    color: nowPlayingRoot.providerColor
    font.pixelSize: nowPlayingRoot.fontSize
    font.bold: true
    text: ""
    anchors.verticalCenter: parent.verticalCenter
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: spotifyCheck.running = true
  }

  Component.onCompleted: spotifyCheck.running = true
}
