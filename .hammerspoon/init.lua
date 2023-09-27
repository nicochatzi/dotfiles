local keys = require('hotkey')

keys.setup_hotkey({
    mods = { "alt" },
    key = '1'
}, 'Alacritty', 'org.alacritty')

keys.setup_hotkey_macos({
    mods = { "alt" },
    key = '2'
}, 'com.apple.Safari')

keys.setup_hotkey_macos({
    mods = { "alt" },
    key = '3'
}, 'com.apple.Safari.WebApp.7E7AB543-CC1C-40CA-8943-87A42825EB3A')
