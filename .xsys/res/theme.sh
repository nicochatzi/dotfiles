#!/bin/sh

color=$1

if [ "$color" != "light" ] && [ "$color" != "dark" ]; then
    echo "pass 'light' or 'dark'"
    exit 1
fi

symlink_if_present() {
    src=$1
    dest=$2

    if [ -e "$src" ]; then
        ln -sf "$src" "$dest"
    else
        echo "source file $src does not exist."
        exit 1
    fi
}

symlink_if_present \
  ~/.config/alacritty/$color.toml \
  ~/.config/alacritty/theme.toml

symlink_if_present \
  ~/.config/gtk-3.0/$color.ini \
  ~/.config/gtk-3.0/settings.ini

symlink_if_present \
  ~/.config/nvim/lua/config/theme/$color.lua \
  ~/.config/nvim/lua/config/theme/init.lua

i3-msg reload
