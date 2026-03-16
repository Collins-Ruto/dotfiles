-- Keybinds Configuration
-- Official Wiki Specification: https://wiki.hypr.land/Configuring/Basics/Binds/
local runner = "~/.config/rofi/launchers/type-6/runner.sh"

local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local secondMod = "SUPER + SHIFT" -- Sets "Windows" + "SHIFT" key as second modifier

-- Unbinds
hl.unbind("SUPER + O")
hl.unbind("SUPER + W")

-- ── Launcher ─────────────────────────────────────────────────────────────────

-- This natively catches a clean tap/release of the SUPER key instantly
hl.bind("SUPER + SUPER_L", hl.dsp.exec_cmd("~/.config/rofi/launchers/type-6/launcher.sh"))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(runner))
-- Toggle window maximization
hl.bind(secondMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

-- ── Terminal ──────────────────────────────────────────────────────────────────
hl.bind("SUPER + Return", hl.dsp.exec_cmd("foot")) -- [hidden]

-- ── Apps ──────────────────────────────────────────────────────────────────────
hl.bind("SUPER + O", hl.dsp.exec_cmd("obsidian"), { description = "Launch Obsidian" })
hl.bind("SUPER + M", hl.dsp.exec_cmd("tauon"), { description = "Launch Tauon" })
hl.bind("SUPER + R", hl.dsp.exec_cmd("foot -e nvim"), { description = "Launch nvim in foot" })
hl.bind("SUPER + ALT + E", hl.dsp.exec_cmd("thunar")) -- [hidden]
hl.bind("SUPER + W", hl.dsp.exec_cmd([[brave || google-chrome-stable || firefox]])) -- [hidden]
hl.bind("SUPER + F3", hl.dsp.exec_cmd("foot -e cheat"))

-- ── Workspace Switching (Loops) ───────────────────────────────────────────────

-- Relative Switching Navigation
local keys = { "Left", "Right" }
local prefix = { "r-", "r+" }
local descdir = { "left", "right" }
for i = 1, 2 do -- Adjusted to 1, 2 loop range to capture both directions
	hl.bind(
		"CTRL + SUPER + " .. keys[i],
		hl.dsp.focus({ workspace = prefix[i] .. "2" }),
		{ description = "Workspace: Focus " .. descdir[i] }
	)
end

-- Monitored-Relative Switching
local m_prefix = { "m-", "m+" }
for i = 1, 2 do
	hl.bind("CTRL + SUPER + ALT + " .. keys[i], hl.dsp.focus({ workspace = m_prefix[i] .. "2" }))
end

-- Page Up / Page Down Multi-Mapping
local page_keys = { "SUPER + Page_Down", "SUPER + Page_Up" }
local keycombos = { page_keys[2], page_keys[2], "CTRL + " .. page_keys[1], "CTRL + " .. page_keys[2] }
local r_prefix = { "r+", "r-", "r+", "r-" }
for i = 1, 4 do
	hl.bind(keycombos[i], hl.dsp.focus({ workspace = r_prefix[i] .. "2" }))
end

-- Tab & Grave Cycle Mechanics (Corrected String to Table format)
hl.bind("SUPER + Tab", hl.dsp.focus({ workspace = "previous" })) -- [hidden]
hl.bind("SUPER + GRAVE", hl.dsp.focus({ workspace = "m+2" })) -- [hidden]
hl.bind("SUPER + SHIFT + Tab", hl.dsp.focus({ workspace = "m0" })) -- [hidden]

-- ── Window Cycling (Chained Actions via Anonymous Function) ───────────────────
hl.bind("ALT + Tab", function()
	hl.dispatch(hl.dsp.layout("cyclenext")) -- Shifts target pointer context
	hl.dispatch(hl.dsp.window.alter_zorder({ action = "top" })) -- Forces focused asset window elevation
end)
