import QtQuick
import Quickshell
import qs.components
import qs.theme
import qs.state

MaterialIcon {
    required property ShellScreen screen

    size: 20
    anchors.verticalCenter: parent.verticalCenter
    color: Theme.secondary
    text: "power_settings_new"

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: Overlays.togglePowerMenu(parent.screen)
    }             
}