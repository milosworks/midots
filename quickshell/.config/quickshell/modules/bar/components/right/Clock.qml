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

    Text {
        anchors.verticalCenter: parent.verticalCenter

        id: clock

        text: Qt.formatDateTime(new Date(), "h:mm ap")

        font.family: "Inter"
        font.pixelSize: 14
        font.weight: Font.Medium
        color: Theme.textPrimary
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.updateClock()
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onEntered: {
            root.hovered = true
            root.updateClock()
        }
        onExited: {
            root.hovered = false
            root.updateClock()
        }
    }

    function updateClock() {
        clock.text = root.hovered ? 
            Qt.formatDateTime(new Date(), "h:mm ap ddd, dd/MMM/yy ") : 
            clock.text = Qt.formatDateTime(new Date(), "h:mm ap")
    }
}