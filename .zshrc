# export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="nico-af-magic"
HYPHEN_INSENSITIVE="true"
DISABLE_UPDATE_PROMPT="true"

plugins=(
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

setopt rm_star_silent

source ~/.aws-credentials
source ~/ampify/.configs

export NVM_DIR="$HOME/.nvm"

export SOULTRAIN_DIR="$HOME/.soultrain"
export PATH=$SOULTRAIN_DIR/bin:$PATH
export PATH=$SOULTRAIN_DIR/latest:$PATH

export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

export OPEN_OCD_INSTALL="$HOME/Library/xPacks/@xpack-dev-tools/openocd/0.10.0-15.1/.content/bin"
export PATH="$OPEN_OCD_INSTALL/bin:$PATH"

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

export PLUGINVAL="/Applications/pluginval.app/Contents/MacOS"
export PATH="$PLUGINVAL:$PATH"

export PYENV_PATH="$HOME/.pyenv"
export PATH="$PYENV_PATH/shims:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

export SCCACHE_PATH="$HOME/.sccache/bin"
fpath+=~/.zfunc

alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME/'

