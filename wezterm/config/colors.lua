local wezterm = require("wezterm")

local M = {
	palette = {
		bg = "#090b10",
		surface = "#141824",
		surface_hover = "#1b2030",
		overlay = "#6c7086",
		text = "#cdd6f4",
		subtext = "#a6adc8",
		mauve = "#cba6f7",
		peach = "#fab387",
		green = "#a6e3a1",
	},
}

function M.apply(config)
	local custom = wezterm.color.get_builtin_schemes()["Catppuccin Mocha"]
	custom.background = M.palette.bg
	custom.selection_bg = "#3d355f"
	custom.tab_bar.background = M.palette.bg
	custom.tab_bar.active_tab.bg_color = M.palette.mauve
	custom.tab_bar.active_tab.fg_color = M.palette.bg
	custom.tab_bar.inactive_tab.bg_color = M.palette.surface
	custom.tab_bar.inactive_tab.fg_color = M.palette.subtext
	custom.tab_bar.inactive_tab_hover.bg_color = M.palette.surface_hover
	custom.tab_bar.inactive_tab_hover.fg_color = M.palette.text

	config.color_schemes = {
		OLEDppuccin = custom,
	}
	config.color_scheme = "OLEDppuccin"
end

return M
