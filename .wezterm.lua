-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices
config.enable_tab_bar = false

-- Without this there is no titlebar of the window in fedora
config.enable_wayland = false

config.audible_bell = 'Disabled'

config.keys = {
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = '-',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = '_',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = '+',
    mods = 'CTRL|SHIFT',
    action = wezterm.action.DisableDefaultAssignment,
  },
}

config.color_scheme = 'mywombat'
config.font_size = 9.0
-- Disable ligatures
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.default_cursor_style = 'SteadyBar'
config.selection_word_boundary = " \t\n{}[]()<>\"'`│|="

config.colors = {
  selection_bg = "rgba(238, 169, 184, 70%)"
--  selection_bg = "#eea9b8"
}

config.font_rules = {
	{
		intensity = "Bold",
		italic = false,
		font = wezterm.font("JetBrains Mono", { weight = "Bold", stretch = "Normal", style = "Normal", foreground="#ffffff" }),
	},
	{
		intensity = "Bold",
		italic = true,
		font = wezterm.font("JetBrains Mono", { weight = "Bold", stretch = "Normal", style = "Italic", foreground="#ffffff" }),
	},
}

-- Only for windows
if wezterm.target_triple:find("windows") ~= nil then
   config.default_domain = 'WSL:Ubuntu'

   -- In Windows, wezterm seems to send enter when clicking ctrl+_ (undo in emacs).
   -- Change that to 0x1f (this can be verified with the 'showkey -a' command)
   table.insert(
     config.keys,
     {
       key = "_",
       mods = "CTRL|SHIFT",
       action = wezterm.action.SendString("\x1f"),
     }
   )

   -- Override the default 'wslhost.exe' title
   wezterm.on('format-window-title', function()
       local title = 'WezTerm'
       return title
   end)
end

-- and finally, return the configuration to wezterm
return config
