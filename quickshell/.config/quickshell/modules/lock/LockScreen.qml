import QtQuick
import Quickshell.Io
import Quickshell.Services.Pam
import qs.state
import qs.shapes
import qs.theme

Rectangle {
    id: root
    anchors.fill: parent
    color: "black"

    property bool isMainMonitor: true 

    Image {
        id: bg
        source: ShellState.wallpaperPath
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
    }

    SequentialAnimation {
        id: entryAnim
        running: root.isMainMonitor 

        PauseAnimation { duration: 100 }

        NumberAnimation {
            target: clock
            property: "opacity"
            from: 0
            to: 1
            duration: 300
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: container
            property: "height"
            from: 0
            to: 80
            duration: 200
            easing.type: Easing.OutExpo
        }
    }

    SequentialAnimation {
        id: exitAnim

        NumberAnimation {
            target: container
            property: "height"
            to: 0
            duration: 500
            easing.type: Easing.OutExpo
        }

        PauseAnimation { duration: 100 }

        NumberAnimation {
            target: clock
            property: "opacity"
            to: 0
            duration: 300
            easing.type: Easing.OutCubic
        }

        ScriptAction {
            script: ShellState.unlock()
        }
    }

    Text {
        id: clock
        anchors.centerIn: parent
        
        opacity: 0

        color: "white"
        font.family: "Inter"
        font.pixelSize: 84
        font.weight: Font.Bold
        text: Qt.formatTime(new Date(), "h:mm ap")
        
        Timer {
            interval: 1000
            repeat: true
            onTriggered: {
                let newTime = Qt.formatTime(new Date(), "h:mm ap")
                if (clock.text !== newTime) clock.text = newTime
            }
        }
    }

    Item {
        id: container
        
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        
        width: 400
        height: 0
        
        clip: true 
        visible: root.isMainMonitor

        property bool isCapsOn: false
        property bool isError: false

        NotchPopup {
            id: notch
            anchors.fill: parent
            side: "bottom"
        }

        Rectangle {
            id: inputRect
            
            anchors.centerIn: parent
            width: parent.width - 60
            height: 48 

            radius: 24 
            color: Theme.surfaceVariant

            opacity: pam.active ? 0.5 : 1.0
            Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
            
            Text {
                anchors.centerIn: parent
                text: pam.active ? "Verifying..." : "Password"
                font.family: "Inter"
                font.pixelSize: 20
                color: Theme.textPrimary
                opacity: 0.4
                visible: passwordInput.text === "" || pam.active
            }

            Item {
                id: safeZone
                anchors.fill: parent
                anchors.leftMargin: parent.radius 
                anchors.rightMargin: parent.radius
                clip: true
                visible: !pam.active

                Row {
                    anchors.centerIn: parent
                    spacing: 8

                    Repeater {
                        model: passwordInput.text.length
                        
                        Text {
                            required property int index
                            property var shapes: ["●", "⬟", "■", "▲", "◆", "⬢"]
                            text: shapes[index % shapes.length]
                            color: Theme.textPrimary
                            font.pixelSize: 18
                            verticalAlignment: Text.AlignVCenter

                            Component.onCompleted: popAnim.start()
                            NumberAnimation on scale {
                                id: popAnim
                                from: 0
                                to: 1
                                duration: 250
                                easing.type: Easing.OutBack
                            }
                        }
                    }
                }
            }

            TextInput {
                id: passwordInput
                anchors.fill: parent
                anchors.leftMargin: parent.radius
                anchors.rightMargin: parent.radius
                
                verticalAlignment: TextInput.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "transparent"
                selectionColor: "transparent"
                cursorVisible: false 
                readOnly: pam.active
                
                focus: root.isMainMonitor 
                
                echoMode: TextInput.Password 
                cursorDelegate: Item {}

                Keys.onPressed: (event) => {
                    container.isError = false 
                    if (event.key === Qt.Key_CapsLock) container.isCapsOn = !container.isCapsOn
                }

                onAccepted: {
                    if (text !== "" && !pam.active) pam.start()
                }
            }

            Process {
                id: syncCapsProcess
                running: root.isMainMonitor 
                command: ["sh", "-c", "cat /sys/class/leds/*::capslock/brightness | head -n 1"]
                stdout: StdioCollector {
                    onStreamFinished: container.isCapsOn = (this.text.trim() === "1")
                }
            }
        }

        Rectangle {
            anchors.fill: inputRect 
            radius: inputRect.radius
            color: "transparent"
            border.width: 2
            border.color: container.isError ? Theme.error : Theme.secondary
            opacity: (container.isCapsOn || container.isError) ? 1 : 0

            Behavior on opacity {
                NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
            }
        }
    }
 
    PamContext {
        id: pam
        onResponseRequiredChanged: {
            if (responseRequired) pam.respond(passwordInput.text)
        }
        onCompleted: (result) => {
            passwordInput.text = ""
            
            if (result === PamResult.Success) exitAnim.start()
            else container.isError = true
        }
    }
}