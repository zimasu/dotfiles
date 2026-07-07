# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

# ── AI AGENT CONTEXT ──────────────────────────────────────────────────────────
# User: n0xtcy | Berlin | NixOS 26.05 | Hyprland 0.55+ + Wayland | foot | google-chrome
# Philosophy: lean and explicit — no bloat, every package must earn its place
# Shell: zsh + starship
# Dev: Python (tkinter game), venv + pip, VS Code, Git + GitLab, Docker
# Preferences:
#   - bare metal tools over feature-bloated alternatives
#   - aliases over installing extra tools
#   - one tool per job (curl not wget, wl-clipboard, grim+slurp, cliphist)
#   - everything visible and auditable from configuration.nix
#   - nixman for pacman-style package management (-S, -R, -Syu, -Ss, -Q, -Sc)
#   - nixconfig to edit and rebuild in one command
# Quickshell bar: shell.qml loads Border.qml + Notifications.qml (only these two)
#   TopBar.qml and bar-icons.qml exist in dotfiles but are NOT loaded — dead files
#   Bar click targets: fuzzel, tomatillo*, gnome-calendar, nm-connection-editor,
#                      blueberry, pwvucontrol, power.sh (zenity confirm)
#   * tomatillo not in nixpkgs (AUR only) — clock click does nothing until installed
# Dotfiles managed with stow (run after first boot):
#   cd ~/projects/dotfiles && stow foot fuzzel quickshell zsh starship hypr wallpaper
# Monitors: DP-4 (left LG 60hz) | DP-3 (center MSI 240hz) | DP-5 (right LG 60hz)
#   Positions: DP-4=0x0, DP-3=1920x0, DP-5=3840x0
#   DP-3 workspace rules use disjoint selectors (w[tv1] / w[t2-99]) — do not merge
# Cursor: MyCursor theme — install to ~/.local/share/icons/MyCursor/ (tar from prev session)
#   Set in hl.config() cursor block + XCURSOR_THEME/SIZE env vars + GTK settings
# GTK: gruvbox-gtk-theme pkg, settings deployed via /etc/gtk-3.0/ and /etc/gtk-4.0/
# ──────────────────────────────────────────────────────────────────────────────

{ config, pkgs, ... }:

let
  # ── hyprland.lua ────────────────────────────────────────────────────────────
  # NixOS 26.05 ships Hyprland 0.55+ — Lua config only, hyprlang is DEPRECATED.
  # Deployed to /etc/hypr/hyprland.lua, symlinked into ~/.config/hypr/ on login.
  #
  # Source of truth: ~/projects/dotfiles/hypr/.config/hypr/hyprland.lua
  # Inlined here (not split via require()) because hyprland.lua is a Nix store
  # symlink and require() can't resolve siblings from a store path.
  #
  # Changes from Arch dotfiles:
  #   - UWSM handles dbus/systemd/portal — those autostart lines are removed
  #   - opensnitch-ui removed from autostart (add back once configured on NixOS)
  #   - foot instead of kitty (NixOS terminal)
  #   - grim+slurp instead of hyprshot (same Super+L keys)
  #   - mouse bind syntax: { mouse = true } table instead of bare "mouse" string
  #   - MyCursor → Adwaita (custom cursor not set up yet)
  #   - TZDIR NixOS 26.05 bug fix added
  #   - Wayland/Qt/Electron env hints added
  hyprlandLua = pkgs.writeText "hyprland.lua" ''
    -- =============================================================================
    -- hyprland.lua — n0xtcy's Hyprland config (NixOS 26.05)
    -- Hyprland version: 0.55.x (Lua config — hyprlang .conf is DEPRECATED)
    -- Last verified: June 2026
    --
    -- AI SYNTAX NOTES (read this before editing):
    --    - Config format changed from hyprlang (.conf) to Lua (.lua) in v0.55
    --    - hyprlang will be removed in a future release — do NOT revert to .conf
    --    - Wiki: https://wiki.hypr.land/Configuring/Start/
    --    - If something stops working after nixos-rebuild switch, CHECK RELEASE NOTES FIRST
    --    - THIS .lua IS THE ONLY ACTIVE CONFIG. Do not create hyprland.conf.
    --    - Border setup: DO NOT use monitor reserved_area for the quickshell border.
    --      reserved_area shrinks layer-shell surfaces too, pushing the border's
    --      OWN decoration inward and creating a visible double-border artifact.
    --      Use workspace-scoped gaps_out instead — it only affects tiled window
    --      geometry, leaving quickshell's full-screen overlay alone.
    --    - DP-3 gaps use TWO MUTUALLY EXCLUSIVE workspace_rule selectors:
    --      w[tv1]   = exactly 1 tiled window  -> flush to QS border
    --      w[t2-99] = 2-99 tiled windows      -> pulled in from border
    --      These are DISJOINT — never both match at once. This sidesteps the
    --      prop-refresh bug (hyprwm/Hyprland #14233, fixed in v0.55 PR #14349)
    --      where override-style rules go stale on window open/close.
    --      DO NOT convert to a single overriding rule pair.
    --    - shadow offset intentionally unset (defaults 0 0) — don't add one.
    --    - UWSM handles: graphical-session.target, dbus env, xdg-portal startup.
    --      Do NOT add dbus-update-activation-environment or systemctl calls here.
    -- =============================================================================

    -- NixOS 26.05 bug: timezone database not on the default path
    hl.env("TZDIR", "/etc/zoneinfo")

    -- Wayland / Electron / Qt hints
    hl.env("NIXOS_OZONE_WL",                      "1")
    hl.env("QT_QPA_PLATFORM",                     "wayland")
    hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
    hl.env("GDK_BACKEND",                         "wayland,x11")
    hl.env("MOZ_ENABLE_WAYLAND",                  "1")

    -- NVIDIA env vars — remove if switching GPU
    hl.env("LIBVA_DRIVER_NAME",         "nvidia")
    hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
    hl.env("GBM_BACKEND",               "nvidia-drm")
    hl.env("NVD_BACKEND",               "direct")

    -- Cursor
    hl.env("XCURSOR_THEME", "MyCursor")
    hl.env("XCURSOR_SIZE",  "32")

    -- MONITORS
    -- Layout: DP-4 (left LG) | DP-3 (center MSI 240hz) | DP-5 (right LG)
    hl.monitor({ output = "DP-4", mode = "1920x1080@60",  position = "3840x0",    scale = 1 })
    hl.monitor({ output = "DP-3", mode = "1920x1080@240", position = "1920x0", scale = 1 })
    hl.monitor({ output = "DP-5", mode = "1920x1080@60",  position = "0x0", scale = 1 })

    -- WORKSPACE RULES
    -- DP-3: disjoint selectors — see header note, do not change to override pair
    hl.workspace_rule({ workspace = "m[DP-3] w[t2-99]", gaps_out = { top = 30, right = 16, bottom = 16, left = 16 }, gaps_in = 4 })
    hl.workspace_rule({ workspace = "m[DP-3] w[tv1]",   gaps_out = { top = 22, right = 8,  bottom = 8,  left = 8  }, gaps_in = 0 })
    hl.workspace_rule({ workspace = "m[DP-4] w[t2-99]", gaps_out = { top = 8, right = 8, bottom = 8, left = 8 }, gaps_in = 4 })
    hl.workspace_rule({ workspace = "m[DP-4] w[tv1]",   gaps_out = { top = 8, right = 8,  bottom = 8,  left = 8  }, gaps_in = 0 })
    hl.workspace_rule({ workspace = "m[DP-5] w[t2-99]", gaps_out = { top = 8, right = 8, bottom = 8, left = 8 }, gaps_in = 4 })
    hl.workspace_rule({ workspace = "m[DP-5] w[tv1]",   gaps_out = { top = 8, right = 8,  bottom = 8,  left = 8  }, gaps_in = 0 })

    -- GENERAL CONFIG
    hl.config({
        general = {
            gaps_in     = 4,
            gaps_out    = 0,
            border_size = 0,
            col = {
                active_border   = "rgba(1d2021ff)",
                inactive_border = "rgba(1d2021ff)",
            },
        },
        decoration = {
            rounding         = 10,
            dim_inactive     = false,
            dim_strength     = 0,
            active_opacity   = 1.0,
            inactive_opacity = 1.0,
            shadow = {
                enabled      = true,
                range        = 12,
                render_power = 3,
                color        = "rgba(00000099)",
            },
        },
        input = {
            kb_layout    = "de",
            follow_mouse = 1,
            touchpad = {
                natural_scroll = false,
            },
        },
        misc = {
            disable_splash_rendering = true,
            force_default_wallpaper  = 0,
            disable_hyprland_logo    = true,
        },
    })

    -- ANIMATIONS — from dotfiles/configs/settings.lua
    hl.curve("snappy", { type = "bezier", points = { {0.16, 1.0}, {0.30, 1.0} } })

    hl.animation({ leaf = "global",      enabled = false })
    hl.animation({ leaf = "windowsIn",   enabled = true,  speed = 1.8, bezier = "snappy" })
    hl.animation({ leaf = "windowsOut",  enabled = true,  speed = 1.2, bezier = "snappy" })
    hl.animation({ leaf = "windowsMove", enabled = true,  speed = 2.0, bezier = "snappy" })
    hl.animation({ leaf = "layers",      enabled = false })
    hl.animation({ leaf = "fade",        enabled = true,  speed = 2.5, bezier = "snappy" })
    hl.animation({ leaf = "border",      enabled = true,  speed = 3.0, bezier = "snappy" })
    hl.animation({ leaf = "workspaces",  enabled = false })

    -- AUTOSTART — from dotfiles/configs/autostart.lua
    -- UWSM handles: graphical-session.target, dbus env, xdg-portal — not repeated here.
    -- opensnitch-ui: add back once opensnitch is configured on NixOS.
    -- custom cursor: add back once MyCursor theme is set up.
    hl.on("hyprland.start", function()
        hl.exec_cmd("hyprpaper")
        hl.exec_cmd("sleep 1 && hyprctl hyprpaper preload /home/n0xtcy/Pictures/wallpapers/gruv-portal-cake.png")
        hl.exec_cmd("sleep 2 && hyprctl hyprpaper wallpaper ',/home/n0xtcy/Pictures/wallpapers/gruv-portal-cake.png'")
        hl.exec_cmd("quickshell")
        hl.exec_cmd("wl-paste --type text --watch cliphist store")
    end)

    -- KEYBINDS — from dotfiles/configs/keybinds.lua
    local mod = "SUPER"

    -- Core
    hl.bind(mod .. " + Return", hl.dsp.exec_cmd("foot"))
    hl.bind(mod .. " + Q",      hl.dsp.window.close())
    hl.bind(mod .. " + M",      hl.dsp.exit())
    hl.bind(mod .. " + D",      hl.dsp.exec_cmd("fuzzel"))
    hl.bind(mod .. " + B",      hl.dsp.exec_cmd("google-chrome-stable"))

    -- Clipboard history
    hl.bind(mod .. " + V",
        hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))

    -- Screenshots — grim+slurp (same Super+L keys as Arch hyprshot binds)
    --   Super+L       = region → clipboard
    --   Super+Shift+L = active window → clipboard
    --   Super+Ctrl+L  = full DP-3 output → clipboard
    hl.bind(mod .. " + L",
        hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy"))
    hl.bind(mod .. " + SHIFT + L",
        hl.dsp.exec_cmd("grim -g \"$(hyprctl activewindow -j | jq -r '\"\\(.at[0]),\\(.at[1]) \\(.size[0])x\\(.size[1])\"')\" - | wl-copy"))
    hl.bind(mod .. " + CTRL + L",
        hl.dsp.exec_cmd("grim -o DP-3 - | wl-copy"))

    -- Volume
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"))
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"))
    hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))

    -- Mouse
    hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
    hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

    -- Focus
    hl.bind(mod .. " + Left",  hl.dsp.focus({ direction = "left" }))
    hl.bind(mod .. " + Right", hl.dsp.focus({ direction = "right" }))
    hl.bind(mod .. " + Up",    hl.dsp.focus({ direction = "up" }))
    hl.bind(mod .. " + Down",  hl.dsp.focus({ direction = "down" }))

    -- Move windows
    hl.bind(mod .. " + SHIFT + Left",  hl.dsp.window.move({ direction = "l" }))
    hl.bind(mod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "r" }))
    hl.bind(mod .. " + SHIFT + Up",    hl.dsp.window.move({ direction = "u" }))
    hl.bind(mod .. " + SHIFT + Down",  hl.dsp.window.move({ direction = "d" }))

    -- Fullscreen / float
    hl.bind(mod .. " + F",             hl.dsp.window.fullscreen({ action = "toggle" }))
    hl.bind(mod .. " + SHIFT + Space", hl.dsp.window.float({ action = "toggle" }))

    -- Workspaces 1–9
    --[[ DISABLED
    --]]

  '';

footIni = pkgs.writeText "foot.ini" ''
    [main]
    font=JetBrainsMono Nerd Font Mono:size=11
    dpi-aware=no
    pad=8x8
    [cursor]
    style=beam
    blink=yes
    [colors-dark]
    background=1d2021
    foreground=ebdbb2
    cursor=1d2021 d79921
    selection-foreground=1d2021
    selection-background=d79921
    regular0=282828
    regular1=cc241d
    regular2=98971a
    regular3=d79921
    regular4=458588
    regular5=b16286
    regular6=689d6a
    regular7=a89984
    bright0=928374
    bright1=fb4934
    bright2=b8bb26
    bright3=fabd2f
    bright4=83a598
    bright5=d3869b
    bright6=8ec07c
    bright7=ebdbb2
    [mouse]
    hide-when-typing=yes
    [key-bindings]
    spawn-terminal=none
  '';
shellQml = pkgs.writeText "shell.qml" ''
    import Quickshell
    import QtQuick
    ShellRoot {
        Border {}
        Notifications {}
    }
  '';

  borderQml = pkgs.writeText "Border.qml" ''
    import Quickshell
    import Quickshell.Wayland
    import QtQuick
    import QtQuick.Shapes

    PanelWindow {
        id: borderWindow

        screen: Quickshell.screens.find(s => s.name === "DP-3")
        anchors { top: true; bottom: true; left: true; right: true }
        color: "transparent"
        exclusiveZone: 0
        WlrLayershell.layer: WlrLayer.Overlay

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

        Item {
            x: borderWindow.sideThickness + 8
            y: (borderWindow.topThickness - borderWindow.contentHeight) / 2
            width: parent.width - (borderWindow.sideThickness + 8) * 2
            height: borderWindow.contentHeight

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
                    onClicked: Quickshell.execDetached(["gnome-pomodoro"])
                }
            }

            Row {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                Text {
                    text: borderWindow.currentDate
                    color: borderWindow.muted
                    font.family: "JetBrainsMono Nerd Font Mono"
                    font.pixelSize: 10
                    verticalAlignment: Text.AlignVCenter
                    height: borderWindow.contentHeight
                    MouseArea { anchors.fill: parent; onClicked: Quickshell.execDetached(["gnome-calendar"]) }
                }
                Text {
                    text: "\uf1eb"
                    color: borderWindow.muted
                    font.family: "JetBrainsMono Nerd Font Mono"
                    font.pixelSize: 10
                    verticalAlignment: Text.AlignVCenter
                    height: borderWindow.contentHeight
                    MouseArea { anchors.fill: parent; onClicked: Quickshell.execDetached(["nm-connection-editor"]) }
                }
                Text {
                    text: "\uf294"
                    color: borderWindow.muted
                    font.family: "JetBrainsMono Nerd Font Mono"
                    font.pixelSize: 10
                    verticalAlignment: Text.AlignVCenter
                    height: borderWindow.contentHeight
                    MouseArea { anchors.fill: parent; onClicked: Quickshell.execDetached(["blueman-manager"]) }
                }
                Text {
                    text: "\uf028"
                    color: borderWindow.muted
                    font.family: "JetBrainsMono Nerd Font Mono"
                    font.pixelSize: 10
                    verticalAlignment: Text.AlignVCenter
                    height: borderWindow.contentHeight
                    MouseArea { anchors.fill: parent; onClicked: Quickshell.execDetached(["pwvucontrol"]) }
                }
                Text {
                    text: "\uf011"
                    color: borderWindow.red
                    font.family: "JetBrainsMono Nerd Font Mono"
                    font.pixelSize: 10
                    verticalAlignment: Text.AlignVCenter
                    height: borderWindow.contentHeight
                    MouseArea {
                        anchors.fill: parent
                        onClicked: Quickshell.execDetached(["bash", "/etc/quickshell/scripts/power.sh"])
                    }
                }
            }
        }
    }
  '';

  notificationsQml = pkgs.writeText "Notifications.qml" ''
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
  '';

  powerSh = pkgs.writeShellScript "power.sh" ''
    zenity --question \
      --title="Power" \
      --text="Done with work?" \
      --ok-label="Yes" \
      --cancel-label="No" \
      --width=260 2>/dev/null

    [ $? -ne 0 ] && exit 0

    ACTION=$(zenity --list \
      --title="Power" \
      --text="Goodbye, $USER" \
      --column="Action" \
      --hide-header \
      --width=260 --height=220 \
      "Shutdown" "Restart" "Switch to Windows" "Cancel" 2>/dev/null)

    case "$ACTION" in
      "Shutdown")          systemctl poweroff ;;
      "Restart")           systemctl reboot ;;
      "Switch to Windows") sudo grub-reboot "Windows Boot Manager (on /dev/nvme0n1p1)" && systemctl reboot ;;
      "Cancel"|"")         exit 0 ;;
    esac
  '';
  # ── hyprpaper.conf ──────────────────────────────────────────────────────────
  # Wallpaper: ~/Pictures/wallpapers/gruv-portal-cake.png
  # Stowed from dotfiles/wallpaper/Pictures/wallpapers/gruv-portal-cake.png
  # Empty monitor = fallback — applies to all 3 displays
  hyprpaperConf = pkgs.writeText "hyprpaper.conf" ''
    splash = false
    wallpaper {
        monitor  =
        path     = /home/n0xtcy/Pictures/wallpapers/gruv-portal-cake.png
        fit_mode = cover
    }
  '';

  gtk3Ini = pkgs.writeText "gtk3-settings.ini" ''
    [Settings]
    gtk-theme-name=Gruvbox-Dark
    gtk-icon-theme-name=Adwaita
    gtk-font-name=JetBrainsMono Nerd Font Mono 10
    gtk-cursor-theme-name=MyCursor
    gtk-cursor-theme-size=32
    gtk-application-prefer-dark-theme=1
  '';

  gtk4Ini = pkgs.writeText "gtk4-settings.ini" ''
    [Settings]
    gtk-theme-name=Gruvbox-Dark
    gtk-icon-theme-name=Adwaita
    gtk-font-name=JetBrainsMono Nerd Font Mono 10
    gtk-cursor-theme-name=MyCursor
    gtk-cursor-theme-size=32
    gtk-application-prefer-dark-theme=1
  '';

in
{
  imports = [
    ./hardware-configuration.nix
    ./dashboard.nix  
];
  # ── Boot ────────────────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = false;
  boot.loader.timeout = -1;              # menu waits forever, no auto-boot
  boot.loader.grub = {
    enable      = true;
    efiSupport  = true;
    devices     = [ "nodev" ];           # UEFI: GRUB doesn't write to a raw disk
    useOSProber = true;                  # scans nvme0n1p1 for Windows's bootloader
    splashImage = null;                  # strips NixOS's default themed background
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  # ── Networking ───────────────────────────────────────────────────────────────
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # ── Autologin ─────────────────────────────────────────────────────────────
  services.getty.autologinUser = "n0xtcy";

  # ── Locale & Time ───────────────────────────────────────────────────────────
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT    = "de_DE.UTF-8";
    LC_MONETARY       = "de_DE.UTF-8";
    LC_NAME           = "de_DE.UTF-8";
    LC_NUMERIC        = "de_DE.UTF-8";
    LC_PAPER          = "de_DE.UTF-8";
    LC_TELEPHONE      = "de_DE.UTF-8";
    LC_TIME           = "de_DE.UTF-8";
  };
  console.keyMap = "de";

  # ── Nix settings ─────────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ── Shell ────────────────────────────────────────────────────────────────────
  programs.zsh = {
    enable = true;

    # shellInit → /etc/zshenv — sourced by ALL shells (interactive, non-interactive, scripts)
    # PATH exports live here so they're available everywhere
    shellInit = ''
      # bun
      export PATH="/home/n0xtcy/.cache/.bun/bin:$PATH"

      # pi-node (bun global pi runner)
      export PATH="/home/n0xtcy/.local/share/pi-node/node-v22.22.3-linux-x64/bin:$PATH"
      export PATH="$HOME/.local/share/npm-global/bin:$PATH"

      # uv / local bin
      export PATH="/home/n0xtcy/.local/share/../bin:$PATH"
      export PATH="$HOME/.local/bin:$PATH"
    '';

    shellAliases = {
      # nixconfig: edit config then immediately rebuild — preserved exactly
      nixconfig  = "sudo nano /etc/nixos/configuration.nix && sudo nixos-rebuild switch";

      # Screenshots — grim+slurp (Wayland, replaces maim+xsel)
      screenshot = ''grim -g "$(slurp)" - | wl-copy'';

      # Clipboard
      copy  = "wl-copy";
      paste = "wl-paste";

      # eza — replaces ls
      ls = "eza --icons";
      ll = "eza -la --icons";

      # ollama
      qwen = "ollama run qwen2.5-coder:14b";

      # AI web apps — open as Chrome PWA windows
      claude    = "setsid google-chrome-stable --app=https://claude.ai/new &>/dev/null &";
      gemini    = "setsid google-chrome-stable --app=https://gemini.google.com/ &>/dev/null &";
      chatgpt   = "setsid google-chrome-stable --app=https://chatgpt.com/ &>/dev/null &";
      openwebui = "setsid google-chrome-stable --app=http://localhost:8080/ &>/dev/null &";
    };

    # interactiveShellInit → /etc/zshrc — sourced only by interactive shells
    interactiveShellInit = ''
      # bat
      export BAT_THEME="gruvbox-dark"

      # fzf
      export FZF_DEFAULT_OPTS="
        --color=bg+:#3c3836,bg:#1d2021,spinner:#fb4934,hl:#928374
        --color=fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934
        --color=marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934"

      # pi() — run pi via bun
      pi() { bun run pi "$@"; }

      # ── Alias helpers ──────────────────────────────────────────────────────────
      addalias()    { echo "alias $1='$2'" >> ~/.zshrc && builtin alias "$1"="$2"; }
      removealias() { sed -i "/^alias $1=/d" ~/.zshrc && unalias "$1" 2>/dev/null; }
      listalias()   { grep "^alias" ~/.zshrc; }
    '';

    loginShellInit = ''
      # Symlink hyprland.lua from Nix store into user config (idempotent)
      if [ ! -L "$HOME/.config/hypr/hyprland.lua" ]; then
        mkdir -p "$HOME/.config/hypr"
        ln -sf /etc/hypr/hyprland.lua "$HOME/.config/hypr/hyprland.lua"
      fi
      # Symlink hyprpaper.conf (idempotent)
      if [ ! -L "$HOME/.config/hypr/hyprpaper.conf" ]; then
        mkdir -p "$HOME/.config/hypr"
        ln -sf /etc/hypr/hyprpaper.conf "$HOME/.config/hypr/hyprpaper.conf"
      fi
if [ ! -L "$HOME/.config/foot/foot.ini" ]; then
        mkdir -p "$HOME/.config/foot"
        ln -sf /etc/foot/foot.ini "$HOME/.config/foot/foot.ini"
      fi
if [ ! -L "$HOME/.config/quickshell/shell.qml" ]; then
        mkdir -p "$HOME/.config/quickshell/scripts"
        ln -sf /etc/quickshell/shell.qml "$HOME/.config/quickshell/shell.qml"
        ln -sf /etc/quickshell/Border.qml "$HOME/.config/quickshell/Border.qml"
        ln -sf /etc/quickshell/Notifications.qml "$HOME/.config/quickshell/Notifications.qml"
        ln -sf /etc/quickshell/scripts/power.sh "$HOME/.config/quickshell/scripts/power.sh"
      fi
      # Ensure wallpaper dir exists (stow populates it)
      mkdir -p "$HOME/Pictures/wallpapers"
      # GTK theming — symlink settings from /etc into ~/.config
      if [ ! -L "$HOME/.config/gtk-3.0/settings.ini" ]; then
        mkdir -p "$HOME/.config/gtk-3.0"
        ln -sf /etc/gtk-3.0/settings.ini "$HOME/.config/gtk-3.0/settings.ini"
      fi
      if [ ! -L "$HOME/.config/gtk-4.0/settings.ini" ]; then
        mkdir -p "$HOME/.config/gtk-4.0"
        ln -sf /etc/gtk-4.0/settings.ini "$HOME/.config/gtk-4.0/settings.ini"
      fi
      # Dark mode — sets system color scheme for Chrome, GTK apps, etc.
      gsettings set org.gnome.desktop.interface color-scheme prefer-dark
      gsettings set org.gnome.desktop.interface gtk-theme Gruvbox-Dark

      # Launch Hyprland via UWSM on TTY1 (no display manager)
      if [ -z "''${WAYLAND_DISPLAY:-}" ] && [ "''${XDG_VTNR:-}" = "1" ]; then
        exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };

  programs.starship.enable = true;

  # ── User ─────────────────────────────────────────────────────────────────────
  users.users."n0xtcy" = {
    isNormalUser = true;
    shell        = pkgs.zsh;
    description  = "n0xtcy";
    extraGroups  = [ "wheel" "networkmanager" "video" "audio" "docker" ];
    packages     = [];
  };

  # ── Hyprland ─────────────────────────────────────────────────────────────────
  # programs.hyprland enables: polkit, xdg-desktop-portal-hyprland, graphics
  # drivers, fonts, dconf, xwayland, desktop session entry.
  # withUWSM = true: UWSM handles systemd targets, dbus env, portal startup.
  programs.hyprland = {
    enable          = true;
    withUWSM        = true;
    xwayland.enable = true;
  };

  # Deploy configs to /etc/hypr/ — symlinked into ~/.config/hypr/ on login
  environment.etc."hypr/hyprland.lua".source   = hyprlandLua;
  environment.etc."hypr/hyprpaper.conf".source = hyprpaperConf;
  environment.etc."foot/foot.ini".source = footIni;
  environment.etc."quickshell/shell.qml".source = shellQml;
  environment.etc."quickshell/Border.qml".source = borderQml;
  environment.etc."quickshell/Notifications.qml".source = notificationsQml;
  environment.etc."quickshell/scripts/power.sh".source = powerSh;
  environment.etc."gtk-3.0/settings.ini".source = gtk3Ini;
  environment.etc."gtk-4.0/gtk.css".source = "${pkgs.gruvbox-gtk-theme}/share/themes/Gruvbox-Dark/gtk-4.0/gtk.css";
  environment.etc."gtk-4.0/gtk-dark.css".source = "${pkgs.gruvbox-gtk-theme}/share/themes/Gruvbox-Dark/gtk-4.0/gtk-dark.css";
  environment.etc."gtk-4.0/assets".source = "${pkgs.gruvbox-gtk-theme}/share/themes/Gruvbox-Dark/gtk-4.0/assets";
  # ── NVIDIA ───────────────────────────────────────────────────────────────────
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable     = true;
    open                   = false;
    powerManagement.enable = false;
  };
  hardware.graphics.enable   = true;
  nixpkgs.config.allowUnfree = true;  # NVIDIA + google-chrome + vscode
  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-10.29.2"
  ];

  # ── Sound ────────────────────────────────────────────────────────────────────
  services.pipewire = {
    enable            = true;
    alsa.enable       = true;
    alsa.support32Bit = true;
    pulse.enable      = true;
  };
  security.rtkit.enable = true;

  # ── Bluetooth ────────────────────────────────────────────────────────────────
  # Required for blueberry (QS bar BT icon click)
  hardware.bluetooth.enable      = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable        = true;

  # ── Virtualisation ───────────────────────────────────────────────────────────
  virtualisation.docker.enable = true;

  # ── Packages ─────────────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [

    # nixman — pacman-style package manager wrapper (preserved exactly)
    (pkgs.writeShellScriptBin "nixman" ''
      usage() {
        echo "nixman — pacman-style NixOS package manager"
        echo ""
        echo "  nixman -S <pkg>    install package"
        echo "  nixman -R <pkg>    remove package"
        echo "  nixman -Syu        update everything"
        echo "  nixman -Ss <pkg>   search packages"
        echo "  nixman -Q          list installed packages"
        echo "  nixman -Sc         clean old generations"
      }

      case "$1" in
        -S)
          pkg=$2
          if [ -z "$pkg" ]; then echo "Usage: nixman -S <package>"; exit 1; fi
          sudo sed -i "s|  vesktop
    # END PACKAGES|  $pkg\n    # END PACKAGES|" /etc/nixos/configuration.nix
          sudo nixos-rebuild switch
          ;;
        -R)
          pkg=$2
          if [ -z "$pkg" ]; then echo "Usage: nixman -R <package>"; exit 1; fi
          sudo sed -i "/^    $pkg$/d" /etc/nixos/configuration.nix
          sudo nixos-rebuild switch
          ;;
        -Syu)
          sudo nix-channel --update
          sudo nixos-rebuild switch --upgrade
          ;;
        -Ss)
          pkg=$2
          if [ -z "$pkg" ]; then echo "Usage: nixman -Ss <package>"; exit 1; fi
          nix search nixpkgs "$pkg" 2>/dev/null
          ;;
        -Q)
          sed -n '/# window manager/,/  vesktop
    # END PACKAGES/p' /etc/nixos/configuration.nix \
            | grep -E '^\s+[a-z][a-zA-Z0-9_-]+$' \
            | grep -v -E '^\s+(usage|esac|esac|sudo|nix|echo|grep|sed|pkg|case)' \
            | sed 's/^[[:space:]]*/  /'
          ;;
        -Sc)
          echo "Cleaning old generations..."
          sudo nix-collect-garbage -d
          sudo nixos-rebuild switch
          ;;
        *)
          usage
          ;;
      esac
    '')

    # theming
    adwaita-icon-theme
    gruvbox-gtk-theme

    # window manager / Wayland ecosystem
    foot       # terminal (replaces alacritty)
    fuzzel     # launcher (replaces dmenu)
    quickshell # qs bar: shell.qml → Border.qml + Notifications.qml
    hyprpaper  # wallpaper daemon

    # screenshot (Wayland — replaces maim)
    grim
    slurp
    jq         # window screenshot: extracts geometry from hyprctl activewindow -j

    # clipboard (Wayland — replaces xsel)
    wl-clipboard  # wl-copy / wl-paste
    cliphist      # clipboard history → Super+V → fuzzel dmenu

    # quickshell bar click targets
    wlogout              # power menu
    zenity               # confirm dialogs for wlogout flow
    pwvucontrol          # pipewire volume control
    blueman              # bluetooth manager (blueberry removed from nixpkgs 26.05)
    gnome-calendar       # calendar
    networkmanagerapplet # nm-connection-editor (wifi)
    # tomatillo — AUR only, not in nixpkgs. Clock click does nothing until installed.
    #             Fallback: nixman -S gnome-clocks

    # browser
    google-chrome

    # chat
    vesktop
    # END PACKAGES

    # terminal tools (used in .zshrc)
    eza      # ls/ll aliases
    bat      # BAT_THEME=gruvbox-dark
    fzf      # FZF_DEFAULT_OPTS set in zshrc

    # file manager (GUI — Wayland-compatible, xdg file picker for Chrome uploads)
    thunar

    # dotfile management
    stow

    # audio
    pavucontrol

    # network
    curl

    # shell
    zsh
    fastfetch

    # git
    git

    # editor
    vscode
  ];

  # ── Security / portals ───────────────────────────────────────────────────────
  security.polkit.enable = true;
  xdg.portal.enable      = true;
  # xdg-desktop-portal-hyprland added automatically by programs.hyprland

  # ── Fonts ────────────────────────────────────────────────────────────────────
  # JetBrainsMono Nerd Font: foot.ini, fuzzel.ini, quickshell bar
  # Font Awesome: quickshell bar icons (wifi \uf1eb, BT \uf294, vol \uf028, power \uf011)
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
    noto-fonts
    noto-fonts-color-emoji
  ];

  hardware.bluetooth.settings = {
    Policy.AutoEnable = true;
    General.FastConnectable = true;
  };

  systemd.services.bluetooth-autoconnect = {
    description = "Bluetooth auto-connect trusted devices";
    after = [ "bluetooth.service" ];
    wants = [ "bluetooth.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = pkgs.writeShellScript "bt-connect" ''
        ${pkgs.bluez}/bin/bluetoothctl power on
        for dev in $(${pkgs.bluez}/bin/bluetoothctl devices Trusted | awk '{print $2}'); do
          ${pkgs.bluez}/bin/bluetoothctl connect "$dev" || true
        done
      '';
    };
  };

  security.sudo.extraRules = [
    {
      users = [ "n0xtcy" ];
      commands = [{
        command = "/run/current-system/sw/bin/grub-reboot";
        options = [ "NOPASSWD" ];
      }];
    }
  ];

    system.stateVersion = "26.05";
}
