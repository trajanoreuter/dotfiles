local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Afterglow"
config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.window_background_opacity = 0.85
-- make the window with blur
config.macos_window_background_blur = 20

return config
