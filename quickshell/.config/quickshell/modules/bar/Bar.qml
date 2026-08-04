//qmllint disable uncreatable-type

import QtQuick
import Quickshell
import qs.modules.bar.components.right
import qs.modules.bar.components.left
import qs.theme
import qs.shapes
import qs.state 

PanelWindow {
    id: root

    anchors {
        left: true
        right: true
        top: true
    }

    implicitHeight: Theme.notchHeight + Theme.notchSideRadius
    exclusiveZone: Theme.notchHeight

    color: "transparent"

    readonly property real targetLeftWidth: Math.max(
        Theme.leftNotchMinWidth, 
        Math.min(
            Theme.leftNotchMaxWidth,
            leftContent.implicitWidth + Theme.notchBottomRadius + Theme.notchSideRadius
        )
    )

    readonly property real targetRightWidth: Math.max(
        Theme.rightNotchMinWidth,
        Math.min(
            Theme.rightNotchMaxWidth,
            rightContent.implicitWidth + Theme.notchBottomRadius + Theme.notchSideRadius
        )
    )


    readonly property int targetCenterWidth: 200 

    property bool isRevealed: !ShellState.isLocked
    
    property real sideProgress: isRevealed ? 1.0 : 0.0
    property real centerProgress: isRevealed ? 1.0 : 0.0

    onIsRevealedChanged: {
        if (isRevealed) {
            hideAnim.stop()
            sideProgress = 0.0
            centerProgress = 0.0
            revealAnim.start()
        } else {
            revealAnim.stop()
            hideAnim.start()
        }
    }



    SequentialAnimation {
        id: revealAnim
        
        PauseAnimation { duration: 200 }
        
        NumberAnimation { target: root; property: "sideProgress"; to: 1.0; duration: Theme.animDurationNormal; easing.type: Easing.OutExpo }
        
        PauseAnimation { duration: 100 }
        
        // NumberAnimation { target: root; property: "centerProgress"; to: 1.0; duration: Theme.animDurationNormal; easing.type: Easing.OutExpo }
    }

    SequentialAnimation {
        id: hideAnim
        ParallelAnimation {
            NumberAnimation { target: root; property: "sideProgress"; to: 0.0; duration: Theme.animDurationNormal; easing.type: Easing.OutExpo }
            // NumberAnimation { target: root; property: "centerProgress"; to: 0.0; duration: Theme.animDurationNormal; easing.type: Easing.OutExpo }
        }
    }

    NotchBar {
        id: notches
        anchors.fill: parent
        opacity: 0.8

        leftWidth: root.targetLeftWidth * root.sideProgress
        // centerWidth: root.targetCenterWidth * root.centerProgress
        centerWidth: 0
        rightWidth: root.targetRightWidth * root.sideProgress
        
        leftHeight: Theme.notchHeight * root.sideProgress
        // centerHeight: Theme.notchHeight * root.centerProgress
        centerHeight: 0
        rightHeight: Theme.notchHeight * root.sideProgress
    }

    Item {
        id: leftWrapper
        anchors.left: parent.left
        anchors.top: parent.top
        
        width: root.targetLeftWidth * root.sideProgress
        height: Theme.notchHeight * root.sideProgress
        clip: true

        Item {
            anchors.left: parent.left
            anchors.top: parent.top
            width: root.targetLeftWidth
            height: Theme.notchHeight

            LeftContent {
                id: leftContent
                anchors.left: parent.left
                anchors.leftMargin: Theme.notchSideRadius
                anchors.verticalCenter: parent.verticalCenter
                screen: root.screen

                
            }
        }
    }

    // Item {
    //     id: centerWrapper
    //     anchors.horizontalCenter: parent.horizontalCenter
    //     anchors.top: parent.top
        
    //     width: root.targetCenterWidth * root.centerProgress
    //     height: Theme.notchHeight * root.centerProgress
    //     clip: true

    //     Item {
    //         anchors.horizontalCenter: parent.horizontalCenter
    //         anchors.top: parent.top
    //         width: root.targetCenterWidth
    //         height: Theme.notchHeight

    //         // CenterContent { anchors.centerIn: parent }
    //     }
    // }

    Item {
        id: rightWrapper
        anchors.right: parent.right
        anchors.top: parent.top
        
        width: root.targetRightWidth * root.sideProgress
        height: Theme.notchHeight * root.sideProgress
        clip: true

        Item {
            anchors.right: parent.right
            anchors.top: parent.top
            width: root.targetRightWidth
            height: Theme.notchHeight

            RightContent {
                id: rightContent
                anchors.right: parent.right
                anchors.rightMargin: Theme.notchSideRadius
                anchors.verticalCenter: parent.verticalCenter
                screen: root.screen
                panel: root
            }
        }
    }
}