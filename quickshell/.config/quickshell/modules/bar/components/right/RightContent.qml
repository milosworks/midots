import QtQuick
import Quickshell

Row {
    required property ShellScreen screen
    required property PanelWindow panel

    spacing: 15

    Clock {}

    SystemTray {
        panel: parent.panel
    }

    PowerMenu {
        screen: parent.screen
    }
}