-- Pull in the wezterm API
local wezterm = require("wezterm")
local mux = wezterm.mux

-- This will hold the configuration.
local config = wezterm.config_builder()

local function load_env(path)
	local home = os.getenv("HOME")
	local vars = {}
	local f = io.open(path, "r")
	if f then
		for line in f:lines() do
			local key, val = line:match("^([%w_]+)=(.-)%s*$")
			if key then
				vars[key] = val:gsub("^~", home)
			end
		end
		f:close()
	end
	return vars
end

local env = load_env(os.getenv("HOME") .. "/.wezterm.env")

local tab_colors = {
	Backend = "#444444",
	Web = "#048a81",
	["Persona/Cortex"] = "#8b5cf6",
	["Claude 1"] = "#ef3e36",
	["Claude 2"] = "#a11692",
	["Claude 3"] = "#246eb9",
}

local split_tabs = {
	{ name = "Backend", prefix = "BACKEND" },
	{ name = "Web", prefix = "WEB" },
	{ name = "Persona/Cortex", prefix = "PERSONA" },
}

local claude_tabs = { "Claude 1", "Claude 2", "Claude 3" }

local function darken(hex, factor)
	local r = tonumber(hex:sub(2, 3), 16)
	local g = tonumber(hex:sub(4, 5), 16)
	local b = tonumber(hex:sub(6, 7), 16)
	return string.format("#%02x%02x%02x",
		math.floor(r * factor),
		math.floor(g * factor),
		math.floor(b * factor))
end

wezterm.on("format-tab-title", function(tab)
	local title = tab.tab_title
	if not title or title == "" then
		title = tab.active_pane.title
	end
	local color = tab_colors[title]
	if color then
		local bg = tab.is_active and darken(color, 0.75) or color
		return {
			{ Background = { Color = bg } },
			{ Foreground = { Color = "#ffffff" } },
			{ Text = " " .. (tab.tab_index + 1) .. ": " .. (tab.is_active and "*" or "") .. title .. " " },
		}
	end
end)

-- Maximize on startup and create split tabs
wezterm.on("gui-startup", function(cmd)
	local first_prefix = split_tabs[1].prefix
	local first_tab, pane, window = mux.spawn_window(cmd or {
		cwd = env["WEZTERM_" .. first_prefix .. "_TOP_LEFT"],
	})
	first_tab:set_title(split_tabs[1].name)
	window:gui_window():maximize()

	-- Split first tab: horizontal split, then vertical split on top
	local bottom = pane:split({ direction = "Bottom", cwd = env["WEZTERM_" .. first_prefix .. "_BOTTOM"] })
	pane:split({ direction = "Right", cwd = env["WEZTERM_" .. first_prefix .. "_TOP_RIGHT"] })

	-- Create remaining split tabs (Web, Persona/Cortex)
	for i = 2, #split_tabs do
		local prefix = split_tabs[i].prefix
		local new_tab, new_pane = window:spawn_tab({ cwd = env["WEZTERM_" .. prefix .. "_TOP_LEFT"] })
		new_tab:set_title(split_tabs[i].name)
		new_pane:split({ direction = "Bottom", cwd = env["WEZTERM_" .. prefix .. "_BOTTOM"] })
		new_pane:split({ direction = "Right", cwd = env["WEZTERM_" .. prefix .. "_TOP_RIGHT"] })
	end

	-- Create Claude tabs (single pane)
	for _, name in ipairs(claude_tabs) do
		local new_tab = window:spawn_tab({})
		new_tab:set_title(name)
	end

	first_tab:activate()
end)

-- Key bindings
config.keys = {
	{
		key = "Enter",
		mods = "SHIFT",
		action = wezterm.action.SendString("\x1b\r"),
	},
}

-- Font
config.font_size = 20

config.color_scheme = "Adventure Time"

config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true

config.window_decorations = "RESIZE"

-- and finally, return the configuration to wezterm
return config
