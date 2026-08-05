import QtQuick
import Quickshell
import Quickshell.Hyprland
import qs.state

Scope {
    GlobalShortcut {
        name: "lock"
        onPressed: {if (!ShellState.isLocked) ShellState.lock()}
    }

    GlobalShortcut {
        name: "wallpaper"
        onPressed: {
            const monitorName = Hyprland.focusedMonitor?.name
            if (!monitorName) return;
            const screen = Quickshell.screens.find(x => x.name === monitorName)
            if (screen) Overlays.toggleOverlay("wallpaper", "bottom", screen)
        }
    }

    GlobalShortcut {
        name: "applauncher"
        onPressed: {
            const monitorName = Hyprland.focusedMonitor?.name
            if (!monitorName) return;
            const screen = Quickshell.screens.find(x => x.name === monitorName)
            if (screen) Overlays.toggleOverlay("applauncher", "right", screen)
        }
    }
    
    GlobalShortcut {
        name: "clipboard"
        onPressed: {
            const monitorName = Hyprland.focusedMonitor?.name
            if (!monitorName) return;
            const screen = Quickshell.screens.find(x => x.name === monitorName)
            if (screen) Overlays.toggleOverlay("clipboard", "bottom", screen)
        }
    }
}