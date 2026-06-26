local mod = "SUPER"

-- Core System & App Launchers
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + Q",      hl.dsp.window.close())
hl.bind(mod .. " + M",      hl.dsp.exit())
hl.bind(mod .. " + D",      hl.dsp.exec_cmd("fuzzel"))
hl.bind(mod .. " + B",      hl.dsp.exec_cmd("google-chrome-stable"))

-- Clipboard Management Interaction
hl.bind(mod .. " + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))

-- Screenshot Controls (Hyprshot Engine)
hl.bind(mod .. " + L",            hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mod .. " + SHIFT + L",    hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mod .. " + CTRL + L",     hl.dsp.exec_cmd("hyprshot -m output"))

-- Audio Hardware Controls
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"))
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))

-- Window Management Mouse Drag Actions
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), "mouse")
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), "mouse")
