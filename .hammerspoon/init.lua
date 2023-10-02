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
    scaled = false,
}

_.setup_hotkey {
    mods = { "alt" },
    key = '3',
    app_name = 'Spotify',
    bundle_id = 'com.spotify.client',
    scaled = false,
}

_.start_spotify_notifications()
