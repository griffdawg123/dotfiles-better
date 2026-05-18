import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import "Components"

Item {
    id: root
    height: Screen.height
    width: Screen.width

    Rectangle {
        anchors.fill: parent
        color: config.background
    }

    Item {
        anchors {
            fill: parent
            margins: 32
        }

        Clock {
            id: clock
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: parent.top
                topMargin: parent.height * 0.18
            }
        }

        LoginPanel {
            id: loginPanel
            anchors.fill: parent
        }
    }
}
