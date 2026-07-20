import QtQuick
import Quickshell
import Quickshell.Io
import qs.state

Scope {
    IpcHandler {
        target: "mish:lock"

        function lock(): void {if (!ShellState.isLocked) ShellState.lock()}
    }
}