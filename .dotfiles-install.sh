# #!/bin/bash

# dotfile git setup from:
# https://www.atlassian.com/git/tutorials/dotfiles

install_packages() {
    packages=(
        just
        watchexec
        sccache
        gh
        circleci
        clang-format
        hadolint
        n
        poetry
        exa
        tig
        nvim
        bat
        zplug
        git-delta
    )

    for package in "${package[@]}"
    do
        brew install "$package"
    done
    exit
}

install_rust() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -- -y
}

install_fonts() {
    brew tap homebrew/cask-fonts 
    brew install --cask font-jetbrains-mono
    brew install --cask font-jetbrains-mono-nerd-font
}

install_prezto() {
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
}

run_setup() {
    brew update
    install_fonts
    install_rust
    install_packages
    install_prezto
}

run_setup
