import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Shapes

PanelWindow {
    id: borderWindow

    screen: Quickshell.screens.find(s => s.name === "DP-1")
    anchors { top: true; bottom: true; left: true; right: true }
    color: "transparent"
    exclusiveZone: 0
    WlrLayershell.layer: WlrLayer.Overlay

    // only the top bar strip receives mouse input
    mask: Region {
        item: topBarStrip
    }

    readonly property color borderColor: "#1d2021"
    readonly property color muted: "#a89984"
    readonly property color red: "#fb4934"
    readonly property int topThickness: 22
    readonly property int sideThickness: 8
    readonly property int bottomThickness: 8
    readonly property int rad: 10
    readonly property int contentHeight: 10

    property string currentTime: Qt.formatTime(new Date(), "hh:mm")
    property string currentDate: Qt.formatDate(new Date(), "dd.MM.yyyy")
    Timer {
        interval: 10000; running: true; repeat: true
        onTriggered: {
            borderWindow.currentTime = Qt.formatTime(new Date(), "hh:mm")
            borderWindow.currentDate = Qt.formatDate(new Date(), "dd.MM.yyyy")
        }
    }

    // ── Border rectangles ─────────────────────────────────────────────
    Rectangle {
        id: topBarStrip
        color: borderWindow.borderColor
        anchors { top: parent.top; left: parent.left; right: parent.right }
        height: borderWindow.topThickness
    }
    Rectangle {
        color: borderWindow.borderColor
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        height: borderWindow.bottomThickness
    }
    Rectangle {
        color: borderWindow.borderColor
        anchors { top: parent.top; bottom: parent.bottom; left: parent.left }
        width: borderWindow.sideThickness
    }
    Rectangle {
        color: borderWindow.borderColor
        anchors { top: parent.top; bottom: parent.bottom; right: parent.right }
        width: borderWindow.sideThickness
    }

    // ── Corner radii ──────────────────────────────────────────────────
    Shape {
        x: borderWindow.sideThickness; y: borderWindow.topThickness
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
    Shape {
        x: parent.width - borderWindow.sideThickness - borderWindow.rad; y: borderWindow.topThickness
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
    Shape {
        x: borderWindow.sideThickness; y: parent.height - borderWindow.bottomThickness - borderWindow.rad
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

    // ── Top bar content ───────────────────────────────────────────────
    Item {
        x: borderWindow.sideThickness + 8
        y: (borderWindow.topThickness - borderWindow.contentHeight) / 2
        width: parent.width - (borderWindow.sideThickness + 8) * 2
        height: borderWindow.contentHeight

        // Pac-Man row → fuzzel
        Item {
            id: pacItem
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            height: borderWindow.contentHeight
            width: pacRow.width

            Row {
                id: pacRow
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
            MouseArea {
                anchors.fill: parent
                onClicked: Quickshell.execDetached(["fuzzel"])
            }
        }

        // Clock → tomatillo
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: borderWindow.currentTime
            color: borderWindow.muted
            font.family: "JetBrainsMono Nerd Font Mono"
            font.pixelSize: 10
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            height: borderWindow.contentHeight
            MouseArea {
                anchors.fill: parent
                onClicked: Quickshell.execDetached(["tomatillo"])
            }
        }

        // Right icons
        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            // Date → gnome-calendar
            Text {
                text: borderWindow.currentDate
                color: borderWindow.muted
                font.family: "JetBrainsMono Nerd Font Mono"
                font.pixelSize: 10
                verticalAlignment: Text.AlignVCenter
                height: borderWindow.contentHeight
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["gnome-calendar"])
                }
            }

            // WiFi → nm-connection-editor
            Text {
                text: "\uf1eb"
                color: borderWindow.muted
                font.family: "JetBrainsMono Nerd Font Mono"
                font.pixelSize: 10
                verticalAlignment: Text.AlignVCenter
                height: borderWindow.contentHeight
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["nm-connection-editor"])
                }
            }

            // Bluetooth → blueberry
            Text {
                text: "\uf294"
                color: borderWindow.muted
                font.family: "JetBrainsMono Nerd Font Mono"
                font.pixelSize: 10
                verticalAlignment: Text.AlignVCenter
                height: borderWindow.contentHeight
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["blueberry"])
                }
            }

            // Volume → pwvucontrol
            Text {
                text: "\uf028"
                color: borderWindow.muted
                font.family: "JetBrainsMono Nerd Font Mono"
                font.pixelSize: 10
                verticalAlignment: Text.AlignVCenter
                height: borderWindow.contentHeight
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["pwvucontrol"])
                }
            }

            // Power → confirm → wlogout
            Text {
                text: "\uf011"
                color: borderWindow.red
                font.family: "JetBrainsMono Nerd Font Mono"
                font.pixelSize: 10
                verticalAlignment: Text.AlignVCenter
                height: borderWindow.contentHeight
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached([
                        "bash", "-c", "~/.config/quickshell/scripts/power.sh"
                    ])
                }
            }
        }
    }
}
