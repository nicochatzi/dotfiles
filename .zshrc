# zmodload zsh/zprof

export PATH="$HOME/code/me/aud/out:$PATH"
export PATH="$HOME/.scripts:$PATH"
export RUST_BACKTRACE=1
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt INC_APPEND_HISTORY

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

fpath=( ~/.zfunc "${fpath[@]}" )

# Plugins
zinit light Aloxaf/fzf-tab
zinit ice depth"1";
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light unixorn/fzf-zsh-plugin
zinit light romkatv/powerlevel10k

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
else
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

# only go into vim-mode if we're already in vim!
if [[ -z "$VIMRUNTIME" ]]; then
    bindkey -v
fi

alias tree="tree -C"
alias l="eza -la"
alias ll="eza -lamhuU --git"
alias t="eza -a -T -L 2"
alias py="python3"
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias nv='nvim'
alias j='just'
alias jl='just --list --unsorted'
alias f='nvim $(find `pwd` -type f | fzf)'
alias xsys='~/.xsys/bin/xsys'
alias bat='bat --theme=ansi'
alias btm='~/.scripts/btm-colorized'

we() {
    local filter_flag=""
    local zparseopts_return
    zparseopts -D -E -a zparseopts_return f:=filter_flag

    if (( ${#filter_flag} == 1 )); then
        filter_flag="-f=${ignore_flag[1]}"
    fi

    if (( ${#zparseopts_return} > 0 )); then
        echo "Usage: we [-f=\"FILTER_PATTERN\"] 'command [ARG]...'"
        return 1
    fi

    local cmd="${1}"
    if [[ -z "$cmd" ]]; then
        echo "Please provide a command to run with we."
        return 1
    fi

    watchexec -c -r -w . $filter_flag -- $cmd
}

nvim() {
    if [[ -d $1 ]]; then
        cd "$1"
        command nvim
    else
        command nvim "$@"
    fi
}

# Bindings and Widgets
function clear-screen-and-scrollback() { clear && printf '\e[3J' && zle reset-prompt }
zle -N clear-screen-and-scrollback

# bind the clear to B so that i don't accidentally press it when using a vim motion
bindkey '^B' clear-screen-and-scrollback
bindkey '^Z' autosuggest-accept
# bindkey '^X' autosuggest-execute
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey -v
bindkey '^[' vi-cmd-mode  # ESC to enter normal mode

# block/beam cursor in normal/insert mode
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'  # Block cursor in normal mode
  else
    echo -ne '\e[5 q'  # Beam cursor in insert mode
  fi
}
zle -N zle-keymap-select
# Set default cursor to beam on shell startup
echo -ne '\e[5 q'

# FZF config
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --no-mouse'
export FZF_DEFAULT_COMMAND='rg --hidden -l ""'
setopt globdots

zstyle ':completion:complete:*:options' sort false

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# fzf-preview for windowed view with fzf-tab : https://github.com/Aloxaf/fzf-tab/wiki/Preview
zstyle ':fzf-tab:complete:(cd|eza|ls):*' fzf-preview \
    'eza -T -L 1 --color=always $realpath'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
    'git diff $word | delta'
zstyle ':fzf-tab:complete:(nvim|vim|bat):*' fzf-preview \
    'if test -f $realpath; then; bat --color=always $realpath; else; eza -a -T -L 1 --color=always $realpath; fi'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview \
  'SYSTEMD_COLORS=1 systemctl status $word'

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

if [[ $(command -v direnv) ]]; then
  eval "$(direnv export zsh)"
fi
