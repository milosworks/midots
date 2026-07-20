import QtQuick
import Quickshell.Wayland
import qs.theme

Item {
    anchors.verticalCenter: parent.verticalCenter

    width: text.width
    height: text.implicitHeight

    clip: true

    Behavior on width {
        NumberAnimation {
            duration: 250
            easing.type: Easing.OutExpo
        }
    }

    Text { 
        id: text

        anchors.left: parent.left

        font.family: "Inter"
        font.pixelSize: 14
        font.weight: Font.Medium
        color: Theme.textPrimary

        elide: Text.ElideRight

        width: Math.min(implicitWidth, Theme.appNameMaxWidth)

        text: ToplevelManager.activeToplevel !== null ? formatAppName(ToplevelManager.activeToplevel.appId, ToplevelManager.activeToplevel.title) : "Desktop"

        function formatAppName(appId, title) {
            if (!appId) return "Desktop"
            if (appId.startsWith("steam_app_")) return title ? title : "Steam Game"
            
            if (appId.includes(".")) {
                const parts = appId.split(".")
                return parts[parts.length - 1][0].toUpperCase() + parts[parts.length - 1].slice(1)
            }

            return appId[0].toUpperCase() + appId.slice(1)
        }
    }
}