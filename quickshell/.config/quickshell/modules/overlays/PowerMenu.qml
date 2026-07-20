//qmllint disable uncreatable-type
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.state
import qs.shapes
import qs.theme

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property ShellScreen modelData
            screen: modelData

            anchors { top: true; bottom: true; right: true; left: true }
            color: "transparent"

            WlrLayershell.namespace: "shell"
            exclusionMode: ExclusionMode.Ignore

            visible: dimmerBg.opacity > 0

            Rectangle {
                id: dimmerBg
                anchors.fill: parent
                color: "#80000000"
                opacity: Overlays.powerMenuActive ? 1.0 : 0.0
                
                Behavior on opacity { 
                    NumberAnimation { 
                        duration: 400
                        easing.type: Easing.OutCubic
                    } 
                }
            
                MouseArea {
                    anchors.fill: parent
                    onClicked: Overlays.togglePowerMenu()
                }
            }
        }
    }

    PanelWindow {
        id: root

        screen: Overlays.targetScreen

        visible: container.opacity > 0

        WlrLayershell.namespace: "shell"

        WlrLayershell.keyboardFocus: (Overlays.powerMenuActive && Overlays.targetScreen !== null) 
            ? WlrKeyboardFocus.Exclusive 
            : WlrKeyboardFocus.None

        color: "transparent"

        anchors { top: true; bottom: true; right: true; left: true }

        Item {
            id: container
            anchors.fill: parent

            opacity: (Overlays.powerMenuActive && Overlays.targetScreen !== null) ? 1.0 : 0.0
        
            Behavior on opacity { 
                NumberAnimation { 
                    duration: 400 
                    easing.type: Easing.OutCubic
                } 
            }

            focus: Overlays.powerMenuActive
            Keys.onEscapePressed: Overlays.togglePowerMenu()

            MouseArea {
                anchors.fill: parent
                onClicked: Overlays.togglePowerMenu()
            }

            Item {
                id: content

                property int buttonSize: 150
                property bool isActive: Overlays.powerMenuActive && Overlays.targetScreen !== null

                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                
                clip: true 

                property int targetWidth: column.implicitWidth + 30
                property int targetHeight: column.implicitHeight + 60

                width: isActive ? targetWidth : 0
                height: isActive ? targetHeight : 100

                Behavior on width { 
                    NumberAnimation { duration: 500; easing.type: Easing.OutExpo } 
                }
                Behavior on height { 
                    NumberAnimation { duration: 500; easing.type: Easing.OutExpo } 
                }

                NotchPopup {
                    id: background
                    anchors.fill: parent
                    side: "right"
                }

                Column {
                    id: column

                    anchors.centerIn: parent
                    spacing: 10

                    opacity: content.isActive ? 1.0 : 0.0
                    Behavior on opacity {
                        NumberAnimation { duration: 400; easing.type: Easing.InOutQuad }
                    }

                    Repeater {
                        model: [
                            { 
                                name: "Suspend",
                                cmd: "systemctl suspend", 
                                color: Theme.secondary,
                                icon: "bedtime"
                            },
                            { 
                                name: "Logout",
                                cmd: "hyprctl dispatch 'hl.dsp.exit()'",
                                color: Theme.secondary, 
                                icon: "logout"
                            },
                            { 
                                name: "Reboot",
                                cmd: "systemctl reboot", 
                                color: Theme.secondary,
                                icon: "restart_alt"
                            },
                            { 
                                name: "Turn Off",
                                cmd: "systemctl poweroff", 
                                color: Theme.error,
                                icon: "power_settings_new"
                            }
                        ]

                        Rectangle {
                            id: button
                            required property var modelData

                            width: content.buttonSize
                            height: content.buttonSize
                            radius: 12
                            color: Theme.surfaceVariant

                            Column {
                                anchors.centerIn: parent
                                spacing: 15

                                MaterialIcon {
                                    size: 96
                                    weight: 700
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: button.modelData.icon
                                    color: button.modelData.color
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor

                                onEntered: parent.opacity = 0.8
                                onExited: parent.opacity = 1

                                onClicked: {
                                    Overlays.togglePowerMenu(root.screen)
                                    Quickshell.execDetached(["sh", "-c", button.modelData.cmd])
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}