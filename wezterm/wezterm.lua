local wezterm = require 'wezterm'
return {
	font = wezterm.font_with_fallback {
		'FiraCode Nerd Font',
		'CaskaydiaCove Nerd Font',
		'Hack Nerd Font',
		'SFMono Nerd Font',
		'SFMono',
	},
  check_for_updates = true,
  check_for_updates_interval_seconds = 86400,
  show_update_window = true,
  color_scheme = 'Solarized (dark) (terminal.sexy)',
	font_size = 11.0,
	window_background_opacity = 1.0,
	enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
	window_decorations = "RESIZE",
	enable_scroll_bar = false,
	visual_bell = {
		fade_in_duration_ms = 50,
		fade_out_duration_ms = 50,
	},
	-- colors = {
	-- 	visual_bell = '#202020',
	-- },
}
