local wezterm = require("wezterm")

local M = {}
local window_modes = {}

local function push_segment(palette, cells, background, foreground, text)
	table.insert(cells, { Background = { Color = palette.bg } })
	table.insert(cells, { Foreground = { Color = background } })
	table.insert(cells, { Text = "" })
	table.insert(cells, { Background = { Color = background } })
	table.insert(cells, { Foreground = { Color = foreground } })
	table.insert(cells, { Text = text })
	table.insert(cells, { Background = { Color = palette.bg } })
	table.insert(cells, { Foreground = { Color = background } })
	table.insert(cells, { Text = "" })
end

function M.apply(_, palette)
	wezterm.on("format-tab-title", function(tab, _, _, _, hover)
		local background = palette.surface
		local foreground = palette.subtext

		if tab.is_active then
			background = palette.mauve
			foreground = palette.bg
		elseif hover then
			background = palette.surface_hover
			foreground = palette.text
		end

		local title = string.format(" %d ", tab.tab_index + 1)
		local active_key_table = window_modes[tab.window_id]

		if tab.is_active and active_key_table == "resize_pane" then
			title = string.format(" RESIZE %d ", tab.tab_index + 1)
		end

		return {
			{ Background = { Color = palette.bg } },
			{ Foreground = { Color = background } },
			{ Text = "" },
			{ Background = { Color = background } },
			{ Foreground = { Color = foreground } },
			{ Text = title },
			{ Background = { Color = palette.bg } },
			{ Foreground = { Color = background } },
			{ Text = "" },
		}
	end)

	wezterm.on("update-status", function(window, _)
		local cells = {}
		local active_key_table = window:active_key_table()
		window_modes[window:window_id()] = active_key_table

		if window:leader_is_active() then
			push_segment(palette, cells, palette.peach, palette.bg, " PREFIX ")
		end

		if active_key_table == "resize_pane" then
			push_segment(palette, cells, palette.green, palette.bg, " RESIZE ")
		elseif active_key_table == "copy_mode" then
			push_segment(palette, cells, palette.mauve, palette.bg, " COPY ")
		elseif active_key_table == "search_mode" then
			push_segment(palette, cells, palette.surface_hover, palette.text, " SEARCH ")
		end

		window:set_right_status(wezterm.format(cells))
	end)
end

return M
