local hotkey = require('lib/hotkey')
local winman = require('lib/winman')

hotkey.setup {
  mods = { "alt" },
  key = '1',
  app_name = 'Alacritty',
  bundle_id = 'org.alacritty',
  -- app_name = 'Kitty',
  -- bundle_id = 'net.kovidgoyal.kitty',
  scaled = true,
}

hotkey.setup {
  mods = { "alt" },
  key = '2',
  app_name = 'Arc',
  bundle_id = 'company.thebrowser.Browser',
}

winman.setup {
  mods = { "ctrl", "alt" },
  key = 'Left',
  action = winman.to_left_half
}

winman.setup {
  mods = { "ctrl", "alt" },
  key = 'Right',
  action = winman.to_right_half
}

winman.setup {
  mods = { "ctrl", "alt" },
  key = 'Up',
  action = winman.to_top_half
}

winman.setup {
  mods = { "ctrl", "alt" },
  key = 'Down',
  action = winman.to_bottom_half
}

winman.setup {
  mods = { "ctrl", "alt", "cmd" },
  key = 'Up',
  action = winman.to_fullscreen
}

winman.setup {
  mods = { "ctrl", "alt", "cmd" },
  key = 'Down',
  action = winman.to_original_frame
}

require('lib/clipmem').setup {
  history = 10,
}

-- require('lib/spotify').launch_notifier()
