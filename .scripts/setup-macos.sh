#!/bin/bash

set -u

install_system_packages() {
  packages_to_install=("$@")
  for package in "${packages_to_install[@]}"; do
    brew install "$package"
  done
}

install_base_packages() {
  local packages=(\
    curl \
    git \
    python3 \
    pkg-config \
  )

  install_system_packages "${packages[@]}"
}

install_languages() {
  local packages=(\
    nodejs \
    clang-format \
    hadolint \
    shellcheck \
    cmake \
   )

  install_system_packages "${packages[@]}"

  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  curl -sSL https://install.python-poetry.org | python3 -
  npm i -g n
}

install_tui() {
  local packages=(\
    zsh \
    just \
    eza \
    tig \
    nvim \
    nvr \
    bat \
    fd \
    procs \
    dust \
    bottom \
    zplug \
    git-delta \
    ripgrep \
    watchexec \
    sccache \
    tmux \
    alacritty \
    hammerspoon \
  )

  install_system_packages "${packages[@]}"

  brew tap homebrew/cask-fonts
  brew install --cask font-jetbrains-mono
  brew install --cask font-jetbrains-mono-nerd-font
  brew install --cask font-meslo-lg-nerd-font

  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  pip3 install --user pynvim
}

install_cargo_extensions() {
  cargo install \
    cargo-watch \
    cargo-show-asm \
    cargo-nextest \
    cargo-audit \
    cargo-deny \
    cargo-remark \
    cargo-limit \
    cargo-binutils \
    cargo-bloat \
    cargo-pgo \
    cargo-update \
    nvim-send \
    tokei \
    hyperfine \
    flamegraph
}

install_language_servers() {
  cargo install asm-lsp
  npm install -g dockerfile-language-server-nodejs
  cargo install --git https://github.com/oxalica/nil nil
  cargo install taplo-cli --locked
  pip3 install cmake-language-server
  brew install tflint
  npm i -g bash-language-server
}

brew update

echo "~> Installing system packages"
install_base_packages

echo "~> Installing languages"
install_languages

echo "~> Installing languages servers"
install_language_servers

echo "~> Installing cargo extensions"
install_cargo_extensions

echo "~> Installing terminal UI tools"
install_tui

echo "~> Installing dotfiles"
curl https://raw.githubusercontent.com/nicochatzi/dotfiles/main/.scripts/install-dotfiles.sh \
  | bash

echo "~> Post-install"
brew cleanup
chsh -s "$(which zsh)"
zsh

echo "~~> Done setting up"
