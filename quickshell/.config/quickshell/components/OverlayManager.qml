pragma ComponentBehavior: Bound
//qmllint disable uncreatable-type

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.state
import qs.shapes
import qs.modules.overlays

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: window
            required property ShellScreen modelData
            screen: modelData

            anchors { top: true; bottom: true; left: true; right: true }
            color: "transparent"
            WlrLayershell.namespace: "shell"
            exclusionMode: ExclusionMode.Ignore
            
            property bool isTargetScreen: Overlays.targetScreen === modelData
            property bool hasActiveOverlay: Overlays.activeOverlay !== ""
            property bool isActive: isTargetScreen && hasActiveOverlay

            property bool wantsDimmer: {
                if (Overlays.activeOverlay === "powermenu") return powerMenu.wantsDimmer || false
                if (Overlays.activeOverlay === "wallpaper") return wallpaperSelector.wantsDimmer || false
                if (Overlays.activeOverlay === "applauncher") return appLauncher.wantsDimmer || false
                if (Overlays.activeOverlay === "clipboard") return clipboardViewer.wantsDimmer || false
                return false
            }

            WlrLayershell.keyboardFocus: isActive ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
            
            property bool anyWrapperVisible: topWrapper.visible || bottomWrapper.visible || leftWrapper.visible || rightWrapper.visible
            
            // only visible if there's an active wrapper or the dimmer hasn't fully faded
            // once visible is false, the window stops intercepting mouse inputs entirely
            visible: window.isActive || dimmerBg.opacity > 0.01 || anyWrapperVisible

            MouseArea {
                anchors.fill: parent
                enabled: window.isActive || (window.hasActiveOverlay && window.wantsDimmer)
                onClicked: Overlays.closeAll()
            }

            Rectangle {
                id: dimmerBg
                anchors.fill: parent
                color: "#80000000"
                opacity: (window.hasActiveOverlay && window.wantsDimmer) ? 1.0 : 0.0
                visible: opacity > 0.01
                Behavior on opacity { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
            }
            
            Item {
                id: focusContainer
                anchors.fill: parent
                focus: window.isActive
                Keys.onEscapePressed: Overlays.closeAll()

                component SideWrapper: Item {
                    id: wrapper
                    property string side
                    
                    property bool isActive: window.isTargetScreen && Overlays.activeSide === side && Overlays.activeOverlay !== ""
                    
                    property bool isVertical: side === "top" || side === "bottom"
                    property bool isHorizontal: side === "left" || side === "right"

                    anchors.horizontalCenter: isVertical ? parent.horizontalCenter : undefined
                    anchors.verticalCenter: isHorizontal ? parent.verticalCenter : undefined
                    anchors.bottom: side === "bottom" ? parent.bottom : undefined
                    anchors.top: side === "top" ? parent.top : undefined
                    anchors.left: side === "left" ? parent.left : undefined
                    anchors.right: side === "right" ? parent.right : undefined

                    property real contentWidth: 0
                    property real contentHeight: 0

                    property real targetWidth: isActive ? contentWidth : _lastWidth
                    property real targetHeight: isActive ? contentHeight : _lastHeight

                    property real _lastWidth: 0
                    property real _lastHeight: 0
                    onTargetWidthChanged: if (targetWidth > 0) _lastWidth = targetWidth
                    onTargetHeightChanged: if (targetHeight > 0) _lastHeight = targetHeight

                    width: (!isActive && isHorizontal) ? 0 : (targetWidth > 0 ? targetWidth : _lastWidth)
                    height: (!isActive && isVertical) ? 0 : (targetHeight > 0 ? targetHeight : _lastHeight)

                    Behavior on width { NumberAnimation { duration: 400; easing.type: Easing.OutExpo } }
                    Behavior on height { NumberAnimation { duration: 400; easing.type: Easing.OutExpo } }

                    visible: width > 0 && height > 0

                    NotchPopup {
                        anchors.fill: parent
                        side: wrapper.side
                        clip: true
                    }
                    
                    MouseArea {
                        anchors.fill: parent
                    }
                }

                SideWrapper { id: topWrapper; side: "top" }
                SideWrapper { id: leftWrapper; side: "left" }

                SideWrapper {
                    id: bottomWrapper
                    side: "bottom"
                    
                    contentWidth: {
                        if (Overlays.activeOverlay === "wallpaper") return wallpaperSelector.implicitWidth
                        if (Overlays.activeOverlay === "clipboard") return clipboardViewer.implicitWidth
                        return 0
                    }
                    contentHeight: {
                        if (Overlays.activeOverlay === "wallpaper") return wallpaperSelector.implicitHeight
                        if (Overlays.activeOverlay === "clipboard") return clipboardViewer.implicitHeight
                        return 0
                    }
                    
                    WallpaperSelector {
                        id: wallpaperSelector
                        anchors.fill: parent
                        visible: bottomWrapper.isActive && Overlays.activeOverlay === "wallpaper"
                        onVisibleChanged: if (visible) forceActiveFocus()
                    }

                    ClipboardViewer {
                        id: clipboardViewer
                        anchors.fill: parent
                        visible: bottomWrapper.isActive && Overlays.activeOverlay === "clipboard"
                        onVisibleChanged: if (visible) forceActiveFocus()
                    }
                }

                SideWrapper {
                    id: rightWrapper
                    side: "right"
                    
                    contentWidth: {
                        if (Overlays.activeOverlay === "powermenu") return powerMenu.implicitWidth
                        if (Overlays.activeOverlay === "applauncher") return appLauncher.implicitWidth
                        return 0
                    }
                    contentHeight: {
                        if (Overlays.activeOverlay === "powermenu") return powerMenu.implicitHeight
                        if (Overlays.activeOverlay === "applauncher") return appLauncher.implicitHeight
                        return 0
                    }

                    PowerMenu {
                        id: powerMenu
                        anchors.fill: parent
                        visible: rightWrapper.isActive && Overlays.activeOverlay === "powermenu"
                        onVisibleChanged: if (visible) forceActiveFocus()
                    }
                    
                    AppLauncher {
                        id: appLauncher
                        anchors.fill: parent
                        visible: rightWrapper.isActive && Overlays.activeOverlay === "applauncher"
                        onVisibleChanged: if (visible) forceActiveFocus()
                    }
                }
            }
        }
    }
}
