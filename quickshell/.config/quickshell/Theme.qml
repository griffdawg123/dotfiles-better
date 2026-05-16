import QtQuick

QtObject {
  id: themeRoot

  property QtObject colors: QtObject {
    // Static Tokyo Night base colors
    property color main: "#1E1738"
    property color accent1: "#770175"
    property color accent2: "#E435B8"
    property color dark: "#2A2A31"
    property color light: "#FDE8E9"

    property color foreground: "#a9b1dc"
    property color background: "#1a1b2c"
    property color cursor: "#c0caf5"
    property color selection: "#28344a"

    property color black: "#414868"
    property color red: "#f7768e"
    property color green: "#73daca"
    property color yellow: "#e0af68"
    property color blue: "#7aa2f7"
    property color purple: "#bb9af7"
    property color cyan: "#7dcfff"
    property color white: "#c0caf5"

    property color barBg: "#ee1a1b2c"
    property color barBorder: "#2a2b3c"
    property color surface: "#24283b"
    property color overlay: "#292e42"
    property color muted: "#565f89"
    property color subtle: "#3b4261"

    property color charging: "#73daca"
    property color lowBattery: "#f7768e"
    property color mediumBattery: "#e0af68"
    property color highBattery: "#73daca"
    property color idleOn: "#73daca"
    property color idleOff: "#f7768e"
    property color online: "#73daca"
    property color offline: "#f7768e"

    // Dynamic accent colors (set by ColorQuantizer)
    property color accent: "#bb9af7"
    property color accentMuted: "#bb9af755"
  }

  function setAccentColor(hexColor) {
    if (!hexColor || hexColor.length < 7) return
    colors.accent = hexColor
    colors.accentMuted = hexColor + "55"
  }
}
