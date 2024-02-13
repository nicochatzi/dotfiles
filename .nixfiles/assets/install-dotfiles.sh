set -u

assert_is_installed() {
    if ! command -v $1 &> /dev/null; then
        echo "$1 is not installed"
        exit 1
    fi
}

run_system_check() {
  assert_is_installed git
  assert_is_installed rustup
  assert_is_installed nitrogen

    # Check if .dotfiles directory exists and is a Git repo
    if [ -d "$HOME/.dotfiles" ]; then
        if [ -d "$HOME/.dotfiles/.git" ]; then
            echo "Dotfiles repository already exists in $HOME/.dotfiles"
            exit 1
        else
            echo "A directory named '.dotfiles' exists but is not a Git repo. Please remove or rename it."
            exit 1
        fi
    fi
}

install_dotfiles() {
    # dotfile git setup from: https://www.atlassian.com/git/tutorials/dotfiles

    DOTFILE_ALIAS="alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'"

    dotfiles() {
        git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
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

    dotfiles config status.showUntrackedFiles no
}

run_post_install_setup() {
    dotfiles remote set-url origin git@github.com:nicochatzi/dotfiles.git

    nitrogen --save --set-zoom-fill ~/.nixfiles/assets/purple-turquoise.jpg

    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

    rustup default stable

    mkdir -p ~/Downloads ~/Documents ~/Pictures
}

build_xsys() {
  cd .xsys && just build install cron
}

echo "~> Checking Requirements"
run_system_check

echo "~> Installing dotfiles"
install_dotfiles

echo "~> Running Post Install Step"
run_post_install_setup

echo "~> Building and Installing xsys"
build_xsys

echo "~> Done setting up"

