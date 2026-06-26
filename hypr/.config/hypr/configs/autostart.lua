hl.on("hyprland.start", function()
    -- Interactive Application Firewall Gatekeeper
    hl.exec_cmd("opensnitch-ui")
    
    -- Desktop Environment Core Services
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("quickshell") 
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'MyCursor'")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    
    -- XDG System Core Integrations
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user start graphical-session.target")
    hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland")
end)
