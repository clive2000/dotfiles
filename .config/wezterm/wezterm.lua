local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices

-- For example, changing the color scheme:
config.color_scheme = 'ayu'
config.enable_scroll_bar = true
config.window_background_opacity = 0.95
config.default_cursor_style = "SteadyBar"
config.window_decorations = "TITLE | RESIZE"

-- Do not enable wayland
config.enable_wayland = false
-- and finally, return the configuration to wezterm

-- Font
config.font = wezterm.font_with_fallback{
  "CaskaydiaCove Nerd Font Mono",
  "Cascadia Mono NF",
  "Cascadia Mono",
  "Cascadia Code",
  "Hack Nerd Font Mono",
  "Hack Nerd Font",
  "Hack NF",
  "Hack",
  "JetBrains Mono",
  "Source Code Pro",
}
config.font_size = 16

return config
