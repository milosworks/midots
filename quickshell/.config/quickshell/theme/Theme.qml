pragma Singleton
import QtQuick
import Quickshell
import qs.theme

Singleton {
    // --- Colors ---
    property color bgBase: Colors.bgBase
    property color surface: Colors.surface
    property color surfaceVariant: Colors.surfaceVariant
    property color primaryContainer: Colors.primaryContainer
    property color textPrimary: Colors.textPrimary
    property color textMuted: Colors.textMuted
    property color primary: Colors.primary
    property color textOnPrimary: Colors.textOnPrimary
    property color textOnPrimaryContainer: Colors.textOnPrimaryContainer
    property color secondary: Colors.secondary
    property color tertiary: Colors.tertiary
    property color error: Colors.error

    // -- Measurements --
    property int notchHeight: 40
    property int notchTopRadius: 25
    property int notchBottomRadius: 15
    property int notchSideRadius: 25
    property int notchPopupCornerRadius: 18

    // -- Notch Background Settings --
    property real notchBgOpacity: 0.7

    property int leftNotchMinWidth: 90
    property int leftNotchMaxWidth: 300

    property int centerNotchMinWidth: 180
    property int centerNotchMaxWidth: 300

    property int rightNotchMinWidth: 90
    property int rightNotchMaxWidth: 500

    property int appNameMaxWidth: 100

    // -- Animations --
    property int animDurationFast: 300
    property int animDurationNormal: 500
}