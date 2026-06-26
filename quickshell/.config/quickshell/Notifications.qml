import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Services.Notifications

Scope {
    NotificationServer {
        id: notifServer
        actionsSupported:    true
        bodySupported:       true
        bodyMarkupSupported: true
        imageSupported:      true
        keepOnReload:        false
        onNotification: (notif) => {
            notif.tracked = true
            popup.show(notif)
        }
    }

    PanelWindow {
        id: popup
        property var current: null
        visible: current !== null
        anchors { top: true; right: true }
        margins { top: 40; right: 16 }
        width: 360
        height: col.implicitHeight + 24
        color: "transparent"

        Timer {
            id: dismissTimer
            interval: 5000
            onTriggered: popup.dismiss()
        }
        function show(notif) {
            current = notif
            dismissTimer.restart()
        }
        function dismiss() {
            if (current) {
                current.expire()
                current = null
            }
        }

        Rectangle {
            id: card
            anchors.fill: parent
            color: "#1d2021"
            radius: 10

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: "#99000000"
                shadowBlur: 0.8
                shadowHorizontalOffset: 0
                shadowVerticalOffset: 4
            }

            ColumnLayout {
                id: col
                anchors { fill: parent; margins: 12 }
                spacing: 4
                Text {
                    text: popup.current ? popup.current.appName : ""
                    color: "#a89984"
                    font { pixelSize: 11; bold: true }
                    Layout.fillWidth: true
                }
                Text {
                    text: popup.current ? popup.current.summary : ""
                    color: "#ebdbb2"
                    font.pixelSize: 14
                    wrapMode: Text.WordWrap
                    textFormat: Text.PlainText
                    Layout.fillWidth: true
                }
                Text {
                    visible: popup.current && popup.current.body !== ""
                    text: popup.current ? popup.current.body : ""
                    color: "#bdae93"
                    font.pixelSize: 12
                    wrapMode: Text.WordWrap
                    textFormat: Text.PlainText
                    Layout.fillWidth: true
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: popup.dismiss()
        }
    }
}
