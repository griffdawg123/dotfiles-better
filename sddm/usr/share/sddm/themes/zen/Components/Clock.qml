import QtQuick 2.15

Column {
    spacing: 6

    Text {
        id: timeText
        anchors.horizontalCenter: parent.horizontalCenter
        color: config.foreground
        font.family: config.Font
        font.pixelSize: 80
        font.weight: Font.Light
        renderType: Text.NativeRendering
    }

    Text {
        id: dateText
        anchors.horizontalCenter: parent.horizontalCenter
        color: config.foreground
        opacity: 0.55
        font.family: config.Font
        font.pixelSize: 15
        renderType: Text.NativeRendering
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            timeText.text = Qt.formatTime(new Date(), "HH:mm")
            dateText.text = Qt.formatDate(new Date(), "dddd, d MMMM yyyy")
        }
        Component.onCompleted: triggered()
    }
}
