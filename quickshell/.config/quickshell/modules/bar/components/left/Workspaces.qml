pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.theme

Row {
    id: row

    spacing: 8

    required property ShellScreen screen

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            required property HyprlandWorkspace modelData

            visible: modelData.monitor?.name === row.screen.name

            width: 20
            height: 20
            radius: width / 3

            color: Hyprland.focusedWorkspace?.id === modelData.id ? Theme.primary : Theme.surfaceVariant
        
            Text {
                anchors.centerIn: parent
                font.family: "Inter"

                color: Hyprland.focusedWorkspace?.id === parent.modelData.id ? Theme.textOnPrimary : Theme.textMuted
                text: parent.modelData.id
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: Hyprland.dispatch(`hl.dsp.focus({workspace=${parent.modelData.id}})`)
            }
        }
    }
}