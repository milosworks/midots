import QtQuick
import Quickshell
import Quickshell.Io
import qs.state

Scope {
    IpcHandler {
        target: "mish:lock"

        function lock(): void {if (!ShellState.isLocked) ShellState.lock()}
    }

    IpcHandler {
        target: "mish:wallpaper"

        function open(monitorName: string): void {
            const screen = Quickshell.screens.find(x => x.name === monitorName)
            if (screen) Overlays.toggleOverlay("wallpaper", "bottom", screen)
        }
    }
    
    IpcHandler {
        target: "mish:clipboard"

        function open(monitorName: string): void {
            const screen = Quickshell.screens.find(x => x.name === monitorName)
            if (screen) Overlays.toggleOverlay("clipboard", "bottom", screen)
        }
    }
    
    IpcHandler {
        target: "mish:apprunner"

        function open(monitorName: string): void {
            const screen = Quickshell.screens.find(x => x.name === monitorName)
            if (screen) Overlays.toggleOverlay("apprunner", "right", screen)
        }
    }
}