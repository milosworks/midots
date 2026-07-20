import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.state

WlSessionLock {
    locked: ShellState.isLocked

    WlSessionLockSurface {
        id: lockSurface

        LockScreen {
            isMainMonitor: lockSurface.screen === Quickshell.screens[0]
        }
    }
} 