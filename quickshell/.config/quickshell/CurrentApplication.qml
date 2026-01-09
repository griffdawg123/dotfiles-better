import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Text {
  property int fontSize: 18
  id: currentApplication
  font.pixelSize: fontSize
  color: "#9ece6a"
  text: ""
  property var getApplicationName: [`${Quickshell.env("HOME")}/.config/quickshell/scripts/get_current_active_window_initial_title.sh`, Hyprland.activeToplevel?.wayland.appId]
  Socket {
    // Create and connect a Socket to the hyprland event socket.
    // https://wiki.hyprland.org/IPC/
    path: `${Quickshell.env("XDG_RUNTIME_DIR")}/hypr/${Quickshell.env("HYPRLAND_INSTANCE_SIGNATURE")}/.socket2.sock`
    connected: true

    parser: SplitParser {
      // Match active window change events
      property var regex: new RegExp("\(activewindow>>(.+),.*|activeworkspace>>(.+),.*\)");
      // Sent for every line read from the socket
      onRead: msg => {
        const match = regex.exec(msg);
        if (match != null) {
          textUpdate.exec(currentApplication.getApplicationName);
        }
      }
    }
  }

  property var titleProcess: Process {
    id: textUpdate
    command: currentApplication.getApplicationName
    stdout: StdioCollector {
      onStreamFinished: currentApplication.text = this.text.trim() ? " " + this.text.trim().replace(/^"(.+)"$/,'$1') + " " : ""
    }
  }

  Connections {
    target: Hyprland
    function onActiveTopLayerChanged() {
      titleProcess.exec(currentApplication.getApplicationName)
    }
    function onWorkspaceChanged() {
      titleProcess.exec(currentApplication.getApplicationName)
    }
  }

}
