import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property var    session: sessionList.currentIndex
    property string currentName: "Session"
    property int    inputHeight: 44

    implicitHeight: sessionButton.height
    implicitWidth:  sessionButton.width

    // Instantiator gives proper model role bindings (like a delegate),
    // avoiding the role-number guessing needed with sessionModel.data()
    Instantiator {
        model: sessionModel
        delegate: QtObject {
            required property string name
            required property int index
            Component.onCompleted: {
                if (index === sessionModel.lastIndex) {
                    root.currentName = name
                }
                sessionList.currentIndex = sessionModel.lastIndex >= 0
                    ? sessionModel.lastIndex : 0
            }
        }
    }

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
