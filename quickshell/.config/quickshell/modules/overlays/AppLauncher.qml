pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.state
import qs.components
import qs.theme
import qs.shapes

FocusScope {
    id: root

    implicitWidth: 500
    implicitHeight: 800

    property string searchText: ""
    property var allApps: DesktopEntries.applications.values
    property var filteredApps: allApps

    property bool isGrid: true

    function isMatch(app) {
        if (!searchText) return true
        let nameMatches = app.name && app.name.toLowerCase().includes(searchText)
        let commentMatches = app.comment && app.comment.toLowerCase().includes(searchText)
        return nameMatches || commentMatches
    }

    function updateSearch(text) {
        searchText = text.toLowerCase()
        let filtered = []
        for (let i = 0; i < allApps.length; i++) {
            if (isMatch(allApps[i])) {
                filtered.push(allApps[i])
            }
        }
        filteredApps = filtered
        if (isGrid) {
            gridView.currentIndex = 0
        } else {
            listView.currentIndex = 0
        }
    }

    function moveUp() {
        if (isGrid) {
            let cols = Math.floor(gridView.width / gridView.cellWidth)
            let nextIndex = gridView.currentIndex - cols
            if (nextIndex >= 0) gridView.currentIndex = nextIndex
        } else {
            if (listView.currentIndex > 0) listView.currentIndex--
        }
    }

    function moveDown() {
        if (isGrid) {
            let cols = Math.floor(gridView.width / gridView.cellWidth)
            let nextIndex = gridView.currentIndex + cols
            if (nextIndex < filteredApps.length) gridView.currentIndex = nextIndex
        } else {
            if (listView.currentIndex < filteredApps.length - 1) listView.currentIndex++
        }
    }

    function moveLeft() {
        if (isGrid && gridView.currentIndex > 0) gridView.currentIndex--
    }

    function moveRight() {
        if (isGrid && gridView.currentIndex < filteredApps.length - 1) gridView.currentIndex++
    }

    function launchCurrent() {
        let view = isGrid ? gridView : listView
        if (view.currentIndex >= 0 && view.currentIndex < filteredApps.length) {
            let app = filteredApps[view.currentIndex]
            app.execute()
            Overlays.toggleOverlay("applauncher", "right", Overlays.targetScreen)
            searchText = ""
            searchInput.text = ""
        }
    }

    NotchPopup {
        anchors.fill: parent
        color: Theme.surface
        side: "right"
        clip: true

        Column {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 20

            Rectangle {
                width: parent.width
                height: 60
                color: Theme.surfaceVariant
                radius: 12

                Row {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    MaterialIcon {
                        text: "search"
                        size: 24
                        color: Theme.textMuted
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    TextInput {
                        id: searchInput
                        width: parent.width - 40
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: 18
                        color: Theme.textPrimary
                        focus: true
                        clip: true
                        
                        onTextChanged: root.updateSearch(text)
                        
                        Keys.onUpPressed: root.moveUp()
                        Keys.onDownPressed: root.moveDown()
                        Keys.onLeftPressed: root.moveLeft()
                        Keys.onRightPressed: root.moveRight()
                        Keys.onReturnPressed: root.launchCurrent()
                        Keys.onEnterPressed: root.launchCurrent()
                        Keys.onEscapePressed: {
                            Overlays.toggleOverlay("applauncher", "right", Overlays.targetScreen)
                            root.searchText = ""
                            searchInput.text = ""
                        }
                        Keys.onTabPressed: (event) => {
                            root.isGrid = !root.isGrid
                            event.accepted = true
                        }
                    }
                }
            }

            Row {
                width: parent.width
                spacing: 15

                Row {
                    spacing: 8
                    anchors.verticalCenter: parent.verticalCenter
                    MaterialIcon {
                        text: "apps"
                        size: 16
                        color: Theme.textMuted
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: root.filteredApps.length + " Items"
                        color: Theme.textMuted
                        font.pointSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                Item { width: parent.width - 200 } 

                Row {
                    spacing: 10
                    anchors.verticalCenter: parent.verticalCenter
                    
                    Rectangle {
                        width: 32; height: 32; radius: 8
                        color: !root.isGrid ? Theme.primary : "transparent"
                        MaterialIcon {
                            text: "view_list"
                            size: 20
                            color: !root.isGrid ? Theme.textOnPrimary : Theme.textMuted
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.isGrid = false
                        }
                    }

                    Rectangle {
                        width: 32; height: 32; radius: 8
                        color: root.isGrid ? Theme.primary : "transparent"
                        MaterialIcon {
                            text: "grid_view"
                            size: 20
                            color: root.isGrid ? Theme.textOnPrimary : Theme.textMuted
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.isGrid = true
                        }
                    }
                }
            }

            Item {
                width: parent.width
                height: parent.height - 80 - parent.spacing * 2 - 32
                clip: true

                ListView {
                    id: listView
                    anchors.fill: parent
                    visible: !root.isGrid
                    model: root.filteredApps
                    
                    preferredHighlightBegin: 40
                    preferredHighlightEnd: height - 40
                    highlightRangeMode: ListView.ApplyRange
                    highlightMoveDuration: 150
                    
                    delegate: Item {
                        id: delegateWrapper
                        width: listView.width
                        height: 78
                        
                        required property var modelData
                        required property int index
                        
                        Rectangle {
                            id: delegateRect
                            width: parent.width
                            height: 70
                            radius: 10
                            color: delegateWrapper.ListView.isCurrentItem ? Theme.primary : "transparent"
                            
                            Behavior on color { ColorAnimation { duration: 150 } }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    listView.currentIndex = delegateWrapper.index
                                    root.launchCurrent()
                                }
                            }

                            Row {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 18

                                Item {
                                    width: 32
                                    height: 32
                                    anchors.verticalCenter: parent.verticalCenter
                                    
                                    Image {
                                        id: appIcon
                                        anchors.fill: parent
                                        source: {
                                            if (!delegateWrapper.modelData) return ""
                                            let path = delegateWrapper.modelData.icon ? Quickshell.iconPath(delegateWrapper.modelData.icon) : ""
                                            if (path && path.startsWith("/")) return "file://" + path
                                            return path
                                        }
                                        sourceSize: Qt.size(32, 32)
                                        visible: status === Image.Ready
                                    }

                                    MaterialIcon {
                                        text: "apps"
                                        size: 32
                                        color: delegateWrapper.ListView.isCurrentItem ? Theme.textOnPrimary : Theme.textMuted
                                        anchors.centerIn: parent
                                        visible: !appIcon.visible
                                    }
                                }
                                
                                Column {
                                    anchors.verticalCenter: parent.verticalCenter
                                    Text {
                                        text: delegateWrapper.modelData ? (delegateWrapper.modelData.name || "Unknown Application") : ""
                                        color: delegateWrapper.ListView.isCurrentItem ? Theme.textOnPrimary : Theme.textPrimary
                                        font.pointSize: 14
                                        font.bold: true
                                    }
                                    Text {
                                        text: delegateWrapper.modelData ? (delegateWrapper.modelData.comment || "") : ""
                                        color: delegateWrapper.ListView.isCurrentItem ? Qt.rgba(Theme.textOnPrimary.r, Theme.textOnPrimary.g, Theme.textOnPrimary.b, 0.7) : Theme.textMuted
                                        font.pointSize: 10
                                        elide: Text.ElideRight
                                        width: listView.width - 80
                                        visible: text !== ""
                                    }
                                }
                            }
                        }
                    }
                }

                GridView {
                    id: gridView
                    anchors.fill: parent
                    visible: root.isGrid
                    model: root.filteredApps
                    
                    cellWidth: width / 3
                    cellHeight: 115
                    
                    preferredHighlightBegin: 40
                    preferredHighlightEnd: height - 40
                    highlightRangeMode: GridView.ApplyRange
                    highlightMoveDuration: 150
                    
                    delegate: Item {
                        id: gridDelegateWrapper
                        width: gridView.cellWidth
                        height: gridView.cellHeight
                        
                        required property var modelData
                        required property int index
                        
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 6
                            radius: 12
                            color: gridDelegateWrapper.GridView.isCurrentItem ? Theme.primary : "transparent"
                            
                            Behavior on color { ColorAnimation { duration: 150 } }
                            
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    gridView.currentIndex = gridDelegateWrapper.index
                                    root.launchCurrent()
                                }
                            }
                            
                            Column {
                                anchors.centerIn: parent
                                spacing: 10
                                
                                Item {
                                    width: 48
                                    height: 48
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    
                                    Image {
                                        id: gridAppIcon
                                        anchors.fill: parent
                                        source: {
                                            if (!gridDelegateWrapper.modelData) return ""
                                            let path = gridDelegateWrapper.modelData.icon ? Quickshell.iconPath(gridDelegateWrapper.modelData.icon) : ""
                                            if (path && path.startsWith("/")) return "file://" + path
                                            return path
                                        }
                                        sourceSize: Qt.size(48, 48)
                                        visible: status === Image.Ready
                                    }
                                    
                                    MaterialIcon {
                                        text: "apps"
                                        size: 48
                                        color: gridDelegateWrapper.GridView.isCurrentItem ? Theme.textOnPrimary : Theme.textMuted
                                        anchors.centerIn: parent
                                        visible: gridAppIcon.status !== Image.Ready
                                    }
                                }
                                
                                Text {
                                    text: gridDelegateWrapper.modelData ? (gridDelegateWrapper.modelData.name || "Unknown") : ""
                                    color: gridDelegateWrapper.GridView.isCurrentItem ? Theme.textOnPrimary : Theme.textPrimary
                                    font.pointSize: 11
                                    font.bold: true
                                    horizontalAlignment: Text.AlignHCenter
                                    width: Math.max(0, gridView.cellWidth - 24)
                                    wrapMode: Text.WordWrap
                                    maximumLineCount: 2
                                    elide: Text.ElideRight
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
