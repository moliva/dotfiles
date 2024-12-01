local wezterm = require("wezterm")
local act = wezterm.action
local wt_action = act

local dark_opacity = 0.95
local light_opacity = 0.9

local function tmux_prefix()
	return wt_action.SendKey({ mods = "CTRL", key = "a" })
end

local multiple_actions = function(keys)
	local actions = {}
	for key in keys:gmatch(".") do
		table.insert(actions, wt_action.SendKey({ key = key }))
	end
	table.insert(actions, wt_action.SendKey({ key = "\n" }))
	return wt_action.Multiple(actions)
end

local key_table = function(mods, key, action)
	return {
		mods = mods,
		key = key,
		action = action,
	}
end

local cmd_key = function(key, action)
	return key_table("CMD", key, action)
end

local cmd_ctrl_key = function(key, action)
	return key_table("CTRL | CMD", key, action)
end

local cmd_to_tmux_prefix = function(key, tmux_key)
	return cmd_key(
		key,
		wt_action.Multiple({
			tmux_prefix(),
			wt_action.SendKey({ key = tmux_key }),
		})
	)
end

local cmd_ctrl_to_tmux_prefix = function(key, tmux_key)
	return cmd_ctrl_key(
		key,
		wt_action.Multiple({
			tmux_prefix(),
			wt_action.SendKey({ key = tmux_key }),
		})
	)
end

local appearance = wezterm.gui.get_appearance()

local is_dark = function()
	return appearance:find("Dark")
end

local get_random_entry = function(tbl)
	local keys = {}
	for key, _ in ipairs(tbl) do
		table.insert(keys, key)
	end
	local randomKey = keys[math.random(1, #keys)]
	return tbl[randomKey]
end

local get_color_scheme = function()
	return is_dark() and "Harmonic16 Dark (base16)" or "Harmonic16 Light (base16)"
end

--- M.get_background
-- @param dark (int) Represents the darkness level of the background.
-- @param light (int) Represents the lightness level of the background.
-- @return The computed background color.
local get_background = function(dark, light)
	dark = dark or 0.95
	light = light or 0.8

	return {
		source = {
			Gradient = {
				colors = { is_dark() and "#0b1c2c" or "#f4e9e0" },
				-- colors = { is_dark() and "#000000" or "#ffffff" },
			},
		},

		width = "100%",
		height = "100%",

		opacity = is_dark() and dark or light,
	}
end

---@type Config
---@diagnostic disable: missing-fields
local config = {
	background = {
		-- w.get_wallpaper(wallpapers_glob),
		get_background(dark_opacity, light_opacity),
	},

	font_size = 12,

	line_height = 1.0,
	font = wezterm.font_with_fallback({
		-- "CommitMono",
		-- "DengXian",
		-- "Departure Mono",
		-- "GohuFont uni14 Nerd Font Mono",
		-- "Monaspace Argon",
		-- "Monaspace Krypton",
		-- "Monaspace Neon",
		-- "Monaspace Radon",
		-- "Monaspace Xenon",
		{
			family = "MesloLGMDZ Nerd Font",
			weight = "Medium",
			-- stretch = "UltraExpanded",
			-- style = "Oblique",
			-- harfbuzz_features = { "calt=0", "clig=0", "liga=0" },
			-- scale = 1.5
		},

		-- NOTE: fallback font for Nerd Font icons
		-- { family = "MesloLGMDZ Nerd Font" },
		{
			family = "Symbols Nerd Font Mono",
		},
	}),

	color_scheme = get_color_scheme(),

	window_padding = {
		left = 20,
		right = 5,
		top = 10,
		bottom = 0,
	},

	set_environment_variables = {
		BAT_THEME = is_dark() and "Catppuccin-mocha" or "Catppuccin-latte",
		LC_ALL = "en_US.UTF-8",
		-- TODO: audit what other variables are needed
	},

	-- general options
	adjust_window_size_when_changing_font_size = false,
	debug_key_events = false,
	enable_tab_bar = false,
	native_macos_fullscreen_mode = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",

	-- keys
	keys = {
		-- cmd_key(".", multiple_actions(":ZenMode")),
		-- cmd_key("[", act.SendKey({ mods = "CTRL", key = "o" })),
		-- cmd_key("]", act.SendKey({ mods = "CTRL", key = "i" })),
		-- cmd_key("f", multiple_actions(":Grep")),
		-- k.cmd_key("H", act.SendKey({ mods = "CTRL", key = "h" })),
		-- cmd_key("i", multiple_actions(":SmartGoTo")),
		-- k.cmd_key("J", act.SendKey({ mods = "CTRL", key = "j" })),
		-- k.cmd_key("K", act.SendKey({ mods = "CTRL", key = "k" })),
		-- k.cmd_key("K", act.SendKey({ mods = "CTRL", key = "k" })),
		-- k.cmd_key("L", act.SendKey({ mods = "CTRL", key = "l" })),
		-- cmd_key("O", multiple_actions(":GoToSymbol")),
		-- cmd_key("P", multiple_actions(":GoToCommand")),
		-- cmd_key("p", multiple_actions(":GoToFile")),

		-- cmd_key("q", multiple_actions(":q")),
		-- cmd_key("q", multiple_actions(":qa!")),

		cmd_to_tmux_prefix("1", "1"),
		cmd_to_tmux_prefix("2", "2"),
		cmd_to_tmux_prefix("3", "3"),
		cmd_to_tmux_prefix("4", "4"),
		cmd_to_tmux_prefix("5", "5"),
		cmd_to_tmux_prefix("6", "6"),
		cmd_to_tmux_prefix("7", "7"),
		cmd_to_tmux_prefix("8", "8"),
		cmd_to_tmux_prefix("9", "9"),
		-- cmd_to_tmux_prefix("`", "n"),
		-- cmd_to_tmux_prefix("b", "b"),
		-- cmd_to_tmux_prefix("C", "C"),
		-- cmd_to_tmux_prefix("d", "D"),
		-- cmd_to_tmux_prefix("G", "G"),
		-- cmd_to_tmux_prefix("g", "g"),
		-- cmd_to_tmux_prefix("j", "J"),
		-- cmd_to_tmux_prefix("K", "R"),
		-- cmd_to_tmux_prefix("k", "K"),
		-- cmd_to_tmux_prefix("l", "L"),
		-- cmd_to_tmux_prefix("n", "%"),
		-- cmd_to_tmux_prefix("N", '"'),
		-- cmd_to_tmux_prefix("o", "u"),
		-- cmd_to_tmux_prefix("T", "B"),
		-- cmd_to_tmux_prefix("Y", "Y"),
		-- cmd_to_tmux_prefix("t", "c"),
		-- cmd_to_tmux_prefix("w", "x"),
		-- cmd_to_tmux_prefix("z", "z"),
		-- cmd_to_tmux_prefix("Z", "Z"),
		-- cmd_to_tmux_prefix("9", "9"),
		-- cmd_ctrl_to_tmux_prefix("t", "J"),

		-- cmd_key(
		-- 	"R",
		-- 	act.Multiple({
		-- 		act.SendKey({ key = "\x1b" }), -- escape
		-- 		multiple_actions(":source %"),
		-- 	})
		-- ),

		-- save
		cmd_key(
			"s",
			act.Multiple({
				act.SendKey({ key = "\x1b" }), -- escape
				multiple_actions(":w"),
			})
		),

		-- find
		-- TODO(miguel): review this - 2024/12/01
		{
			mods = "CMD|SHIFT",
			key = "f",
			action = act.Multiple({
				act.SendKey({ mods = "CMD", key = "f" }),
				-- act.SendKey({ key = "n" }),
			}),
		},

		-- zoom
		{
			mods = "CMD",
			key = "z",
			action = act.Multiple({
				tmux_prefix(),
				act.SendKey({ key = "z" }),
			}),
		},

		-- tmux deattach and reattach
		{
			mods = "CMD",
			key = "d",
			action = act.Multiple({
				tmux_prefix(),
				act.SendKey({ key = "d" }),
			}),
		},
		{
			mods = "CMD|SHIFT",
			key = "d",
			action = act.Multiple({
				multiple_actions("tmux a || tmux\r"),
			}),
		},

		-- open yazi here
		{
			mods = "CMD",
			key = "e",
			action = act.Multiple({
				multiple_actions("yazi\r"),
			}),
		},

		-- open vim here
		{
			mods = "CMD",
			key = "i",
			action = act.Multiple({
				multiple_actions("vim .\r"),
			}),
		},

		-- alternate window tmux
		{
			mods = "CMD",
			key = "a",
			action = act.Multiple({
				tmux_prefix(),
				act.SendKey({ mods = "CTRL", key = "a" }),
			}),
		},
		-- find tmux window (fuzzy find)
		{
			mods = "CMD",
			key = "f",
			action = act.Multiple({
				tmux_prefix(),
				act.SendKey({ mods = "CTRL", key = "f" }),
			}),
		},
		-- move left/right through tmux windows
		{
			mods = "CMD|SHIFT",
			key = "j",
			action = act.Multiple({
				tmux_prefix(),
				act.SendKey({ mods = "CTRL", key = "h" }),
			}),
		},
		{
			mods = "CMD|SHIFT",
			key = "k",
			action = act.Multiple({
				tmux_prefix(),
				act.SendKey({ mods = "CTRL", key = "l" }),
			}),
		},

		-- TODO(miguel): wtf is this - 2024/12/01
		-- [[keyboard.bindings]]
		-- chars = "\u0001\u000B"
		-- key = "Period"
		-- mods = "Command|Shift"

		-- TODO(miguel): wtf is this - 2024/12/01
		-- [[keyboard.bindings]]
		-- chars = """
		-- \u0001
		-- """
		-- key = "Comma"
		-- mods = "Command|Shift"

		-- TODO(miguel): needed for changing panes with keyboard - 2024/12/01
		-- [[keyboard.bindings]]
		-- chars = "\u0001\u001BOP"
		-- key = "Key1"
		-- mods = "Command|Option"
		--
		-- [[keyboard.bindings]]
		-- chars = "\u0001\u001BOQ"
		-- key = "Key2"
		-- mods = "Command|Option"
		--
		-- [[keyboard.bindings]]
		-- chars = "\u0001\u001BOR"
		-- key = "Key3"
		-- mods = "Command|Option"
		--
		-- [[keyboard.bindings]]
		-- chars = "\u0001\u001BOS"
		-- key = "Key4"
		-- mods = "Command|Option"

		-- go to last window
		{
			mods = "CMD",
			key = "9",
			action = act.Multiple({
				tmux_prefix(),
				act.SendKey({ key = "9" }),
			}),
		},

		-- fuzzy find tmux sessions
		{
			mods = "CMD",
			key = "j",
			action = act.Multiple({
				tmux_prefix(),
				act.SendKey({ key = "'" }),
			}),
		},
		-- alternate tmux session
		{
			mods = "CMD",
			key = "o",
			action = act.Multiple({
				tmux_prefix(),
				act.SendKey({ mods = "CTRL", key = "q" }),
			}),
		},

		-- new tmux window (tab)
		{
			mods = "CMD",
			key = "t",
			action = act.Multiple({
				tmux_prefix(),
				act.SendKey({ mods = "SHIFT", key = "n" }),
			}),
		},
		-- {
		-- 	mods = "CTRL",
		-- 	key = "Tab",
		-- 	action = act.Multiple({
		-- 		act.SendKey({ mods = "CTRL", key = "b" }),
		-- 		act.SendKey({ key = "n" }),
		-- 	}),
		-- },
		--
		-- {
		-- 	mods = "CTRL|SHIFT",
		-- 	key = "Tab",
		-- 	action = act.Multiple({
		-- 		act.SendKey({ mods = "CTRL", key = "b" }),
		-- 		act.SendKey({ key = "n" }),
		-- 	}),
		-- },

		-- FIX: disable binding
		-- {
		-- 	mods = "CMD",
		-- 	key = "`",
		-- 	action = act.Multiple({
		-- 		act.SendKey({ mods = "CTRL", key = "b" }),
		-- 		act.SendKey({ key = "n" }),
		-- 	}),
		-- },

		-- {
		-- 	mods = "CMD",
		-- 	key = "~",
		-- 	action = act.Multiple({
		-- 		act.SendKey({ mods = "CTRL", key = "b" }),
		-- 		act.SendKey({ key = "p" }),
		-- 	}),
		-- },
	},
}

-- and finally, return the configuration to wezterm
return config
