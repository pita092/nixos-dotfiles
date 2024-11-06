local wezterm = require 'wezterm'
local config = wezterm.config_builder()
local scheme = wezterm.get_builtin_color_schemes()['Gruvbox dark, hard (base16)']


config.xcursor_theme = "GoogleDot-White"
config.hide_tab_bar_if_only_one_tab = true
config.font_size = 14.0
config.front_end = "WebGpu"

scheme.background = '#1d2021'
config.color_schemes = {
  ['My Modified Gruvbox'] = scheme,
}
config.color_scheme = 'My Modified Gruvbox'

return config
