local _ = require('lib')

_.setup_hotkey {
    mods = { "alt" },
    key = '1',
    app_name = 'Alacritty',
    bundle_id = 'org.alacritty',
    scaled = true,
}

_.setup_hotkey {
    mods = { "alt" },
    key = '2',
    app_name = 'Arc',
    bundle_id = 'company.thebrowser.Browser',
}

-- _.start_spotify_notifications()

_.Window.move {
    mods = { "ctrl", "alt" },
    key = "Left",
    action = _.Window.to_left_half
}

_.Window.move {
    mods = { "ctrl", "alt" },
    key = "Right",
    action = _.Window.to_right_half
}

_.Window.move {
    mods = { "ctrl", "alt" },
    key = "Up",
    action = _.Window.to_fullscreen
}

_.Window.move {
    mods = { "ctrl", "alt" },
    key = "Down",
    action = _.Window.to_original_frame
}
