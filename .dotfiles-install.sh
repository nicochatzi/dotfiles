#!/bin/bash

set -u

OS=$(uname -s)
SUDO=sudo
if ! command -v $SUDO &> /dev/null; then
  SUDO=
fi

install_system_packages() {
  packages_to_install=("$@")
  for package in "${packages_to_install[@]}"; do
    if [ $OS == "Darwin" ]; then
      brew install "$package"
    else
      $SUDO apt install "$package" -y
    fi
  done
}

install_base_packages() {
  local packages=(\
    curl \
    git \
    python3 \
  )

  install_system_packages "${packages[@]}"

  if ! [ $OS == "Darwin" ]; then
    $SUDO apt install -y python3-pip
  fi
}

install_languages() {
  local packages=(\
    nodejs \
    clang-format \
    hadolint \
    shellcheck \
   )

  install_system_packages "${packages[@]}"

  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  pip3 install cmake-language-server
  curl -sSL https://install.python-poetry.org | python3 -
  npm i -g n
}

install_tui() {
  local packages=(\
    zsh \
    just \
    exa \
    tig \
    nvim \
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

  git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

  if [[ $OS == "Darwin" ]]; then
    brew tap homebrew/cask-fonts
    brew install --cask font-jetbrains-mono
    brew install --cask font-jetbrains-mono-nerd-font
    brew install --cask font-meslo-lg-nerd-font
  else
    pushd "$(pwd)" && \
      mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts && \
      git clone https://github.com/ryanoasis/nerd-fonts.git && cd nerd-fonts && \
      ./install.sh && \
      popd
  fi

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

if [ $OS == "Darwin" ]; then
  brew update
else
  $SUDO apt update
fi

echo "~> Installing system packages"
install_base_packages

echo "~> Installing languages"
install_languages

echo "~> Installing cargo extensions"
install_cargo_extensions

echo "~> Installing terminal UI tools"
install_tui

echo "~> Installing dotfiles"
curl https://raw.githubusercontent.com/nicochatzi/dotfiles/main/.nixfiles/scripts/install.sh \
  | bash

echo "~> Post-install"
if [ $OS == "Darwin" ]; then
  brew cleanup
else
  apt clean
  rm -rf /var/lib/apt/lists/*d
fi
chsh -s $(which zsh)
zsh

echo "~~> Done setting up"
