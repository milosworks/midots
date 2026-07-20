import QtQuick

Text {
    property real size: 24
    property real fill: 0.0
    property real weight: 400.0

    font.family: "Material Symbols Rounded"
    font.pixelSize: size

    font.variableAxes: {
        "FILL": fill,
        "wght": weight,
        "GRAD": 0.0,
        "opsz": size
    }

    color: "white"

    renderType: Text.NativeRendering
}