pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.SystemTray

Row {
    id: root
    anchors.verticalCenter: parent.verticalCenter

    required property PanelWindow panel

    spacing: 5

    Repeater {
        model: SystemTray.items

        Rectangle {
            id: container

            required property var modelData

            width: 20
            height: 20

            color: "transparent"

            Image {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height

                source: container.modelData.icon
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                anchors.fill: parent

                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor

                onClicked: (mouse) => {
                    if (mouse.button === Qt.LeftButton) {
                        container.modelData.activate()
                    } else if(mouse.button === Qt.RightButton) {
                        let pos = mapToItem(null, mouse.x, mouse.y)

                        container.modelData.display(root.panel, pos.x, pos.y)
                    }
                }
            }
        }
    }
}