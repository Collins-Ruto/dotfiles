require("full-border"):setup({
	type = ui.Border.ROUNDED, -- Tells Yazi to look for corner structures
})

require("githead"):setup({
	branch_prefix = "on",
	branch_symbol = " ",
	branch_borders = "()",
})

require("fg"):setup({
	default_action = "menu", -- nvim, jump
})

Status:children_add(function(self)
	local h = self._current.hovered
	if h and h.link_to then
		return " -> " .. tostring(h.link_to)
	else
		return ""
	end
end, 3300, Status.LEFT)
