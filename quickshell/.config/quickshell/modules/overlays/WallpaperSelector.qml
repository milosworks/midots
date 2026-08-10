pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.state
import qs.components
import qs.theme

FocusScope {
    id: root

    implicitWidth: 1600
    implicitHeight: 480

    property bool isActive: visible
    property string originalWallpaperPath: ShellState.wallpaperPath
    property bool isSaved: false

    property var allFiles: []
    property string searchText: ""

    readonly property var filteredFiles: {
        const files = root.allFiles
        const query = root.searchText
        if (!query) return files

        const filtered = []
        for (let i = 0; i < files.length; i++) {
            const name = files[i].split('/').pop().replace(/\.[^/.]+$/, "").toLowerCase()
            if (name.includes(query)) filtered.push(files[i])
        }
        return filtered
    }

    readonly property int safeCount: root.filteredFiles.length

    ScriptModel {
        id: wallpaperModel
        values: root.filteredFiles
    }

    Process {
        id: fetchWallpapers
        running: root.isActive && root.allFiles.length === 0
        command: ["sh", "-c", "find ~/.local/share/wallpapers -type f '(' -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' ')'"]
        stdout: StdioCollector {
            onStreamFinished: {
                let files = this.text.trim().split("\n")
                let validFiles = []
                for (let i = 0; i < files.length; i++) {
                    if (files[i]) validFiles.push(files[i])
                }
                root.allFiles = validFiles
                root.updateSearch(searchInput.text)
            }
        }
    }

    Timer {
        id: previewTimer
        interval: 150
        property string targetPath: ""

        onTriggered: {
            if (targetPath) {
                Quickshell.execDetached(["sh", "-c", `awww img "${targetPath}" --transition-type wave --transition-angle 45 --transition-duration 0.5 --resize fit --transition-fps 60 && matugen image "${targetPath}"`])
            }
        }
    }

    function previewWallpaper(path: string) {
        if (!path) return
        previewTimer.targetPath = path
        previewTimer.restart()
    }

    property string hoveredWallpaperPath: ""
    onHoveredWallpaperPathChanged: {
        if (hoveredWallpaperPath && hoveredWallpaperPath !== root.originalWallpaperPath) {
            previewWallpaper(hoveredWallpaperPath)
        } else {
            previewWallpaper(root.originalWallpaperPath)
        }
    }

    Timer {
        id: clearHoverTimer
        interval: 10
        onTriggered: {
            root.hoveredWallpaperPath = ""
        }
    }

    function applyWallpaper(path: string) {
        if (!path) return

        let cmd = `awww img "${path}" --transition-type wave --transition-angle 45 --transition-duration 1.5 --resize fit --transition-fps 60`
        cmd += ` && matugen image "${path}"`
        cmd += ` && mkdir -p ~/.local/state/mish && echo "${path}" > ~/.local/state/mish/wallpaper.txt`

        ShellState.wallpaperPath = path
        Quickshell.execDetached(["sh", "-c", cmd])
        root.isSaved = true
    }

    function saveCurrentWallpaper() {
        if (carousel.currentIndex >= 0 && carousel.currentIndex < root.filteredFiles.length) {
            let currentPath = root.filteredFiles[carousel.currentIndex]
            applyWallpaper(currentPath)
            Overlays.toggleOverlay("wallpaper", "bottom", Overlays.targetScreen)
        }
    }

    function closeSelector() {
        if (!root.isSaved && root.originalWallpaperPath) {
            Quickshell.execDetached(["sh", "-c", `awww img "${root.originalWallpaperPath}" --transition-type wave --transition-angle 45 --transition-duration 0.5 --resize fit --transition-fps 60 && matugen image "${root.originalWallpaperPath}"`])
        }
        Overlays.toggleOverlay("wallpaper", "bottom", Overlays.targetScreen)
    }

    onIsActiveChanged: {
        if (isActive) {
            root.originalWallpaperPath = ShellState.wallpaperPath
            root.isSaved = false
            searchInput.text = ""
            searchInput.forceActiveFocus()
        }
    }

    function updateSearch(query) {
        if (!root.isActive) return;
        root.searchText = (query || "").toLowerCase()

        const files = root.filteredFiles
        let targetIndex = 0
        for (let i = 0; i < files.length; i++) {
            if (ShellState.wallpaperPath && files[i] === ShellState.wallpaperPath) {
                targetIndex = i
                break
            }
        }

        Qt.callLater(function() {
            if (root.filteredFiles.length > 0) {
                carousel.currentIndex = targetIndex
            }
        })
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.closeSelector()
    }

    Keys.onEscapePressed: root.closeSelector()
    Keys.onLeftPressed: carousel.decrementCurrentIndex()
    Keys.onRightPressed: carousel.incrementCurrentIndex()
    Keys.onEnterPressed: root.saveCurrentWallpaper()
    Keys.onReturnPressed: root.saveCurrentWallpaper()

    Column {
        anchors.fill: parent
        topPadding: 30
        leftPadding: 30
        rightPadding: 30
        spacing: 20

        Rectangle {
            width: 600
            height: 60
            color: Theme.surfaceVariant
            radius: 12
            anchors.horizontalCenter: parent.horizontalCenter

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

                Timer {
                    id: searchDebounce
                    interval: 10
                    onTriggered: root.updateSearch(searchInput.text)
                }

                TextInput {
                    id: searchInput
                    width: parent.width - 40
                    anchors.verticalCenter: parent.verticalCenter
                    font.pointSize: 18
                    color: Theme.textPrimary
                    focus: true
                    clip: true
                    font.family: "Inter"

                    onTextChanged: searchDebounce.restart()

                    Keys.onLeftPressed: carousel.decrementCurrentIndex()
                    Keys.onRightPressed: carousel.incrementCurrentIndex()
                    Keys.onReturnPressed: root.saveCurrentWallpaper()
                    Keys.onEnterPressed: root.saveCurrentWallpaper()
                    Keys.onEscapePressed: root.closeSelector()
                }
            }
        }

        Item {
            width: parent.width - 60
            height: parent.height - 80 - parent.spacing - 30
            clip: true

            Text {
                anchors.centerIn: parent
                text: "No wallpapers :("
                color: Theme.textMuted
                font.pointSize: 16
                visible: root.safeCount === 0
            }

            ListView {
                id: carousel
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter

                orientation: ListView.Horizontal
                spacing: -190

                property int itemStride: 450 + spacing

                model: wallpaperModel
                visible: root.safeCount > 0

                width: Math.min(parent.width, root.safeCount > 0 ? 450 + (root.safeCount - 1) * itemStride : 0)

                preferredHighlightBegin: width / 2 - 225
                preferredHighlightEnd: width / 2 - 225
                highlightRangeMode: ListView.StrictlyEnforceRange
                highlightMoveDuration: 200

                delegate: Item {
                    id: itemDelegate

                    required property int index
                    required property string modelData
                    readonly property string path: modelData
                    property int distance: Math.abs(index - carousel.currentIndex)
                    property bool isCurrent: distance === 0

                    property real xOffset: {
                        if (distance <= 1) return 0;
                        let pull = (distance - 1) * 110;
                        return index < carousel.currentIndex ? pull : -pull;
                    }

                    transform: Translate {
                        x: itemDelegate.xOffset
                        Behavior on x { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                    }

                    width: 450
                    height: 300
                    scale: distance === 0 ? 1.0 : (distance === 1 ? 0.65 : (distance === 2 ? 0.45 : 0.35))
                    opacity: distance === 0 ? 1.0 : (distance === 1 ? 0.7 : (distance === 2 ? 0.4 : 0.2))
                    z: 100 - distance

                    Behavior on scale { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
                    Behavior on opacity { NumberAnimation { duration: 200 } }

                    Rectangle {
                        id: imageBorder
                        anchors.fill: parent
                        color: "transparent"
                        radius: Theme.notchPopupCornerRadius
                        border.width: itemDelegate.isCurrent ? 4 : 0
                        border.color: Theme.primary

                        ClippingRectangle {
                            anchors.fill: parent
                            anchors.margins: parent.border.width
                            color: "transparent"
                            radius: Math.max(0, imageBorder.radius - imageBorder.border.width)

                            Image {
                                anchors.fill: parent
                                source: "file://" + itemDelegate.path
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                            }
                        }
                    }

                    Text {
                        anchors.top: imageBorder.bottom
                        anchors.topMargin: 10
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width - 20

                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight

                        text: itemDelegate.path.split('/').pop().replace(/\.[^/.]+$/, "")

                        color: itemDelegate.isCurrent ? Theme.primary : Theme.textMuted
                        font.pointSize: 12
                        font.bold: itemDelegate.isCurrent
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onContainsMouseChanged: {
                            if (containsMouse) {
                                clearHoverTimer.stop()
                                root.hoveredWallpaperPath = itemDelegate.path
                            } else {
                                clearHoverTimer.restart()
                            }
                        }
                        onClicked: {
                            if (itemDelegate.isCurrent) {
                                root.saveCurrentWallpaper()
                            } else {
                                carousel.currentIndex = itemDelegate.index
                            }
                        }
                    }
                }
            }

            Rectangle {
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 250
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: Theme.surface }
                    GradientStop { position: 1.0; color: "transparent" }
                }
            }

            Rectangle {
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 250
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop { position: 0.0; color: "transparent" }
                    GradientStop { position: 1.0; color: Theme.surface }
                }
            }
        }
    }
}
