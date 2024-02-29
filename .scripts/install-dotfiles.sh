set -u

# dotfile git setup from: https://www.atlassian.com/git/tutorials/dotfiles

DOTFILE_ALIAS="alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'"

dotfiles() {
  git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME "$@"
}

git clone --bare https://github.com/nicochatzi/dotfiles $HOME/.dotfiles

dotfiles config status.showUntrackedFiles no

dotfiles remote set-url origin git@github.com:nicochatzi/dotfiles.git
