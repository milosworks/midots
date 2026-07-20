import QtQuick
import qs.theme

Canvas {
    id: root

    property string side: "top"
    property color color: Theme.surface

    property int radius: Theme.notchPopupCornerRadius

    property int flareWidth: Theme.notchPopupCornerRadius
    property int flareHeight: Theme.notchPopupCornerRadius

    onWidthChanged:        requestPaint()
    onHeightChanged:       requestPaint()
    onSideChanged: requestPaint()
    onColorChanged:        requestPaint()
    onFlareWidthChanged:   requestPaint()
    onFlareHeightChanged:  requestPaint()

    onPaint: {
        const ctx = getContext("2d")
        ctx.reset()

        const h = height
        const w = width
        const r = radius
        const fw = flareWidth
        const fh = flareHeight

        ctx.beginPath()
        ctx.fillStyle = root.color

        switch (root.side) {
            case "left": {
                // Body inset by fw on the Left. Flare stretches vertically by fh.
                ctx.moveTo(0, 0)
                // outward flare top-left
                ctx.quadraticCurveTo(0, fh, fw, fh)
                ctx.lineTo(w - r, fh)
                // normal top-right
                ctx.arcTo(w, fh, w, fh + r, r)
                ctx.lineTo(w, h - fh - r)
                // normal bottom-right
                ctx.arcTo(w, h - fh, w - r, h - fh, r)
                ctx.lineTo(fw, h - fh)
                // outward flare bottom-left
                ctx.quadraticCurveTo(0, h - fh, 0, h)
                ctx.closePath()
                break
            }
            
            case "right": {
                // Body inset by fw on the Right. Flare stretches vertically by fh.
                ctx.moveTo(w, 0)
                // outward flare top-right
                ctx.quadraticCurveTo(w, fh, w - fw, fh)
                ctx.lineTo(r, fh)
                // normal top-left
                ctx.arcTo(0, fh, 0, fh + r, r)
                ctx.lineTo(0, h - fh - r)
                // normal bottom-left
                ctx.arcTo(0, h - fh, r, h - fh, r)
                ctx.lineTo(w - fw, h - fh)
                // outward flare bottom-right
                ctx.quadraticCurveTo(w, h - fh, w, h)
                ctx.closePath()
                break
            }

            case "top": {
                // Body inset by fw on Left/Right. Flare stretches horizontally by fw, vertically by fh.
                ctx.moveTo(0, 0)
                // outward flare top-left
                ctx.quadraticCurveTo(fw, 0, fw, fh)
                ctx.lineTo(fw, h - r)
                // normal bottom-left
                ctx.arcTo(fw, h, fw + r, h, r)
                ctx.lineTo(w - fw - r, h)
                // normal bottom-right
                ctx.arcTo(w - fw, h, w - fw, h - r, r)
                ctx.lineTo(w - fw, fh)
                // outward flare top-right
                ctx.quadraticCurveTo(w - fw, 0, w, 0)
                ctx.closePath()
                break
            }

            case "bottom": {
                // Body inset by fw on Left/Right. Flare stretches horizontally by fw, vertically by fh.
                ctx.moveTo(0, h)
                // outward flare bottom-left
                ctx.quadraticCurveTo(fw, h, fw, h - fh)
                ctx.lineTo(fw, r)
                // normal top-left
                ctx.arcTo(fw, 0, fw + r, 0, r)
                ctx.lineTo(w - fw - r, 0)
                // normal top-right
                ctx.arcTo(w - fw, 0, w - fw, r, r)
                ctx.lineTo(w - fw, h - fh)
                // outward flare bottom-right
                ctx.quadraticCurveTo(w - fw, h, w, h)
                ctx.closePath()
                break
            }
        }

        ctx.fill()
    }
}