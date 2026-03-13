-- Auto-start applications (exec-once semantics)
-- Runs once on Hyprland start, not on reload

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=Hyprland")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user restart xdg-desktop-portal")
    hl.exec_cmd("systemctl --user restart xdg-desktop-portal-hyprland")
end)
