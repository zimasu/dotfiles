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
    readonly property color red:   "#fb4934"

    // live clock
    property string currentTime: Qt.formatTime(new Date(), "hh:mm")
    property string currentDate: Qt.formatDate(new Date(), "dd.MM.yyyy")

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            topBar.currentTime = Qt.formatTime(new Date(), "hh:mm")
            topBar.currentDate = Qt.formatDate(new Date(), "dd.MM.yyyy")
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 20
        anchors.rightMargin: 12
        spacing: 0

        // ── Pac-Man row → fuzzel ─────────────────────────────────────
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

            MouseArea {
                anchors.fill: parent
                onClicked: Quickshell.execDetached(["fuzzel"])
            }
        }

        Item { Layout.fillWidth: true }

        // ── Clock → tomatillo ─────────────────────────────────────────
        Text {
            Layout.alignment: Qt.AlignVCenter
            text: topBar.currentTime
            color: topBar.muted
            font.family: "JetBrainsMono Nerd Font Mono"
            font.pixelSize: 10
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            height: topBar.height

            MouseArea {
                anchors.fill: parent
                onClicked: Quickshell.execDetached(["tomatillo"])
            }
        }

        Item { Layout.fillWidth: true }

        // ── Right icons ───────────────────────────────────────────────
        Row {
            Layout.alignment: Qt.AlignVCenter
            spacing: 6

            // Date → gnome-calendar
            Text {
                text: topBar.currentDate
                color: topBar.muted
                font.family: "JetBrainsMono Nerd Font Mono"
                font.pixelSize: 10
                verticalAlignment: Text.AlignVCenter
                height: topBar.height
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["gnome-calendar"])
                }
            }

            // WiFi → nm-connection-editor
            Text {
                text: "\uf1eb"
                color: topBar.muted
                font.family: "JetBrainsMono Nerd Font Mono"
                font.pixelSize: 10
                verticalAlignment: Text.AlignVCenter
                height: topBar.height
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["nm-connection-editor"])
                }
            }

            // Bluetooth → blueberry
            Text {
                text: "\uf294"
                color: topBar.muted
                font.family: "JetBrainsMono Nerd Font Mono"
                font.pixelSize: 10
                verticalAlignment: Text.AlignVCenter
                height: topBar.height
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["blueberry"])
                }
            }

            // Volume → pwvucontrol
            Text {
                text: "\uf028"
                color: topBar.muted
                font.family: "JetBrainsMono Nerd Font Mono"
                font.pixelSize: 10
                verticalAlignment: Text.AlignVCenter
                height: topBar.height
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached(["pwvucontrol"])
                }
            }

            // Power → "Done with work?" → wlogout
            Text {
                text: "\uf011"
                color: topBar.red
                font.family: "JetBrainsMono Nerd Font Mono"
                font.pixelSize: 10
                verticalAlignment: Text.AlignVCenter
                height: topBar.height
                MouseArea {
                    anchors.fill: parent
                    onClicked: Quickshell.execDetached([
                        "bash", "-c",
                        "zenity --question --title='Done with work?' --text='Done with work?' --ok-label='Yes' --cancel-label='No' && wlogout"
                    ])
                }
            }
        }
    }
}
