-- Window rules
-- https://wiki.hypr.land/Configuring/Basics/Window-Rules/

-- Cheatsheet float window
hl.window_rule({
	match = { class = "cheatsheet", title = "neutrino" },
	float = true,
	size = "900 600",
	center = true,
	border_size = 2,
})

-- Opacity rules
hl.window_rule({
	match = { class = "^(org.kde.dolphin)$" },
	opacity = "0.90 0.90",
})

hl.window_rule({
	match = { class = "^(org.gnome.Nautilus)$" },
	opacity = "0.90 0.90",
})

hl.window_rule({
	match = { class = "^(thunar)$" },
	opacity = "0.90 0.90",
})

hl.window_rule({
	match = { class = "^(brave)$|^(brave-browser)$" },
	opacity = "0.95 0.95 override",
})

hl.window_rule({
	match = { class = "^(obsidian)$" },
	opacity = "0.95 0.95",
})

hl.window_rule({
	match = { class = "^(rofi)$" },
	opacity = "0.90 0.90",
})
