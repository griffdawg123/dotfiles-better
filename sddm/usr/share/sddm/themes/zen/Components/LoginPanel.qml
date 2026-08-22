import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15

Item {
    id: panel

    property string user: userField.text
    property string password: passwordField.text
    property int    session: sessionPanel.session
    property real   inputWidth: 360
    property real   inputHeight: 44
    property string loginState: ""

    // Power buttons — bottom left
    Row {
        id: powerRow
        spacing: 8
        anchors {
            left: panel.left
            bottom: panel.bottom
        }
        z: 5
        PowerButton  { inputHeight: panel.inputHeight }
        RebootButton { inputHeight: panel.inputHeight }
        SleepButton  { inputHeight: panel.inputHeight }
    }

    // Session selector — bottom right
    SessionPanel {
        id: sessionPanel
        anchors {
            right: panel.right
            bottom: panel.bottom
        }
        inputHeight: panel.inputHeight
        z: 5
    }

    // Login card
    Rectangle {
        id: card
        anchors {
            horizontalCenter: panel.horizontalCenter
            verticalCenter: panel.verticalCenter
            verticalCenterOffset: 60
        }
        width: panel.inputWidth + 64
        height: panel.inputHeight * 3 + 48 + 16
        radius: 12
        color: config.surface
        border.width: 1
        border.color: config.foreground

        Column {
            spacing: 8
            width: panel.inputWidth
            anchors.centerIn: parent

            UserField {
                id: userField
                height: panel.inputHeight
                width: parent.width
            }

            PasswordField {
                id: passwordField
                height: panel.inputHeight
                width: parent.width
                loginState: panel.loginState
                onAccepted: loginButton.clicked()
                onTextChanged: panel.loginState = ""
            }

            Button {
                id: loginButton
                height: panel.inputHeight
                width: parent.width
                enabled: panel.password !== "" && panel.loginState !== "checking"
                hoverEnabled: true

                contentItem: Text {
                    renderType: Text.NativeRendering
                    font.family: config.Font
                    font.pointSize: config.FontSize
                    font.bold: true
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: config.background
                    text: panel.loginState === "checking" ? "Checking…" : "Login"
                }

                background: Rectangle {
                    id: btnBg
                    radius: 6
                    color: loginButton.enabled ? config.selected : config.surface
                }

                states: [
                    State {
                        name: "hovered"
                        when: loginButton.hovered && loginButton.enabled && !loginButton.down
                        PropertyChanges { target: btnBg; color: config.foreground }
                    },
                    State {
                        name: "pressed"
                        when: loginButton.down
                        PropertyChanges { target: btnBg; color: config.foreground }
                    }
                ]
                transitions: Transition {
                    PropertyAnimation { properties: "color"; duration: 150 }
                }

                onClicked: {
                    panel.loginState = "checking"
                    sddm.login(panel.user, panel.password, panel.session)
                }
            }
        }
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            panel.loginState = "failed"
            passwordField.text = ""
            passwordField.focus = true
        }
    }
}
