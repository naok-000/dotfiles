local wezterm = require("wezterm")

local M = {
	color_scheme = "Modus-Operandi-Tinted",
	-- color_scheme = "Solarized Light (Gogh)",
	-- color_scheme = "Solarized (light) (terminal.sexy)",
	palette = {},
}

local function first(...)
	for i = 1, select("#", ...) do
		local value = select(i, ...)
		if value then
			return value
		end
	end
end

local function palette_from_scheme(scheme)
	return {
		bg = scheme.background,
		tab_bar = scheme.background,
		surface = scheme.ansi[8],
		surface_hover = first(scheme.selection_bg, scheme.brights[8], scheme.ansi[8]),
		active_tab = first(scheme.selection_bg, scheme.brights[8], scheme.ansi[8]),
		active_tab_text = scheme.foreground,
		text = scheme.foreground,
		subtext = first(scheme.brights[8], scheme.ansi[8], scheme.foreground),
		accent = scheme.ansi[5],
		warning = scheme.brights[2],
		success = scheme.ansi[3],
	}
end

local function apply_tab_bar_colors(config, palette)
	config.colors = config.colors or {}
	config.colors.tab_bar = {
		background = palette.tab_bar,
		active_tab = {
			bg_color = palette.active_tab,
			fg_color = palette.active_tab_text,
			intensity = "Bold",
		},
		inactive_tab = {
			bg_color = palette.surface,
			fg_color = palette.subtext,
		},
		inactive_tab_hover = {
			bg_color = palette.surface_hover,
			fg_color = palette.text,
		},
		new_tab = {
			bg_color = palette.tab_bar,
			fg_color = palette.subtext,
		},
		new_tab_hover = {
			bg_color = palette.surface_hover,
			fg_color = palette.text,
		},
	}
end

function M.apply(config)
	local scheme = wezterm.color.get_builtin_schemes()[M.color_scheme]

	if scheme == nil then
		error("unknown wezterm color scheme: " .. M.color_scheme)
	end

	M.palette = palette_from_scheme(scheme)
	config.color_scheme = M.color_scheme
	apply_tab_bar_colors(config, M.palette)
end

return M
