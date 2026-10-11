import QtQuick

QtObject {
  id: themeRoot

  property QtObject colors: QtObject {
    // Zen palette — mirrors ~/.config/zen/zen.sh and ~/.config/hypr/colors.conf

    property color main: "#1c1c1c"
    property color accent1: "#87afaf"   // slate-teal  (primary)
    property color accent2: "#87d7af"   // seafoam     (secondary)
    property color dark: "#303030"
    property color light: "#878787"

    property color foreground: "#87afaf"
    property color background: "#1c1c1c"
    property color cursor: "#878787"
    property color selection: "#3a3a3a"

    property color black: "#444444"
    property color red: "#d78787"
    property color green: "#87af87"
    property color yellow: "#d7af5f"
    property color blue: "#87afaf"
    property color purple: "#87d7af"    // no purple in zen — seafoam stands in
    property color cyan: "#87d7af"
    property color white: "#878787"

    property color barBg: "#ee1c1c1c"
    property color barBorder: "#303030"
    property color surface: "#303030"
    property color overlay: "#3a3a3a"
    property color muted: "#6e6e6e"
    property color subtle: "#444444"

    property color charging: "#87d7af"
    property color lowBattery: "#d78787"
    property color mediumBattery: "#d7af5f"
    property color highBattery: "#87d7af"
    property color idleOn: "#87d7af"
    property color idleOff: "#d78787"
    property color online: "#87d7af"
    property color offline: "#d78787"

    // Dynamic accent (set by ColorQuantizer from wallpaper)
    property color accent: "#87afaf"
    property color accentMuted: "#87afaf55"
  }

  function setAccentColor(hexColor) {
    if (!hexColor || hexColor.length < 7) return
    colors.accent = hexColor
    colors.accentMuted = hexColor + "55"
  }
}
