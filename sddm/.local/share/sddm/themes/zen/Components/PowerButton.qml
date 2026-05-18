import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property int inputHeight: 44
    implicitHeight: btn.height
    implicitWidth: btn.width

    Button {
        id: btn
        height: inputHeight
        width: inputHeight
        hoverEnabled: true

        contentItem: Text {
            text: ""
            font.family: config.Font
            font.pixelSize: 18
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: config.background
            renderType: Text.NativeRendering
        }

        background: Rectangle {
            id: bg
            radius: 6
            color: config.urgent
        }

        states: [
            State {
                name: "hovered"
                when: btn.hovered
                PropertyChanges { target: bg; opacity: 0.75 }
            }
        ]
        transitions: Transition {
            PropertyAnimation { properties: "opacity"; duration: 150 }
        }

        ToolTip.visible: hovered
        ToolTip.delay: 600
        ToolTip.text: "Shut Down"

        onClicked: sddm.powerOff()
    }
}
