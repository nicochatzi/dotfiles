set -u

assert_is_installed() {
  if ! command -v $1 &> /dev/null; then
    echo "$1 is not installed"
    exit 1
  fi
}

echo "~> Checking Requirements"

assert_is_installed git
assert_is_installed rustup
assert_is_installed nitrogen

if [ -d "$HOME/.dotfiles" ]; then
  if [ -d "$HOME/.dotfiles/.git" ]; then
    echo "Dotfiles repository already exists in $HOME/.dotfiles"
    exit 1
  else
    echo "A directory named '.dotfiles' exists but is not a Git repo. Please remove or rename it."
    exit 1
  fi
fi

echo "~> Running Post Install Step"

dotfiles remote set-url origin git@github.com:nicochatzi/dotfiles.git

nitrogen --save --set-zoom-fill ~/.nixfiles/assets/purple-turquoise.jpg

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

rustup default stable

mkdir -p ~/Downloads ~/Documents ~/Pictures

echo "~> Building and Installing xsys"

cd .xsys && just build install cron

echo "~> Done setting up"

