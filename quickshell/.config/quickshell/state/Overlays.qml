pragma Singleton
import QtQuick
import Quickshell

Singleton {
    property ShellScreen targetScreen: null

    property bool powerMenuActive: false

    function togglePowerMenu(screen) {
        if (!screen || (powerMenuActive && targetScreen === screen)) {
            powerMenuActive = false
            targetScreen = null
        } else {
            powerMenuActive = true
            targetScreen = screen
        }
    }
}