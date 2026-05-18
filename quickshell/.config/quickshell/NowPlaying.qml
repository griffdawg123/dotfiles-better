import Quickshell
import QtQuick
import Quickshell.Services.Mpris

Item {
  id: nowPlayingRoot
  property int fontSize: 16
  height: 30
  implicitWidth: nowPlayingText.width + 10

  // Expose trackText so shell.qml can hide the divider when nothing is playing
  property string trackText: {
    var players = Mpris.players.values
    for (var i = 0; i < players.length; i++) {
      var p = players[i]
      if (p.playbackStatus === MprisPlaybackStatus.Playing) {
        var title = p.trackTitle || ""
        var artists = p.trackArtists || []
        var artist = artists.length > 0 ? artists[0] : ""
        return artist ? title + " — " + artist : title
      }
    }
    return ""
  }

  property color trackColor: {
    var players = Mpris.players.values
    for (var i = 0; i < players.length; i++) {
      var p = players[i]
      if (p.playbackStatus === MprisPlaybackStatus.Playing) {
        var name = (p.identity || "").toLowerCase()
        if (name.indexOf("spotify") !== -1) return theme.colors.green
        if (name.indexOf("firefox") !== -1 || name.indexOf("zen") !== -1 || name.indexOf("chromium") !== -1) return theme.colors.yellow
        return theme.colors.accent1
      }
    }
    return theme.colors.muted
  }

  Text {
    id: nowPlayingText
    color: nowPlayingRoot.trackColor
    font.pixelSize: nowPlayingRoot.fontSize
    font.bold: true
    text: nowPlayingRoot.trackText
    anchors.verticalCenter: parent.verticalCenter
    width: Math.min(implicitWidth, 240)
    elide: Text.ElideRight
  }
}
