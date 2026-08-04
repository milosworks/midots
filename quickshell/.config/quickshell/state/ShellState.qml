pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    readonly property bool launchedLocked: Quickshell.env("QS_LAUNCH_LOCKED") === "1"
    property bool isLocked: launchedLocked
    property bool isInitialLock: launchedLocked

    function lock() {
        isLocked = true
        isInitialLock = false
    }

    function unlock() {
        isLocked = false
        isInitialLock = false
    }

    FileView {
        id: wallpaperReader
        path: Quickshell.env("HOME") + "/.local/state/mish/wallpaper.txt"
        watchChanges: true
        printErrors: false
        onFileChanged: reload()
    }

    property string wallpaperPath: wallpaperReader.text().trim()
}