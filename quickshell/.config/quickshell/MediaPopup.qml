import Quickshell
import Quickshell.Services.Mpris
import QtQuick
import QtQuick.Controls

Rectangle {
  id: mediaPopup
  color: theme.colors.surface
  width: 360
  height: 420

  property var player: Mpris.players.values[0]
  property string title: player?.identity || "Unknown"
  property string artist: player?.metadata?.xesamArtist?.[0] || ""
  property string album: player?.metadata?.xesamAlbum || ""
  property var artworkUrl: player?.metadata?.mprisArtUrl || ""
  property bool playing: player?.playbackStatus === "Playing"
  property double position: player?.position || 0
  property double length: player?.metadata?.mprisLength || 0

  function formatTime(ms) {
    if (!ms || ms <= 0) return "0:00"
    var seconds = Math.floor(ms / 1000000)
    var mins = Math.floor(seconds / 60)
    var secs = seconds % 60
    return mins + ":" + (secs < 10 ? "0" : "") + secs
  }

  Column {
    anchors.fill: parent
    anchors.margins: 20
    spacing: 16

    // Album Art
    Rectangle {
      width: parent.width
      height: 200
      color: theme.colors.overlay
      radius: 8

      Rectangle {
        anchors.fill: parent
        anchors.margins: 8
        color: theme.colors.overlay
        radius: 4

        Image {
          id: albumArt
          anchors.fill: parent
          source: mediaPopup.artworkUrl.replace("file://", "")
          fillMode: Image.PreserveAspectFit
          visible: mediaPopup.artworkUrl !== ""
        }
      }

      Text {
        anchors.centerIn: parent
        text: "\u{1F3B5}"
        font.pixelSize: 64
        color: theme.colors.muted
        visible: mediaPopup.artworkUrl === ""
      }
    }

    // Track Info
    Column {
      spacing: 4

      Text {
        id: trackTitle
        text: mediaPopup.title
        color: theme.colors.foreground
        font.bold: true
        font.pixelSize: 18
        elide: Text.ElideRight
      }

      Text {
        id: trackArtist
        text: mediaPopup.artist
        color: theme.colors.muted
        font.pixelSize: 14
        elide: Text.ElideRight
      }
    }

    // Progress Slider
    Column {
      spacing: 4

      Slider {
        id: progressSlider
        width: parent.width
        from: 0
        to: mediaPopup.length || 1000000
        value: mediaPopup.position
        onMoved: {
          if (mediaPopup.player) {
            mediaPopup.player.seek(value - mediaPopup.position)
          }
        }
      }

      Row {
        width: parent.width
        Text {
          text: formatTime(mediaPopup.position)
          color: theme.colors.muted
          font.pixelSize: 11
        }
        Text {
          text: formatTime(mediaPopup.length)
          color: theme.colors.muted
          font.pixelSize: 11
          x: parent.width - width
        }
      }
    }

    // Playback Controls
    Row {
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 24

      Text {
        text: "\u{23EE}"
        font.pixelSize: 28
        color: theme.colors.foreground
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: if (mediaPopup.player) mediaPopup.player.previous()
        }
      }

      Text {
        text: mediaPopup.playing ? "\u{23F8}" : "\u{25B6}"
        font.pixelSize: 36
        color: theme.colors.accent
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            if (mediaPopup.player) {
              if (mediaPopup.playing) {
                mediaPopup.player.pause()
              } else {
                mediaPopup.player.play()
              }
            }
          }
        }
      }

      Text {
        text: "\u{23ED}"
        font.pixelSize: 28
        color: theme.colors.foreground
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: if (mediaPopup.player) mediaPopup.player.next()
        }
      }
    }

    // Fast Forward / Rewind (10s)
    Row {
      anchors.horizontalCenter: parent.horizontalCenter
      spacing: 40

      Text {
        text: "-10s"
        color: theme.colors.muted
        font.pixelSize: 12
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            if (mediaPopup.player) {
              var newPos = Math.max(0, mediaPopup.position - 10000000)
              mediaPopup.player.seek(newPos - mediaPopup.position)
            }
          }
        }
      }

      Text {
        text: "+10s"
        color: theme.colors.muted
        font.pixelSize: 12
        MouseArea {
          anchors.fill: parent
          cursorShape: Qt.PointingHandCursor
          onClicked: {
            if (mediaPopup.player) {
              var newPos = Math.min(mediaPopup.length, mediaPopup.position + 10000000)
              mediaPopup.player.seek(newPos - mediaPopup.position)
            }
          }
        }
      }
    }
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: {
      var p = Mpris.players.values[0]
      if (p) {
        mediaPopup.player = p
        mediaPopup.title = p.identity || "Unknown"
        mediaPopup.artist = p.metadata?.xesamArtist?.[0] || ""
        mediaPopup.artworkUrl = p.metadata?.mprisArtUrl || ""
        mediaPopup.playing = p.playbackStatus === "Playing"
        mediaPopup.position = p.position || 0
        mediaPopup.length = p.metadata?.mprisLength || 0
      }
    }
  }
}
