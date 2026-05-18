import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    id: userField
    text: userModel.lastUser
    selectByMouse: true
    placeholderText: "Username"
    renderType: Text.NativeRendering
    font.family: config.Font
    font.pointSize: config.FontSize
    color: config.foreground
    horizontalAlignment: TextInput.AlignHCenter

    background: Rectangle {
        id: fieldBg
        radius: 6
        color: config.surface
        border.width: 1
        border.color: userField.activeFocus ? config.selected : "transparent"
    }

    transitions: Transition {
        PropertyAnimation { properties: "border.color"; duration: 150 }
    }
}
