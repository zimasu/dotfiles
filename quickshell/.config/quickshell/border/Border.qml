import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Shapes
import QtQuick.Layouts

PanelWindow {
    id: borderWindow

    screen: Quickshell.screens.find(s => s.name === "DP-1")
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Overlay
    mask: Region {}

    readonly property color borderColor: "#1d2021"
    readonly property color muted: "#a89984"
    readonly property color red: "#fb4934"
    readonly property int topThickness: 22
    readonly property int sideThickness: 8
    readonly property int bottomThickness: 8
    readonly property int rad: 10
    readonly property int contentHeight: 10

    // top bar
    Rectangle {
        color: borderWindow.borderColor
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: borderWindow.topThickness
    }
    // bottom bar
    Rectangle {
        color: borderWindow.borderColor
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        height: borderWindow.bottomThickness
    }
    // left bar
    Rectangle {
        color: borderWindow.borderColor
        anchors { top: parent.top; bottom: parent.bottom; left: parent.left }
        width: borderWindow.sideThickness
    }
    // right bar
    Rectangle {
        color: borderWindow.borderColor
        anchors { top: parent.top; bottom: parent.bottom; right: parent.right }
        width: borderWindow.sideThickness
    }

    // top-left inner arc
    Shape {
        x: borderWindow.sideThickness
        y: borderWindow.topThickness
        width: borderWindow.rad; height: borderWindow.rad
        layer.enabled: true; layer.samples: 4
        ShapePath {
            strokeWidth: -1; fillColor: borderWindow.borderColor
            startX: 0; startY: 0
            PathLine { x: borderWindow.rad; y: 0 }
            PathArc { x: 0; y: borderWindow.rad; radiusX: borderWindow.rad; radiusY: borderWindow.rad; direction: PathArc.Counterclockwise }
            PathLine { x: 0; y: 0 }
        }
    }
    // top-right inner arc
    Shape {
        x: parent.width - borderWindow.sideThickness - borderWindow.rad
        y: borderWindow.topThickness
        width: borderWindow.rad; height: borderWindow.rad
        layer.enabled: true; layer.samples: 4
        ShapePath {
            strokeWidth: -1; fillColor: borderWindow.borderColor
            startX: borderWindow.rad; startY: 0
            PathLine { x: 0; y: 0 }
            PathArc { x: borderWindow.rad; y: borderWindow.rad; radiusX: borderWindow.rad; radiusY: borderWindow.rad; direction: PathArc.Clockwise }
            PathLine { x: borderWindow.rad; y: 0 }
        }
    }
    // bottom-left inner arc
    Shape {
        x: borderWindow.sideThickness
        y: parent.height - borderWindow.bottomThickness - borderWindow.rad
        width: borderWindow.rad; height: borderWindow.rad
        layer.enabled: true; layer.samples: 4
        ShapePath {
            strokeWidth: -1; fillColor: borderWindow.borderColor
            startX: 0; startY: borderWindow.rad
            PathLine { x: borderWindow.rad; y: borderWindow.rad }
            PathArc { x: 0; y: 0; radiusX: borderWindow.rad; radiusY: borderWindow.rad; direction: PathArc.Clockwise }
            PathLine { x: 0; y: borderWindow.rad }
        }
    }
    // bottom-right inner arc
    Shape {
        x: parent.width - borderWindow.sideThickness - borderWindow.rad
        y: parent.height - borderWindow.bottomThickness - borderWindow.rad
        width: borderWindow.rad; height: borderWindow.rad
        layer.enabled: true; layer.samples: 4
        ShapePath {
            strokeWidth: -1; fillColor: borderWindow.borderColor
            startX: borderWindow.rad; startY: borderWindow.rad
            PathLine { x: 0; y: borderWindow.rad }
            PathArc { x: borderWindow.rad; y: 0; radiusX: borderWindow.rad; radiusY: borderWindow.rad; direction: PathArc.Counterclockwise }
            PathLine { x: borderWindow.rad; y: borderWindow.rad }
        }
    }

    // top bar content — sits in the bottom half of topThickness
    Item {
        x: borderWindow.sideThickness + 8
        y: (borderWindow.topThickness - borderWindow.contentHeight) / 2
        width: parent.width - (borderWindow.sideThickness + 8) * 2
        height: borderWindow.contentHeight

        // left: pacman + 4 ghosts
        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 5
            Repeater {
                model: ["ᗧ", "ᗣ", "ᗣ", "ᗣ", "ᗣ"]
                Text {
                    text: modelData
                    color: borderWindow.muted
                    font.family: "JetBrainsMono Nerd Font Mono"
                    font.pixelSize: 10
                    verticalAlignment: Text.AlignVCenter
                    height: borderWindow.contentHeight
                }
            }
        }

        // center: clock — true center of the whole bar, independent of side content widths
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "00:09"
            color: borderWindow.muted
            font.family: "JetBrainsMono Nerd Font Mono"
            font.pixelSize: 10
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            height: borderWindow.contentHeight
        }

        // right: date + icons
        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6
            Repeater {
                model: [
                    { t: "21.06.2026", c: borderWindow.muted },
                    { t: "\uf1eb",     c: borderWindow.muted },
                    { t: "\uf294",     c: borderWindow.muted },
                    { t: "\uf028",     c: borderWindow.muted },
                    { t: "\uf011",     c: borderWindow.red   }
                ]
                Text {
                    text: modelData.t
                    color: modelData.c
                    font.family: "JetBrainsMono Nerd Font Mono"
                    font.pixelSize: 10
                    verticalAlignment: Text.AlignVCenter
                    height: borderWindow.contentHeight
                }
            }
        }
    }
}
