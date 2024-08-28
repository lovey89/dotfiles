-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.enable_tab_bar = false

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

-- and finally, return the configuration to wezterm
return config
