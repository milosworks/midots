//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma UseQApplication

import QtQuick
import Quickshell
import qs.modules.bar
import qs.modules.overlays
import qs.modules.lock
import qs.state

Scope {
    IpcEndpoints {}

    SessionLock {}
    
    Variants {
        model: Quickshell.screens

        Scope {
            id: root

            required property ShellScreen modelData
            
            Bar { screen: root.modelData }
        }
    }
 
    PowerMenu {}
}
