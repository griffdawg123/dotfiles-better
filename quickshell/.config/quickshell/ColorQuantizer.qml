import Quickshell
import Quickshell.Io
import QtQuick

Item {
  id: quantizerRoot
  visible: false

  ColorQuantizer {
    id: quantizer
    source: ""
    onColorsChanged: {
      if (colors && colors.length > 0) {
        var hex = "#" + colors[0].toString(16).slice(-6)
        theme.setAccentColor(hex)
      }
    }
  }

  function loadWallpaperFromHyprpaper() {
    var home = Quickshell.env("HOME")
    var xdg = Quickshell.env("XDG_CONFIG_HOME") || (home + "/.config")
    var confPath = xdg + "/hypr/hyprpaper.conf"

    var proc = Qt.createQmlObject(`
      import Quickshell;
      import Quickshell.Io;
      import QtQuick;
      Process {
        command: ["bash", "-c", "cat ${confPath}"]
        stdout: StdioCollector {
          onStreamFinished: {
            var text = this.text
            var match = text.match(/path\\s*=\\s*(.+)/)
            if (match) {
              var rawPath = match[1].trim()
              var path = rawPath.replace(/^~/, "${home}").replace(/\\s+/, " ")
              quantizer.source = path
            }
          }
        }
      }
    `, quantizerRoot)

    proc.exec(proc.command)
  }
}
