import QtQuick
import QtQuick.Controls

Item {
    id: root
    property var    session: sessionList.currentIndex
    property string currentName: "Session"
    property int    inputHeight: 44

    implicitHeight: sessionButton.height
    implicitWidth:  sessionButton.width

    function seedName() {
        var idx = sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
        var n = sessionModel.data(sessionModel.index(idx, 0), Qt.UserRole + 1)
        if (n) {
            if (n.indexOf("/") !== -1) {
                n = n.split("/").pop().replace(".desktop", "")
                n = n.charAt(0).toUpperCase() + n.slice(1)
            }
            root.currentName = n
        }
        sessionList.currentIndex = idx
    }

    Component.onCompleted: seedName()

    Button {
        id: sessionButton
        height: inputHeight
        width: Math.max(labelText.implicitWidth + 32, 120)
        hoverEnabled: true
        padding: 0

        contentItem: Text {
            id: labelText
            text: root.currentName + "  "
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.family: config.Font
            font.pointSize: config.FontSize
            color: config.background
            renderType: Text.NativeRendering
        }

        background: Rectangle {
            id: btnBg
            radius: 6
            color: config.foreground
        }

        states: [
            State {
                name: "open"
                when: sessionPopup.visible
                PropertyChanges { target: btnBg; color: config.selected }
            },
            State {
                name: "hovered"
                when: sessionButton.hovered && !sessionPopup.visible
                PropertyChanges { target: btnBg; color: config.selected }
            }
        ]
        transitions: Transition {
            PropertyAnimation { properties: "color"; duration: 150 }
        }

        onClicked: sessionPopup.visible ? sessionPopup.close() : sessionPopup.open()
    }

    Popup {
        id: sessionPopup
        width: Math.max(sessionButton.width, 160)
        x: sessionButton.width - width
        y: -(contentHeight + padding * 2) - 8
        padding: 4

        background: Rectangle {
            radius: 8
            color: config.surface
            border.width: 1
            border.color: config.foreground
        }

        contentItem: ListView {
            id: sessionList
            implicitHeight: contentHeight
            spacing: 4
            model: sessionModel
            currentIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
            clip: true

            delegate: ItemDelegate {
                id: entry
                width: sessionPopup.width - 8
                height: inputHeight
                highlighted: sessionList.currentIndex === index

                contentItem: Text {
                    renderType: Text.NativeRendering
                    font.family: config.Font
                    font.pointSize: config.FontSize
                    font.bold: highlighted
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: highlighted ? config.selected : config.foreground
                    text: name
                }

                background: Rectangle {
                    radius: 6
                    color: entry.hovered ? config.background : config.surface
                }

                transitions: Transition {
                    PropertyAnimation { properties: "color"; duration: 150 }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        sessionList.currentIndex = index
                        root.currentName = name
                        sessionPopup.close()
                    }
                }
            }
        }

        enter: Transition {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 200; easing.type: Easing.OutQuad }
        }
        exit: Transition {
            NumberAnimation { property: "opacity"; from: 1; to: 0; duration: 150; easing.type: Easing.OutQuad }
        }
    }
}
