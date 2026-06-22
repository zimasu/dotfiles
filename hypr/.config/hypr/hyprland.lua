-- =============================================================================
-- hyprland.lua — n0xtcy's Hyprland config
-- Hyprland version: 0.55.x (Lua config — hyprlang .conf is DEPRECATED)
-- Last verified: June 2026
--
-- AI SYNTAX NOTES (read this before editing):
--    - Config format changed from hyprlang (.conf) to Lua (.lua) in v0.55
--    - hyprlang will be removed in a future release — do NOT revert to .conf
--    - Wiki: https://wiki.hypr.land/Configuring/Start/
--    - Breaking changes: https://github.com/hyprwm/Hyprland/releases
--    - If something stops working after yay -Syu, CHECK RELEASE NOTES FIRST
--    - THIS .lua IS THE ONLY ACTIVE CONFIG. hyprland.conf (if it still exists)
--      is dead and ignored. Do not edit it, do not recreate it.
--    - Border setup: DO NOT use monitor reserved_area for the quickshell border.
--      reserved_area shrinks layer-shell surfaces too, pushing the border's
--      OWN decoration inward and creating a visible double-border artifact.
--      Use a workspace-scoped gaps_out instead (see below) — it only affects
--      tiled window geometry, leaving quickshell's full-screen overlay alone.
--    - DP-1 gaps use TWO MUTUALLY EXCLUSIVE workspace_rule selectors, NOT an
--      hl.on("window.open"/"window.close", ...) event handler. There is no
--      event handler in this file for gaps — don't add one, don't look for one.
--      w[tv1]   = exactly 1 tiled window  -> flush to border (gaps_out 22/8/8/8, gaps_in 0)
--      w[t2-99] = 2 to 99 tiled windows   -> pulled in from border (gaps_out 30/16/16/16, gaps_in 4)
--      These two selectors can NEVER both match at once (1 window vs 2-99 windows
--      are disjoint), so Hyprland just re-evaluates which one currently matches —
--      there is no override/handoff between rules on the 1<->2 window transition.
--      WHY THIS MATTERS: Hyprland has/had a prop-refresh bug (hyprwm/Hyprland
--      discussion #14233, fixed by PR #14349 in v0.55.0) where OVERRIDE-style
--      workspace rules (one broad rule + one narrower rule canceling it out)
--      can go stale on window open/close — the gap doesn't update until you
--      drag a window or change focus. Disjoint selectors like w[tv1]/w[t2-99]
--      sidestep that bug class entirely because there's nothing to override.
--    - DO NOT "fix" this by adding a single overriding rule (e.g. one rule for
--      "m[DP-1]" plus a second narrower rule for "m[DP-1] w[tv1]" that cancels
--      it). That's the override pattern that caused the original bug. Keep the
--      w[tv1] / w[t2-99] split disjoint when editing these values.
--    - shadow offset intentionally left unset (defaults to 0 0) for perfect
--      symmetry on all 4 sides — don't add an offset, it breaks symmetry.
-- =============================================================================

-- MONITORS
-- Layout: DP-3 (left LG) | DP-1 (center MSI 240hz) | DP-2 (right LG)
hl.monitor({ output = "DP-3", mode = "1920x1080@60",  position = "0x0",   scale = 1 })
hl.monitor({ output = "DP-1", mode = "1920x1080@240", position = "1920x0", scale = 1 })
hl.monitor({ output = "DP-2", mode = "1920x1080@60",  position = "3840x0", scale = 1 })

-- WORKSPACE RULES
-- DP-1 (border monitor) uses two DISJOINT selectors — see header note above
-- for why this must stay disjoint and never become an override pair again.
--   m[DP-1] w[tv1]   = exactly 1 tiled window  -> flush to QS border (gaps_out 22/8/8/8, gaps_in 0)
--   m[DP-1] w[t2-99] = 2-99 tiled windows      -> shrink inward      (gaps_out 30/16/16/16, gaps_in 4)
-- DP-2/DP-3: no border overlay, always fill flush regardless of window count
hl.workspace_rule({ workspace = "m[DP-1] w[t2-99]", gaps_out = { top = 30, right = 16, bottom = 16, left = 16 }, gaps_in = 4 })
hl.workspace_rule({ workspace = "m[DP-1] w[tv1]",   gaps_out = { top = 22, right = 8,  bottom = 8,  left = 8  }, gaps_in = 0 })
hl.workspace_rule({ workspace = "m[DP-2]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "m[DP-3]", gaps_out = 0, gaps_in = 0 })

-- NVIDIA ENV VARS — remove if switching GPU
hl.env("LIBVA_DRIVER_NAME",         "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("GBM_BACKEND",               "nvidia-drm")
hl.env("NVD_BACKEND",               "direct")

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
        rounding     = 10,
        dim_inactive = false,
        dim_strength = 0,
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
        kb_layout = "de",
    },
    misc = {
        disable_splash_rendering = true,
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
    },
})

-- ANIMATIONS — Snappy, polished, optimized for high refresh rates (No workspace bloat)
hl.curve("snappy", { type = "bezier", points = { {0.16, 1}, {0.3, 1} } })

hl.animation({ leaf = "global",      enabled = true, speed = 3,   bezier = "snappy" })
hl.animation({ leaf = "windowsIn",   enabled = true, speed = 1.8, bezier = "snappy", style = "popin 90%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 1.2, bezier = "snappy", style = "popin 95%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2,   bezier = "snappy" })
hl.animation({ leaf = "layers",      enabled = true, speed = 2.2, bezier = "snappy", style = "slide" })
hl.animation({ leaf = "fade",        enabled = true, speed = 2.5, bezier = "snappy" })
hl.animation({ leaf = "border",      enabled = true, speed = 3,   bezier = "snappy" })

-- AUTOSTART
hl.on("hyprland.start", function()
    hl.exec_cmd("qs -c border")
    hl.exec_cmd("mako")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user start graphical-session.target")
    hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland")
end)

-- KEYBINDS
local mod = "SUPER"
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty"))
hl.bind(mod .. " + Q",      hl.dsp.window.close())
hl.bind(mod .. " + M",      hl.dsp.exit())
hl.bind(mod .. " + D",      hl.dsp.exec_cmd("fuzzel"))
hl.bind(mod .. " + B",      hl.dsp.exec_cmd("google-chrome-stable"))
hl.bind(mod .. " + V",      hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))
hl.bind(mod .. " + L",      hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind(mod .. " + SHIFT + L", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mod .. " + CTRL + L",  hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"))
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
