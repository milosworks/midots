import QtQuick
import qs.theme

Item {
    id: root

    anchors.verticalCenter: parent.verticalCenter

    width: clock.width
    height: clock.implicitHeight

    clip: true

    property bool hovered: false

    Behavior on width {
        NumberAnimation {
            duration: 300
            easing.type: Easing.OutExpo
        }
    }

    property var currentDate: new Date()
    property string timeFormat: root.hovered ? "h:mm ap ddd, dd/MMM/yy " : "h:mm ap"

    Text {
        anchors.verticalCenter: parent.verticalCenter

        id: clock

        text: Qt.formatDateTime(root.currentDate, root.timeFormat)

        font.family: "Inter"
        font.pixelSize: 14
        font.weight: Font.Medium
        color: Theme.textPrimary
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.currentDate = new Date()
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: root.hovered = true
        onExited: root.hovered = false
    }
}