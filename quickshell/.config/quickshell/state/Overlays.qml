pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root

    property ShellScreen targetScreen: null

    property string activeOverlay: ""
    property string activeSide: "top"

    function toggleOverlay(id: string, side: string, screen) {
        if (activeOverlay === id && targetScreen === screen) {
            closeAll()
            return
        }

        activeOverlay = id
        activeSide = side
        targetScreen = screen
    }

    function closeAll() {
        activeOverlay = ""
    }
}