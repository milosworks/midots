import QtQuick
import qs.theme

Canvas {
    id: root

    anchors.fill: parent

    property int leftWidth: Theme.leftNotchMinWidth
    property int centerWidth: Theme.centerNotchMinWidth
    property int rightWidth: Theme.rightNotchMinWidth

    // NEW: Independent heights for the waterfall melt!
    property int leftHeight: Theme.notchHeight
    property int centerHeight: Theme.notchHeight
    property int rightHeight: Theme.notchHeight

    property int bottomRadius: Theme.notchBottomRadius
    property int topRadius: Theme.notchTopRadius
    property int sideRadius: Theme.notchSideRadius 
    property color color: Theme.surface

    onWidthChanged:       requestPaint()
    onHeightChanged:      requestPaint()
    onLeftWidthChanged:   requestPaint()
    onCenterWidthChanged: requestPaint()
    onRightWidthChanged:  requestPaint()
    onLeftHeightChanged:  requestPaint()
    onCenterHeightChanged:requestPaint()
    onRightHeightChanged: requestPaint()
    onColorChanged:       requestPaint()
    onBottomRadiusChanged:requestPaint()
    onTopRadiusChanged:   requestPaint()
    onSideRadiusChanged:  requestPaint()

    onPaint: {
        const ctx = getContext("2d")
        ctx.reset()

        const leftW   = root.leftWidth
        const centerW = root.centerWidth
        const rightW  = root.rightWidth

        const leftH   = root.leftHeight
        const centerH = root.centerHeight
        const rightH  = root.rightHeight

        const rBottom = root.bottomRadius
        const rTop    = root.topRadius
        const rSide   = root.sideRadius
        const w       = width

        const centerStart = (w / 2) - (centerW / 2)
        const centerEnd   = (w / 2) + (centerW / 2)
        const rightStart  = w - rightW

        ctx.beginPath()
        ctx.fillStyle = root.color
        ctx.moveTo(0, 0)

        if (leftW > 1 && leftH > 1) {
            ctx.lineTo(0, leftH + rSide)
            ctx.quadraticCurveTo(0, leftH, rSide, leftH)
            ctx.lineTo(leftW - rBottom, leftH)
            ctx.arcTo(leftW, leftH, leftW, leftH - rBottom, rBottom)
            ctx.lineTo(leftW, rTop)
            ctx.arcTo(leftW, 0, leftW + rTop, 0, rTop)
        }

        if (centerW > 1 && centerH > 1) {
            ctx.lineTo(centerStart - rTop, 0)
            ctx.arcTo(centerStart, 0, centerStart, rTop, rTop)
            ctx.lineTo(centerStart, centerH - rBottom)
            ctx.arcTo(centerStart, centerH, centerStart + rBottom, centerH, rBottom)
            ctx.lineTo(centerEnd - rBottom, centerH)
            ctx.arcTo(centerEnd, centerH, centerEnd, centerH - rBottom, rBottom)
            ctx.lineTo(centerEnd, rTop)
            ctx.arcTo(centerEnd, 0, centerEnd + rTop, 0, rTop)
        }

        ctx.lineTo(rightStart - rTop, 0)
        
        if (rightW > 1 && rightH > 1) {
            ctx.arcTo(rightStart, 0, rightStart, rTop, rTop)
            ctx.lineTo(rightStart, rightH - rBottom)
            ctx.arcTo(rightStart, rightH, rightStart + rBottom, rightH, rBottom)
            ctx.lineTo(w - rSide, rightH)
            ctx.quadraticCurveTo(w, rightH, w, rightH + rSide)
            ctx.lineTo(w, 0)
        } else {
            ctx.lineTo(w, 0)
        }

        ctx.lineTo(0, 0)
        ctx.fill()
    }
}