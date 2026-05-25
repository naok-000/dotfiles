local wezterm = require("wezterm")

local M = {
	color_scheme = "Catppuccin Mocha",
	palette = {},
}

local function palette_from_scheme(scheme)
	return {
		bg = scheme.background,
		surface = scheme.ansi[8],
		surface_hover = scheme.brights[8],
		text = scheme.foreground,
		subtext = scheme.brights[7],
		accent = scheme.ansi[5],
		warning = scheme.brights[2],
		success = scheme.ansi[3],
	}
end

function M.apply(config)
	local scheme = wezterm.color.get_builtin_schemes()[M.color_scheme]

	if scheme == nil then
		error("unknown wezterm color scheme: " .. M.color_scheme)
	end

	M.palette = palette_from_scheme(scheme)
	config.color_scheme = M.color_scheme
end

return M
