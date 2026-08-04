import QtQuick
import QtQuick.Shapes
import qs.theme

Item {
    id: root

    property string side: "top"
    property color color: Theme.surface

    property int radius: Theme.notchPopupCornerRadius

    property int flareWidth: Theme.notchPopupCornerRadius
    property int flareHeight: Theme.notchPopupCornerRadius

    Shape {
        visible: root.side === "left"
        anchors.fill: parent
        ShapePath {
            fillColor: root.color
            strokeColor: "transparent"
            strokeWidth: 0
            startX: 0; startY: 0
            PathQuad { x: root.flareWidth; y: root.flareHeight; controlX: 0; controlY: root.flareHeight }
            PathLine { x: root.width - root.radius; y: root.flareHeight }
            PathArc { x: root.width; y: root.flareHeight + root.radius; radiusX: root.radius; radiusY: root.radius; direction: PathArc.Clockwise }
            PathLine { x: root.width; y: root.height - root.flareHeight - root.radius }
            PathArc { x: root.width - root.radius; y: root.height - root.flareHeight; radiusX: root.radius; radiusY: root.radius; direction: PathArc.Clockwise }
            PathLine { x: root.flareWidth; y: root.height - root.flareHeight }
            PathQuad { x: 0; y: root.height; controlX: 0; controlY: root.height - root.flareHeight }
            PathLine { x: 0; y: 0 }
        }
    }

    Shape {
        visible: root.side === "right"
        anchors.fill: parent
        ShapePath {
            fillColor: root.color
            strokeColor: "transparent"
            strokeWidth: 0
            startX: root.width; startY: 0
            PathQuad { x: root.width - root.flareWidth; y: root.flareHeight; controlX: root.width; controlY: root.flareHeight }
            PathLine { x: root.radius; y: root.flareHeight }
            PathArc { x: 0; y: root.flareHeight + root.radius; radiusX: root.radius; radiusY: root.radius; direction: PathArc.Counterclockwise }
            PathLine { x: 0; y: root.height - root.flareHeight - root.radius }
            PathArc { x: root.radius; y: root.height - root.flareHeight; radiusX: root.radius; radiusY: root.radius; direction: PathArc.Counterclockwise }
            PathLine { x: root.width - root.flareWidth; y: root.height - root.flareHeight }
            PathQuad { x: root.width; y: root.height; controlX: root.width; controlY: root.height - root.flareHeight }
            PathLine { x: root.width; y: 0 }
        }
    }

    Shape {
        visible: root.side === "top"
        anchors.fill: parent
        ShapePath {
            fillColor: root.color
            strokeColor: "transparent"
            strokeWidth: 0
            startX: 0; startY: 0
            PathQuad { x: root.flareWidth; y: root.flareHeight; controlX: root.flareWidth; controlY: 0 }
            PathLine { x: root.flareWidth; y: root.height - root.radius }
            PathArc { x: root.flareWidth + root.radius; y: root.height; radiusX: root.radius; radiusY: root.radius; direction: PathArc.Counterclockwise }
            PathLine { x: root.width - root.flareWidth - root.radius; y: root.height }
            PathArc { x: root.width - root.flareWidth; y: root.height - root.radius; radiusX: root.radius; radiusY: root.radius; direction: PathArc.Counterclockwise }
            PathLine { x: root.width - root.flareWidth; y: root.flareHeight }
            PathQuad { x: root.width; y: 0; controlX: root.width - root.flareWidth; controlY: 0 }
            PathLine { x: 0; y: 0 }
        }
    }

    Shape {
        visible: root.side === "bottom"
        anchors.fill: parent
        ShapePath {
            fillColor: root.color
            strokeColor: "transparent"
            strokeWidth: 0
            startX: 0; startY: root.height
            PathQuad { x: root.flareWidth; y: root.height - root.flareHeight; controlX: root.flareWidth; controlY: root.height }
            PathLine { x: root.flareWidth; y: root.radius }
            PathArc { x: root.flareWidth + root.radius; y: 0; radiusX: root.radius; radiusY: root.radius; direction: PathArc.Clockwise }
            PathLine { x: root.width - root.flareWidth - root.radius; y: 0 }
            PathArc { x: root.width - root.flareWidth; y: root.radius; radiusX: root.radius; radiusY: root.radius; direction: PathArc.Clockwise }
            PathLine { x: root.width - root.flareWidth; y: root.height - root.flareHeight }
            PathQuad { x: root.width; y: root.height; controlX: root.width - root.flareWidth; controlY: root.height }
            PathLine { x: 0; y: root.height }
        }
    }
}