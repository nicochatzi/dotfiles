set -u

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

dotfiles remote set-url origin git@github.com:nicochatzi/dotfiles.git
