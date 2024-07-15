#!/bin/bash

set -u

install_system_packages() {
  packages_to_install=("$@")
  for package in "${packages_to_install[@]}"; do
    sudo apt-get install -y "$package"
  done
}

install_base_packages() {
  local packages=(\
    curl \
    git \
    python3 \
    pkg-config \
    build-essential \
    lld \
    openssl \
    libssl-dev
  )

  install_system_packages "${packages[@]}"

  sudo apt install python3-pip
  sudo apt install pipx
}

install_languages() {
  local packages=(\
    clang-format \
    hadolint \
    shellcheck \
    cmake \
    lua \
    zig \
    default-jdk \
   )

  install_system_packages "${packages[@]}"

  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  curl -sSL https://install.python-poetry.org | python3 -
}

install_node() {
  sudo apt install -y ca-certificates gnupg
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
    | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

  NODE_MAJOR=20
  echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

  sudo apt update
  sudo apt install nodejs
  sudo apt install yarn

  npm i -g n
}

install_tui() {
  local packages=(\
    zsh \
    just \
    fzf \
    fd-find \
    eza \
    tig \
    neovim \
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
  )

  install_system_packages "${packages[@]}"

  bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

  # pipx install pynvim
  pipx install neovim-remote
}

install_jetbrains_font() {
  FONT_VERSION=$(curl -s "https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
  curl -sSLo jetbrains-mono.zip https://download.jetbrains.com/fonts/JetBrainsMono-$FONT_VERSION.zip
  unzip -qq jetbrains-mono.zip -d jetbrains-mono
  sudo mkdir /usr/share/fonts/truetype/jetbrains-mono
  sudo mv jetbrains-mono/fonts/ttf/*.ttf /usr/share/fonts/truetype/jetbrains-mono
  rm -rf jetbrains-mono.zip jetbrains-mono

  wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip
  unzip JetBrainsMono.zip -d ~/.fonts
  rm JetBrainsMono.zip

  fc-cache -fv
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
    bottom \
    bat \
    flamegraph
}

install_language_servers() {
  rustup component add rust-analyzer

  cargo install asm-lsp
  cargo install --git https://github.com/oxalica/nil nil
  cargo install taplo-cli --locked

  sudo npm i -g \
    dockerfile-language-server-nodejs \
    bash-language-server

  sudo apt install -y \
    luarocks \
    python3-pylsp \
    pylint

  pipx install \
    ruff
}

sudo apt-get update

echo "~> Installing system packages"
install_base_packages

echo "~> Installing jetbrains font"
install_jetbrains_font

echo "~> Installing languages"
install_languages

echo "~> Installing node"
install_node

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
chsh -s "$(which zsh)"

echo "~~> Done setting up"

zsh
