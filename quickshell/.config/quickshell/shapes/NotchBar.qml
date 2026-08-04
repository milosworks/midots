import QtQuick
import QtQuick.Shapes
import qs.theme

Item {
    id: root
    anchors.fill: parent
    property int leftWidth: Theme.leftNotchMinWidth
    property int centerWidth: Theme.centerNotchMinWidth
    property int rightWidth: Theme.rightNotchMinWidth

    property int leftHeight: Theme.notchHeight
    property int centerHeight: Theme.notchHeight
    property int rightHeight: Theme.notchHeight
    property int bottomRadius: Theme.notchBottomRadius
    property int topRadius: Theme.notchTopRadius
    property int sideRadius: Theme.notchSideRadius 
    property color color: Theme.surface

    Shape {
        id: leftNotch
        visible: root.leftWidth > 1 && root.leftHeight > 1
        anchors.left: parent.left
        anchors.top: parent.top
        width: root.leftWidth + root.topRadius
        height: root.leftHeight + root.sideRadius

        ShapePath {
            fillColor: root.color
            strokeColor: "transparent"
            strokeWidth: 0

            startX: 0
            startY: 0

            PathLine { x: 0; y: root.leftHeight + root.sideRadius }
            PathQuad { x: root.sideRadius; y: root.leftHeight; controlX: 0; controlY: root.leftHeight }
            PathLine { x: root.leftWidth - root.bottomRadius; y: root.leftHeight }
            PathArc { 
                x: root.leftWidth; y: root.leftHeight - root.bottomRadius
                radiusX: root.bottomRadius; radiusY: root.bottomRadius
                useLargeArc: false
                direction: PathArc.Counterclockwise
            }
            PathLine { x: root.leftWidth; y: root.topRadius }
            PathArc {
                x: root.leftWidth + root.topRadius; y: 0
                radiusX: root.topRadius; radiusY: root.topRadius
                useLargeArc: false
                direction: PathArc.Clockwise
            }
            PathLine { x: 0; y: 0 }
        }
    }

    Shape {
        id: centerNotch
        visible: root.centerWidth > 1 && root.centerHeight > 1
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.centerWidth + root.topRadius * 2
        height: root.centerHeight

        ShapePath {
            fillColor: root.color
            strokeColor: "transparent"
            strokeWidth: 0
            startX: 0
            startY: 0
            
            PathArc {
                x: root.topRadius; y: root.topRadius
                radiusX: root.topRadius; radiusY: root.topRadius
                useLargeArc: false
                direction: PathArc.Clockwise
            }
            PathLine { x: root.topRadius; y: root.centerHeight - root.bottomRadius }
            PathArc {
                x: root.topRadius + root.bottomRadius; y: root.centerHeight
                radiusX: root.bottomRadius; radiusY: root.bottomRadius
                useLargeArc: false
                direction: PathArc.Counterclockwise
            }
            PathLine { x: root.topRadius + root.centerWidth - root.bottomRadius; y: root.centerHeight }
            PathArc {
                x: root.topRadius + root.centerWidth; y: root.centerHeight - root.bottomRadius
                radiusX: root.bottomRadius; radiusY: root.bottomRadius
                useLargeArc: false
                direction: PathArc.Counterclockwise
            }
            PathLine { x: root.topRadius + root.centerWidth; y: root.topRadius }
            PathArc {
                x: root.topRadius * 2 + root.centerWidth; y: 0
                radiusX: root.topRadius; radiusY: root.topRadius
                useLargeArc: false
                direction: PathArc.Clockwise
            }
            PathLine { x: 0; y: 0 }
        }
    }

    Shape {
        id: rightNotch
        visible: root.rightWidth > 1 && root.rightHeight > 1
        anchors.right: parent.right
        anchors.top: parent.top
        width: root.rightWidth + root.topRadius
        height: root.rightHeight + root.sideRadius

        ShapePath {
            fillColor: root.color
            strokeColor: "transparent"
            strokeWidth: 0
            startX: 0 
            startY: 0
            
            PathArc {
                x: root.topRadius; y: root.topRadius
                radiusX: root.topRadius; radiusY: root.topRadius
                useLargeArc: false
                direction: PathArc.Clockwise
            }
            PathLine { x: root.topRadius; y: root.rightHeight - root.bottomRadius }
            PathArc {
                x: root.topRadius + root.bottomRadius; y: root.rightHeight
                radiusX: root.bottomRadius; radiusY: root.bottomRadius
                useLargeArc: false
                direction: PathArc.Counterclockwise
            }
            PathLine { x: root.topRadius + root.rightWidth - root.sideRadius; y: root.rightHeight }
            PathQuad {
                x: root.topRadius + root.rightWidth; y: root.rightHeight + root.sideRadius
                controlX: root.topRadius + root.rightWidth; controlY: root.rightHeight
            }
            PathLine { x: root.topRadius + root.rightWidth; y: 0 }
            PathLine { x: 0; y: 0 }
        }
    }
}