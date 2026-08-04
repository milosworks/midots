//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma UseQApplication

import QtQuick
import Quickshell
import qs.modules.bar
import qs.modules.lock
import qs.state
import qs.components

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
 
    OverlayManager {}
}
