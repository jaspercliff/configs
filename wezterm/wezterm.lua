-- Pull in the wezterm API
local wezterm = require("wezterm")
local act = wezterm.action
-- This will hold the configuration.
local config = wezterm.config_builder()

-- or, changing the font size and color scheme.
config.font_size = 14
config.color_scheme = "AdventureTime"

config.color_scheme = "Catppuccin Mocha"

config.window_background_opacity = 0.85 -- 透明度
config.macos_window_background_blur = 30 -- Mac 毛玻璃
config.window_decorations = "RESIZE"

-- 2. 亮色模式下给文字加一点“重量”
-- 亮色背景下文字容易显得单薄，用 Medium 字重更高级
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" })

-- 3. 隐藏繁琐的 Tab 栏，改用更现代的样式
config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.hide_tab_bar_if_only_one_tab = true -- 只有一个标签时自动隐藏，界面极简
-- 将 Leader 设为 Space
config.leader = { key = "q", mods = "ALT", timeout_milliseconds = 1000 }

config.keys = {
	{ key = "1", mods = "ALT", action = act.ActivateTab(0) },
	{ key = "2", mods = "ALT", action = act.ActivateTab(1) },
	{ key = "3", mods = "ALT", action = act.ActivateTab(2) },
	{ key = "4", mods = "ALT", action = act.ActivateTab(3) },
	{ key = "5", mods = "ALT", action = act.ActivateTab(4) },
	{ key = "6", mods = "ALT", action = act.ActivateTab(5) },
	{ key = "7", mods = "ALT", action = act.ActivateTab(6) },
	{ key = "8", mods = "ALT", action = act.ActivateTab(7) },
	{ key = "9", mods = "ALT", action = act.ActivateTab(8) },

	{ key = "v", mods = "ALT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = "ALT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
}
return config
