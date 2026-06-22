import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

PanelWindow {
    id: topBar

    screen: Quickshell.screens.find(s => s.name === "DP-1")

    anchors { top: true; left: true; right: true }

    implicitHeight: 20
    color: "#1d2021"
    exclusiveZone: 20
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.margins { top: 10 }

    readonly property color muted: "#a89984"
    readonly property color red: "#fb4934"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 12
        spacing: 0

        Row {
            Layout.alignment: Qt.AlignVCenter
            spacing: 5
            Repeater {
                model: ["ᗧ", "ᗣ", "ᗣ", "ᗣ", "ᗣ"]
                Text {
                    text: modelData
                    color: topBar.muted
                    font.family: "JetBrainsMono Nerd Font Mono"
                    font.pixelSize: 10
                    verticalAlignment: Text.AlignVCenter
                    height: topBar.height
                }
            }
        }

        Item { Layout.fillWidth: true }

        Text {
            Layout.alignment: Qt.AlignVCenter
            text: "00:09"
            color: topBar.muted
            font.family: "JetBrainsMono Nerd Font Mono"
            font.pixelSize: 10
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            height: topBar.height
        }

        Item { Layout.fillWidth: true }

        Row {
            Layout.alignment: Qt.AlignVCenter
            spacing: 6
            Repeater {
                model: [
                    { t: "21.06.2026", c: topBar.muted, b: false },
                    { t: "\uf1eb",     c: topBar.muted, b: false },
                    { t: "\uf294",     c: topBar.muted, b: false },
                    { t: "\uf028",     c: topBar.muted, b: false },
                    { t: "\uf011",     c: topBar.red,   b: false }
                ]
                Text {
                    text: modelData.t
                    color: modelData.c
                    font.family: "JetBrainsMono Nerd Font Mono"
                    font.pixelSize: 10
                    verticalAlignment: Text.AlignVCenter
                    height: topBar.height
                }
            }
        }
    }
}
