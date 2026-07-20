import QtQuick
import Quickshell

Row {
    id: root

    required property ShellScreen screen

    spacing: 15

    AppName {}

    Workspaces {
        screen: root.screen
    }
}