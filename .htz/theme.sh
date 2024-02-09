#!/bin/sh
#
color=$1

if [ "$color" != "light" ] && [ "$color" != "dark" ]; then
    echo "pass 'light' or 'dark'."
    exit 1
fi

create_link_if_exists() {
    src=$1
    dest=$2

    if [ -e "$src" ]; then
        ln -sf "$src" "$dest"
    else
        echo "Error: Source file $src does not exist."
        exit 1
    fi
}

create_link_if_exists ~/.config/alacritty/$color.toml ~/.config/alacritty/theme.toml
create_link_if_exists ~/.config/gtk-3.0/$color.ini ~/.config/gtk-3.0/settings.ini
create_link_if_exists ~/.config/nvim/lua/config/theme/$color.lua ~/.config/nvim/lua/config/theme/ini.lua

i3-msg reload
