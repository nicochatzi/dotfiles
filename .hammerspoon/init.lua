local keys = require('hotkey')

keys.setup_hotkey({
    mods = { "alt" },
    key = '1'
}, 'Alacritty', 'org.alacritty')

keys.setup_hotkey_macos({
    mods = { "alt" },
    key = '2'
}, 'company.thebrowser.Browser')

keys.setup_hotkey_macos({
    mods = { "alt" },
    key = '3'
}, 'com.spotify.client')
