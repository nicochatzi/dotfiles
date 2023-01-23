#!/bin/bash

set -u

OS=$(uname -s)

install_system_packages() {
    packages_to_install=$@

    for package in "${packages_to_install[@]}"
    do
        if [[ $OS == "Darwin" ]]; then
            brew install "$package"
        else
            sudo apt install "$package" -y
        fi
    done
}

install_languages() {
    lang_packages=(
        python3
        pip3
        node
        n
    )

    linters_packages=(
        clang-format
        hadolint
        shellcheck
    )

    install_system_packages lang_packages
    install_system_packages linters_packages

    # Rust
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -- -y

    # CMake LSP for Coc
    pip3 install cmake-language-server

    # Poerty
    curl -sSL https://install.python-poetry.org | python3 -
}

install_tui() {
    tool_packages=(
        just
        exa
        tig
        nvim
        bat
        fd
        procs
        dust
        bottom
        zplug
        git-delta
        ripgrep
        watchexec
        sccache
        gh
        circleci
        tmux
    )

    install_system_packages tool_packages

    # Prezto
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

    # Nerd Fonts
    if [[ $OS == "Darwin" ]]; then
        brew tap homebrew/cask-fonts
        brew install --cask font-jetbrains-mono
        brew install --cask font-jetbrains-mono-nerd-font
    else
        pushd "$(pwd)" && \
            mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts && \
            git clone https://github.com/ryanoasis/nerd-fonts.git && cd nerd-fonts && \
            ./install.sh && \
            popd
    fi
}

install_dotfiles() {
    # dotfile git setup from: https://www.atlassian.com/git/tutorials/dotfiles

    DOTFILE_ALIAS="alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'"

    dotfiles() {
        /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
    }

    if [ -f $HOME/.zshrc ]; then
        echo $DOTFILE_ALIAS > $HOME/.zshrc
    fi

    if [ -f $HOME/.bashrc ]; then
        echo $DOTFILE_ALIAS > $HOME/.bashrc
    fi

    echo ".dotfiles" >> $HOME/.gitignore

    git clone --bare https://github.com/nicochatzi/dotfiles $HOME/.dotfiles

    dotfiles checkout

    if [ $? = 0 ]; then
        echo "Checked out config.";
    else
        echo "Backing up pre-existing dot files.";
        mkdir -p .config-backup && \
            config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
    fi;

    dotfiles checkout
    dotfiles config status.showUntrackedFiles no
}

INSTALL_LANUGAGES=0
INSTALL_TUI=0
INSTALL_DOTFILES=0

while [[ $# -gt 0 ]]; do
    case $1 in
        -a|--all)
            INSTALL_LANUGAGES=1
            INSTALL_TUI=1
            INSTALL_DOTFILES=1
            shift 2
            ;;
        -l|--langs)
            INSTALL_LANUGAGES=1
            shift 2
            ;;
        -t|--terminal)
            INSTALL_TUI=1
            shift 2
            ;;
        -d|--dotfiles)
            INSTALL_DOTFILES=1
            shift 2
            ;;
        *)
            echo "Unknown option $1"
            exit 1
            ;;
    esac
done

if [ $INSTALL_TUI -eq 1 ] || [ $INSTALL_DOTFILES -eq 1 ] || [ $INSTALL_LANUGAGES -eq 1 ]; then
    if [[ $OS == "Darwin" ]]; then
        brew update
    else
        sudo apt update
    fi
fi

if [ $INSTALL_TUI -eq 1 ]; then
    echo "~> Installing terminal UI tools"
    install_tui
fi

if [ $INSTALL_LANUGAGES -eq 1 ]; then
    echo "~> Installing languages"
    install_languages
fi

if [ $INSTALL_DOTFILES -eq 1 ]; then
    echo "~> Installing dotfiles"
    install_dotfiles
fi

echo "Done"
