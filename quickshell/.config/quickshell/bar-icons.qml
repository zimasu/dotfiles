// ── Bar Icons — full wiring ──────────────────────────────────────────
// paru -S fuzzel tomatillo gnome-calendar wlogout zenity \
//          nm-connection-editor blueberry pwvucontrol

import Quickshell
import QtQuick


// ── Pac-Man / App Launcher Row ───────────────────────────────────────
Item {
    id: launcherRow

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["fuzzel"])
    }
}


// ── WiFi Icon ────────────────────────────────────────────────────────
Text {
    id: wifiIcon
    text: "\uf1eb"
    font.family: "Font Awesome 6 Free"

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["nm-connection-editor"])
    }
}


// ── Bluetooth Icon ───────────────────────────────────────────────────
Text {
    id: btIcon
    text: "\uf294"
    font.family: "Font Awesome 6 Free"

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["blueberry"])
    }
}


// ── Volume Icon ──────────────────────────────────────────────────────
Text {
    id: volIcon
    text: "\uf028"
    font.family: "Font Awesome 6 Free"

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["pwvucontrol"])
    }
}


// ── Power Icon — two-stage confirm → wlogout ─────────────────────────
Text {
    id: powerIcon
    text: "\uf011"
    font.family: "Font Awesome 6 Free"

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached([
            "bash", "-c",
            "zenity --question " +
            "--title='Done with work?' " +
            "--text='Done with work?' " +
            "--ok-label='Yes' " +
            "--cancel-label='No' " +
            "&& zenity --question " +
            "--title='Goodbye, $USER' " +
            "--text='Goodbye, $USER!' " +
            "--ok-label='See ya!' " +
            "--cancel-label='Cancel' " +
            "&& wlogout"
        ])
    }
}


// ── Clock — click opens Tomatillo (Pomodoro) ─────────────────────────
Text {
    id: clockLabel
    text: Qt.formatTime(new Date(), "hh:mm")
    font.family: "monospace"

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: clockLabel.text = Qt.formatTime(new Date(), "hh:mm")
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["tomatillo"])
    }
}


// ── Date — click opens GNOME Calendar ───────────────────────────────
Text {
    id: dateLabel
    text: Qt.formatDate(new Date(), "ddd d MMM")
    font.family: "monospace"

    MouseArea {
        anchors.fill: parent
        onClicked: Quickshell.execDetached(["gnome-calendar"])
    }
}
