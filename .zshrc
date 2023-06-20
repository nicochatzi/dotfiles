# Enable Powerlevel11k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

###########################################################################
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

fpath=( ~/.zfunc "${fpath[@]}" )
export PATH=$PATH:/usr/local/bin

###########################################################################

bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

###########################################################################
# Source ZPlug
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# Plugins
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions", defer:2
zplug "unixorn/fzf-zsh-plugin", defer:3
zplug "Aloxaf/fzf-tab", defer:3

# zplug self-managing
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# # Install plugins if there are plugins that have not been installed
# if ! zplug check --verbose; then
#     zplug install
# fi

zplug load 

###########################################################################
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
else
  export EDITOR='vim'
  export VISUAL='vim'
fi

alias tree="tree -C"
alias l="exa -la"
alias ll="exa -lamhuU --git"
alias t="exa -a -T -L 2"
alias py="python3"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

###########################################################################
# Plugin config

# Ctrl+z : accept suggestion
bindkey '^z' autosuggest-accept
# Ctrl+x : accept and execute suggesetion
bindkey '^x' autosuggest-execute

###########################################################################
# FZF config
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --no-mouse'
export FZF_DEFAULT_COMMAND='rg --hidden -l ""'
setopt globdots

# fzf-preview for windowed view with fzf-tab : https://github.com/Aloxaf/fzf-tab/wiki/Preview
zstyle ':fzf-tab:complete:(cd|exa|ls):*' fzf-preview \
    'exa -T -L 1 --color=always $realpath'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
    'git diff $word | delta'
zstyle ':fzf-tab:complete:(nvim|vim|bat):*' fzf-preview \
    'if test -f $realpath; then; bat --color=always $realpath; else; exa -a -T -L 1 --color=always $realpath; fi'

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# work
source $HOME/.config/fael/nli.sh
source $HOME/.creds/.faelrc

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
