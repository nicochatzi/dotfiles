set -u

# dotfile git setup from: https://www.atlassian.com/git/tutorials/dotfiles

dotfiles() {
  git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
}

git clone --bare https://github.com/nicochatzi/dotfiles $HOME/.dotfiles

dotfiles checkout
dotfiles config status.showUntrackedFiles no
dotfiles remote set-url origin git@github.com:nicochatzi/dotfiles.git
