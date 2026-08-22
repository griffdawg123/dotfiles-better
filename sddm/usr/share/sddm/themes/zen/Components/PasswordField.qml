import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    id: passwordField
    property string loginState: ""

    focus: true
    selectByMouse: true
    placeholderText: loginState === "failed" ? "Wrong password" : "Password"
    placeholderTextColor: loginState === "failed" ? config.urgent : "#8087afaf"
    echoMode: TextInput.Password
    passwordCharacter: "•"
    selectionColor: config.surface
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
        border.color: {
            if (loginState === "failed")   return config.urgent
            if (loginState === "checking") return config.active
            return passwordField.activeFocus ? config.selected : "transparent"
        }

        Behavior on border.color {
            ColorAnimation { duration: 200 }
        }

        // Pulse overlay while SDDM is authenticating
        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.width: 2
            border.color: config.active
            opacity: 0
            visible: loginState === "checking"

            SequentialAnimation on opacity {
                running: loginState === "checking"
                loops: Animation.Infinite
                NumberAnimation { to: 0.6; duration: 500; easing.type: Easing.InOutSine }
                NumberAnimation { to: 0;   duration: 500; easing.type: Easing.InOutSine }
            }
        }
    }
}
