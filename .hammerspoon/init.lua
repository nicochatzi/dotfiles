local hotkey = require('lib/hotkey')
local winman = require('lib/winman')

-- find bundle id quickly in Hammerspoon console with:
-- hs.application.get("Safari"):bundleID()

hotkey.setup {
  mods = { "alt" },
  key = '1',
  app_name = 'Safari',
  bundle_id = 'com.apple.Safari',
}

hotkey.setup {
  mods = { "alt" },
  key = '2',
  app_name = 'Ghostty',
  bundle_id = 'com.mitchellh.ghostty',
  scaled = true,
}

hotkey.setup {
  mods = { "alt" },
  key = '3',
  app_name = 'Proton Mail',
  bundle_id = 'ch.protonmail.desktop',
}

hotkey.setup {
  mods = { "alt" },
  key = '4',
  app_name = 'Music',
  bundle_id = 'com.apple.Music',
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
