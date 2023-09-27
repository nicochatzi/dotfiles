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

keys.setup_hotkey_macos({
    mods = { "alt" },
    key = '4'
}, 'com.apple.Safari.WebApp.42CFC3A7-A873-4F70-AA0D-1640F387A562')
