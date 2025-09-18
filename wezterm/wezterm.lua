local wezterm = require 'wezterm'
return {
  font = wezterm.font_with_fallback {
    'AtkynsonMono Nerd Font',
    'FiraCode Nerd Font',
    'Departure Mono',
    'CaskaydiaCove Nerd Font',
    'Hack Nerd Font',
    'SFMono Nerd Font',
    'SFMono',
  },
  -- default_prog = { '/opt/homebrew/bin/tmux', 'new', '-As0'},
  check_for_updates = true,
  check_for_updates_interval_seconds = 86400,
  show_update_window = true,
  -- color_scheme = 'Solarized (dark) (terminal.sexy)',
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
  keys = {
    -- Turn off the default CMD-W to close pane
    { key = 'W', mods = 'CTRL', action = wezterm.action.DisableDefaultAssignment },
    { key = 'W', mods = 'SHIFT|CTRL', action = wezterm.action.DisableDefaultAssignment },
    { key = 'w', mods = 'SHIFT|CTRL', action = wezterm.action.DisableDefaultAssignment },
    { key = 'w', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    -- Allow Shift + Super to still close a tab
    { key = 'w', mods = 'SHIFT|SUPER', action = wezterm.action.CloseCurrentTab { confirm = true } },
    -- Disable newtab key
    { key = 'T', mods = 'SHIFT|CTRL', action = wezterm.action.DisableDefaultAssignment },
    { key = 'T', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment },
    { key = 't', mods = 'SHIFT|CTRL', action = wezterm.action.DisableDefaultAssignment },
    { key = 't', mods = 'SUPER', action = wezterm.action.DisableDefaultAssignment }
  }
}
