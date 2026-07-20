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

    property string backgroundPath: "/home/milo/wallhaven-4d7e5g.png"

    // Process {
    //     id: awwwQuery
    //     // running: true

    //     command: ["sh", "-c", "awww query | head -1 | awk -F 'image: ' '{print $2}'"]
    
    //     stdout: StdioCollector {
    //         onStreamFinished: root.backgroundPath = "file://" + this.text.trim()
    //     }
    // } 
}