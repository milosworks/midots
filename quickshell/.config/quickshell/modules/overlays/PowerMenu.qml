pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.components
import qs.state
import qs.theme

Item {
    id: root

    property int buttonSize: 150
    property bool wantsDimmer: true
    implicitWidth: column.implicitWidth + 30
    implicitHeight: column.implicitHeight + 60

    Column {
        id: column
        anchors.centerIn: parent
        spacing: 10

        Repeater {
            model: [
                { name: "Suspend", cmd: "systemctl suspend", color: Theme.secondary, icon: "bedtime" },
                { name: "Logout", cmd: "hyprctl dispatch 'hl.dsp.exit()'", color: Theme.secondary, icon: "logout" },
                { name: "Reboot", cmd: "systemctl reboot", color: Theme.secondary, icon: "restart_alt" },
                { name: "Turn Off", cmd: "systemctl poweroff", color: Theme.error, icon: "power_settings_new" }
            ]

            Rectangle {
                id: button
                required property var modelData

                width: root.buttonSize
                height: root.buttonSize
                radius: 12
                color: Theme.surfaceVariant

                Column {
                    anchors.centerIn: parent
                    spacing: 15

                    MaterialIcon {
                        size: 96
                        weight: 700
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: button.modelData.icon
                        color: button.modelData.color
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor

                    onEntered: parent.opacity = 0.8
                    onExited: parent.opacity = 1

                    onClicked: {
                        Overlays.toggleOverlay("powermenu", "right", Overlays.targetScreen)
                        Quickshell.execDetached(["sh", "-c", button.modelData.cmd])
                    }
                }
            }
        }
    }
}