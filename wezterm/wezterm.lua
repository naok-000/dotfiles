local wezterm = require("wezterm")
local config = wezterm.config_builder()

local function load_module(name)
	return dofile(wezterm.config_dir .. "/config/" .. name .. ".lua")
end

local appearance = load_module("appearance")
local colors = load_module("colors")
local keys = load_module("keys")
local events = load_module("events")

appearance.apply(config)
colors.apply(config)
keys.apply(config)
events.apply(config, colors.palette)

return config
