local wezterm = require("wezterm")

local M = {}

function M.apply(config)
	config.use_ime = true
	config.font = wezterm.font_with_fallback({
		"UDEV Gothic 35NFLG",
		"JetBrainsMono Nerd Font Mono",
		"Noto Color Emoji",
		"Symbols Nerd Font Mono",
		"HackGen Console NF",
	})
	config.font_size = 16.0
	config.line_height = 1.1

	config.window_background_opacity = 0.92
	config.macos_window_background_blur = 28
	config.default_cursor_style = "SteadyBar"
	config.inactive_pane_hsb = {
		saturation = 0.92,
		brightness = 0.75,
	}

	config.use_fancy_tab_bar = false
	config.hide_tab_bar_if_only_one_tab = true
	config.tab_bar_at_bottom = true
	config.window_decorations = "RESIZE"
	config.show_new_tab_button_in_tab_bar = false
	config.status_update_interval = 100

	if wezterm.target_triple:find("darwin") then
		config.macos_forward_to_ime_modifier_mask = "SHIFT|CTRL"
	end
end

return M
