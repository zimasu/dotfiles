#!/bin/bash
CHOICE=$(hyprland-dialog --title "Done with work?" --text "Goodbye, $USER" --buttons "Shutdown;Restart;Cancel")
case "$CHOICE" in
    Shutdown) systemctl poweroff ;;
    Restart)  systemctl reboot ;;
    Cancel)   ;;
esac
