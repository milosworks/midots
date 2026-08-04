pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import qs.state
import qs.components
import qs.theme
import qs.shapes

FocusScope {
    id: root

    implicitWidth: 600
    implicitHeight: 800

    property string searchText: ""
    property var allEntries: []
    property var filteredEntries: []

    Process {
        id: clipvaultList
        command: ["clipvault", "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                let lines = this.text.trim().split("\n")
                let entries = []
                for (let i = 0; i < lines.length; i++) {
                    if (lines[i] === "") continue;
                    let parts = lines[i].split("\t")
                    if (parts.length >= 2) {
                        let isImage = parts[1].startsWith("[[ binary data") && parts[1].includes("image/")
                        entries.push({
                            id: parts[0],
                            preview: parts.slice(1).join("\t"),
                            isImage: isImage
                        })
                    }
                }
                root.allEntries = entries
                root.updateSearch(root.searchText)
            }
        }
    }

    Process {
        id: clipvaultClear
        command: ["clipvault", "clear"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.refresh()
            }
        }
    }

    function refresh() {
        clipvaultList.running = true
    }

    onVisibleChanged: {
        if (visible) {
            refresh()
            searchInput.text = ""
            searchInput.forceActiveFocus()
        }
    }

    function isMatch(entry) {
        if (!searchText) return true
        return entry.preview.toLowerCase().includes(searchText)
    }

    function updateSearch(text) {
        searchText = text.toLowerCase()
        let filtered = []
        for (let i = 0; i < allEntries.length; i++) {
            if (isMatch(allEntries[i])) {
                filtered.push(allEntries[i])
            }
        }
        filteredEntries = filtered
        listView.currentIndex = 0
    }

    function moveUp() {
        if (listView.currentIndex > 0) listView.currentIndex--
    }

    function moveDown() {
        if (listView.currentIndex < filteredEntries.length - 1) listView.currentIndex++
    }

    function launchCurrent() {
        if (listView.currentIndex >= 0 && listView.currentIndex < filteredEntries.length) {
            let entry = filteredEntries[listView.currentIndex]
            Quickshell.execDetached(["sh", "-c", `clipvault get ${entry.id} | wl-copy`])
            Overlays.toggleOverlay("clipboard", "bottom", Overlays.targetScreen)
            searchText = ""
            searchInput.text = ""
        }
    }

    function deleteCurrent() {
        if (listView.currentIndex >= 0 && listView.currentIndex < filteredEntries.length) {
            let entry = filteredEntries[listView.currentIndex]
            Quickshell.execDetached(["clipvault", "delete", entry.id])
            deleteDelay.start()
        }
    }

    Timer {
        id: deleteDelay
        interval: 100
        onTriggered: root.refresh()
    }

    NotchPopup {
        anchors.fill: parent
        color: Theme.surface
        side: "bottom"
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
                        width: parent.width - 40 - 15 - 40 - 15 - 40
                        anchors.verticalCenter: parent.verticalCenter
                        font.pointSize: 18
                        color: Theme.textPrimary
                        focus: true
                        clip: true
                        
                        onTextChanged: root.updateSearch(text)
                        
                        Keys.onUpPressed: root.moveUp()
                        Keys.onDownPressed: root.moveDown()
                        Keys.onReturnPressed: root.launchCurrent()
                        Keys.onEnterPressed: root.launchCurrent()
                        Keys.onDeletePressed: root.deleteCurrent()
                        Keys.onEscapePressed: {
                            Overlays.toggleOverlay("clipboard", "bottom", Overlays.targetScreen)
                            root.searchText = ""
                            searchInput.text = ""
                        }
                    }

                    Item { width: parent.width - 40 - searchInput.width - 15 - 40 - 15 - 40 - 30 } // spacer

                    Rectangle {
                        width: 40; height: 40; radius: 10
                        anchors.verticalCenter: parent.verticalCenter
                        color: refreshMouseArea.containsMouse ? Theme.primary : "transparent"
                        Behavior on color { ColorAnimation { duration: 150 } }
                        MaterialIcon {
                            text: "refresh"
                            size: 24
                            color: refreshMouseArea.containsMouse ? Theme.textOnPrimary : Theme.primary
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            id: refreshMouseArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: root.refresh()
                        }
                    }

                    Rectangle {
                        width: 40; height: 40; radius: 10
                        anchors.verticalCenter: parent.verticalCenter
                        color: clearMouseArea.containsMouse ? Theme.primary : "transparent"
                        Behavior on color { ColorAnimation { duration: 150 } }
                        MaterialIcon {
                            text: "delete_sweep"
                            size: 24
                            color: clearMouseArea.containsMouse ? Theme.textOnPrimary : Theme.primary
                            anchors.centerIn: parent
                        }
                        MouseArea {
                            id: clearMouseArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            hoverEnabled: true
                            onClicked: {
                                clipvaultClear.running = true
                            }
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
                        text: "content_paste"
                        size: 16
                        color: Theme.textMuted
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: root.filteredEntries.length + " Items"
                        color: Theme.textMuted
                        font.pointSize: 12
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Item {
                width: parent.width
                height: parent.height - 80 - parent.spacing * 2 - 20
                clip: true

                ListView {
                    id: listView
                    anchors.fill: parent
                    model: root.filteredEntries
                    spacing: 5
                    
                    preferredHighlightBegin: 40
                    preferredHighlightEnd: height - 40
                    highlightRangeMode: ListView.ApplyRange
                    highlightMoveDuration: 150
                    
                    delegate: Item {
                        id: delegateWrapper
                        width: listView.width
                        height: modelData.isImage ? 130 : 68
                        
                        required property var modelData
                        required property int index
                        
                        Rectangle {
                            id: delegateRect
                            anchors.fill: parent
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

                                Rectangle {
                                    width: 38
                                    height: 38
                                    anchors.verticalCenter: parent.verticalCenter
                                    radius: 12
                                    color: delegateWrapper.ListView.isCurrentItem ? Qt.rgba(Theme.textOnPrimary.r, Theme.textOnPrimary.g, Theme.textOnPrimary.b, 0.15) : Qt.rgba(Theme.textPrimary.r, Theme.textPrimary.g, Theme.textPrimary.b, 0.06)
                                    
                                    MaterialIcon {
                                        text: delegateWrapper.modelData.isImage ? "image" : "description"
                                        size: 20
                                        color: delegateWrapper.ListView.isCurrentItem ? Theme.textOnPrimary : Theme.textMuted
                                        anchors.centerIn: parent
                                    }
                                }
                                
                                Item {
                                    width: parent.width - 38 - 18 - 30 - 18
                                    height: parent.height
                                    
                                    Text {
                                        anchors.verticalCenter: parent.verticalCenter
                                        visible: !delegateWrapper.modelData.isImage
                                        text: delegateWrapper.modelData.preview
                                        color: delegateWrapper.ListView.isCurrentItem ? Theme.textOnPrimary : Theme.textPrimary
                                        font.pointSize: 12
                                        elide: Text.ElideRight
                                        maximumLineCount: 2
                                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                        width: parent.width
                                    }
                                    
                                    Item {
                                        anchors.fill: parent
                                        visible: delegateWrapper.modelData.isImage
                                        
                                        Process {
                                            id: imageLoader
                                            running: delegateWrapper.modelData.isImage && delegateWrapper.visible
                                            command: ["sh", "-c", `clipvault get ${delegateWrapper.modelData.id} | base64 -w 0`]
                                            stdout: StdioCollector {
                                                onStreamFinished: {
                                                    imageDisplay.source = "data:image/png;base64," + this.text.trim()
                                                }
                                            }
                                        }

                                        Image {
                                            id: imageDisplay
                                            anchors.verticalCenter: parent.verticalCenter
                                            height: parent.height - 10
                                            width: height * 2
                                            fillMode: Image.PreserveAspectCrop
                                        }
                                    }
                                }
                                
                                Rectangle {
                                    width: 30; height: 30; radius: 10
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: delMouseArea.containsMouse ? Qt.rgba(Theme.error.r, Theme.error.g, Theme.error.b, 0.25) : "transparent"
                                    opacity: delegateWrapper.ListView.isCurrentItem ? 1.0 : 0.0
                                    Behavior on opacity { NumberAnimation { duration: 150 } }
                                    
                                    MaterialIcon {
                                        text: "close"
                                        size: 16
                                        color: delMouseArea.containsMouse ? Theme.error : Theme.textOnPrimary
                                        anchors.centerIn: parent
                                    }
                                    
                                    MouseArea {
                                        id: delMouseArea
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked: {
                                            Quickshell.execDetached(["clipvault", "delete", delegateWrapper.modelData.id])
                                            deleteDelay.start()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
