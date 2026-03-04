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
	MasterClass = "#444444",
	Scratch = "#048a81",
	["Claude 1"] = "#ef3e36",
	["Claude 2"] = "#a11692",
	["Claude 3"] = "#246eb9",
}

local extra_tabs = { "Scratch", "Claude 1", "Claude 2", "Claude 3" }

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

-- Maximize on startup and split into 2x2 grid
wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or { cwd = env.WEZTERM_PANE_TOP_LEFT })
	tab:set_title(env.WEZTERM_TAB_NAME)
	window:gui_window():maximize()

	local bottom_pane = pane:split({ direction = "Bottom", cwd = env.WEZTERM_PANE_BOTTOM_LEFT })
	pane:split({ direction = "Right", cwd = env.WEZTERM_PANE_TOP_RIGHT })
	bottom_pane:split({ direction = "Right", cwd = env.WEZTERM_PANE_BOTTOM_RIGHT })

	for _, name in ipairs(extra_tabs) do
		local new_tab = window:spawn_tab({ cwd = env.WEZTERM_PANE_TOP_RIGHT })
		new_tab:set_title(name)
	end

	tab:activate()
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
