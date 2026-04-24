local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

local resize_amount = 3
local resize_mode = "resize_pane"
local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function is_vim(pane)
	return pane:get_user_vars().IS_NVIM == "true"
end

local function foreground_process_name(pane)
	local process = pane:get_foreground_process_name()

	if process == nil then
		return nil
	end

	return process:match("([^/\\]+)$")
end

local function is_tmux(pane)
	return foreground_process_name(pane) == "tmux"
end

local function smart_navigate(key)
	local direction = direction_keys[key]

	return wezterm.action_callback(function(window, pane)
		if is_vim(pane) or is_tmux(pane) then
			window:perform_action(act.SendKey({ key = key, mods = "CTRL|ALT" }), pane)
			return
		end

		window:perform_action(act.ActivatePaneDirection(direction), pane)
	end)
end

local function resize(direction)
	return act.AdjustPaneSize({ direction, resize_amount })
end

local function activate_resize_mode()
	return wezterm.action_callback(function(window, pane)
		window:perform_action(
			act.ActivateKeyTable({
				name = resize_mode,
				one_shot = false,
				timeout_milliseconds = 2000,
				until_unknown = true,
			}),
			pane
		)
		window:toast_notification("WezTerm", "Resize mode: h/j/k/l, Esc/Enter/q to exit", nil, 1500)
	end)
end

local function close_copy_mode()
	return act.CopyMode("Close")
end

local function copy_selection_and_close()
	return act.Multiple({
		act.CopyTo("ClipboardAndPrimarySelection"),
		act.CopyMode("Close"),
	})
end

function M.apply(config)
	config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 1000 }
	config.keys = {
		{
			key = "Enter",
			mods = "SHIFT",
			action = act.SendString("\n"),
		},
		{
			key = "v",
			mods = "LEADER",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "s",
			mods = "LEADER",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "[",
			mods = "LEADER",
			action = act.ActivateCopyMode,
		},
		{
			key = "e",
			mods = "LEADER",
			action = activate_resize_mode(),
		},
		{
			key = "z",
			mods = "LEADER",
			action = act.TogglePaneZoomState,
		},
		{
			key = "q",
			mods = "LEADER",
			action = act.CloseCurrentPane({ confirm = true }),
		},
		{
			key = "r",
			mods = "LEADER",
			action = act.ReloadConfiguration,
		},
		{
			key = "h",
			mods = "CTRL|ALT",
			action = smart_navigate("h"),
		},
		{
			key = "j",
			mods = "CTRL|ALT",
			action = smart_navigate("j"),
		},
		{
			key = "k",
			mods = "CTRL|ALT",
			action = smart_navigate("k"),
		},
		{
			key = "l",
			mods = "CTRL|ALT",
			action = smart_navigate("l"),
		},
	}

	config.key_tables = {
		resize_pane = {
			{ key = "h", mods = "NONE", action = resize("Left") },
			{ key = "j", mods = "NONE", action = resize("Down") },
			{ key = "k", mods = "NONE", action = resize("Up") },
			{ key = "l", mods = "NONE", action = resize("Right") },
			{ key = "Escape", mods = "NONE", action = "PopKeyTable" },
			{ key = "Enter", mods = "NONE", action = "PopKeyTable" },
			{ key = "q", mods = "NONE", action = "PopKeyTable" },
		},
		copy_mode = {
			{ key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },
			{ key = "Escape", mods = "NONE", action = close_copy_mode() },
			{ key = "Space", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
			{ key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
			{ key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
			{ key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
			{ key = "/", mods = "NONE", action = act.Search("CurrentSelectionOrEmptyString") },
			{ key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
			{ key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
			{ key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
			{ key = "F", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
			{ key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
			{ key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
			{ key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
			{ key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
			{ key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
			{ key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
			{ key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
			{ key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
			{ key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
			{ key = "O", mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
			{ key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
			{ key = "T", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
			{ key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
			{ key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
			{ key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
			{ key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
			{ key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
			{ key = "b", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
			{ key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
			{ key = "c", mods = "CTRL", action = close_copy_mode() },
			{ key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
			{ key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
			{ key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
			{ key = "f", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
			{ key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
			{ key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
			{ key = "g", mods = "CTRL", action = close_copy_mode() },
			{ key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
			{ key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
			{ key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
			{ key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
			{ key = "m", mods = "ALT", action = act.CopyMode("MoveToStartOfLineContent") },
			{ key = "n", mods = "NONE", action = act.CopyMode("NextMatch") },
			{ key = "N", mods = "SHIFT", action = act.CopyMode("PriorMatch") },
			{ key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
			{ key = "q", mods = "NONE", action = close_copy_mode() },
			{ key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
			{ key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
			{ key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
			{ key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
			{ key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
			{ key = "y", mods = "NONE", action = copy_selection_and_close() },
			{ key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
			{ key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
			{ key = "End", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
			{ key = "Home", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
			{ key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
			{ key = "LeftArrow", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
			{ key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
			{ key = "RightArrow", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
			{ key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
			{ key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
		},
		search_mode = {
			{ key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
			{ key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
			{ key = "n", mods = "NONE", action = act.CopyMode("NextMatch") },
			{ key = "N", mods = "SHIFT", action = act.CopyMode("PriorMatch") },
			{ key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
			{ key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
			{ key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
			{ key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
			{ key = "PageUp", mods = "NONE", action = act.CopyMode("PriorMatchPage") },
			{ key = "PageDown", mods = "NONE", action = act.CopyMode("NextMatchPage") },
			{ key = "UpArrow", mods = "NONE", action = act.CopyMode("PriorMatch") },
			{ key = "DownArrow", mods = "NONE", action = act.CopyMode("NextMatch") },
		},
	}
end

return M
