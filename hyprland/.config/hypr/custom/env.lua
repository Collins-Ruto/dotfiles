-- hl.env("QT_QPA_PLATFORMTHEME", "qt5ct;kde")

-- Force unified Qt theme management
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
-- hl.env("QT_STYLE_OVERRIDE", "kvantum")

-- Trick KDE settings tools to open properly in Hyprland
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

-- Java font fixes
hl.env("_JAVA_OPTIONS", "-Dawt.useSystemAAFontSettings=lcd -Dswing.aatext=true")
