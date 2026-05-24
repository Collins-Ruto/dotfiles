-- Global Config: Input, Visuals, and XWayland Compatibility
hl.config({
	general = {
		border_size = 0,
	},

	input = {
		-- Sensitivity ranges from -1.0 to 1.0. 0 means no modification.
		sensitivity = 0.3,
		-- Disable mouse acceleration for raw, predictable muscle memory
		accel_profile = "adaptive",
	},

	decoration = {
		-- 2 = circle, higher = squircle, 4 = very obvious squircle
		-- Fuck clearly visible squircles. 100% Apple brainrot.
		rounding_power = 2.5,
		rounding = 10,
	},

	xwayland = {
		-- Prevents pixelation on HiDPI setups by turning off X11 scaling
		force_zero_scaling = true,
	},
})
