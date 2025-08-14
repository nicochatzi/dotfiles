# zmodload zsh/zprof

if [[ $TERM == xterm-256color && -n $TMUX ]]; then
    export TERM=tmux-256color
fi

# export RUST_BACKTRACE=1
export ZVM_INSTALL="$HOME/.zvm/self"
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
mkdir -p $TF_PLUGIN_CACHE_DIR

export PATH="$HOME/code/me/aud/out:$PATH"
export PATH="$HOME/.scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.zvm/bin:$PATH"
export PATH="$HOME/.local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$ZVM_INSTALL/:$PATH"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/shims:$PATH"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

setopt inc_append_history
# setopt share_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt globdots

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
else
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

[ -s "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"
[ -s "$HOME/.snc-env" ] && \. "$HOME/.snc-env"
[ -s "$HOME/.creds" ] && \. "$HOME/.creds"

# -----------------------------
# zinit
# -----------------------------

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

fpath=( ~/.zfunc "${fpath[@]}" )

if type brew &>/dev/null; then
  # this may be required before running the next commands
  # sudo chmod -R 755 $(brew --prefix)
  #
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
else
  fpath=(~/.zsh/completions $fpath)
fi

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/bin/terraform terraform
complete -C aws_completer aws

zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"
if [[ ! -f $zcompdump || $ZSH_COMPDUMP_CHANGED -eq 1 ]]; then
  compinit -C -d $zcompdump
else
  compinit -d $zcompdump
fi

zinit light Aloxaf/fzf-tab
zinit wait lucid for \
  zsh-users/zsh-completions \
  zsh-users/zsh-autosuggestions \
  zdharma-continuum/fast-syntax-highlighting \
  unixorn/fzf-zsh-plugin

install_precommit_hooks() {
    if [ -f .pre-commit-config.yaml ] && ! [ -f .git/hooks/pre-commit ]; then
        echo "pre-commit config found. Installing hooks..."
        pre-commit install
    fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd install_precommit_hooks

# -----------------------------
# lazy env loaders
# -----------------------------

if command -v nvm >/dev/null 2>&1; then
  load_nvm() {
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  }

  nvm() {
    unset -f nvm
    load_nvm
    nvm "$@"
  }

  use_nvm_version() {
      if [ -f .nvmrc ]; then
          nvm use 2>/dev/null || {
              nvm install && nvm use;
          }
      fi
  }

  add-zsh-hook chpwd use_nvm_version
fi

if command -v fnm >/dev/null 2>&1; then
  fnm() {
    unset -f fnm
    eval "$(fnm env --use-on-cd --shell zsh)"
    fnm "$@"
  }

  use_fnm_version() {
      if [ -f .nvmrc ]; then
          fnm use --silent-if-unchanged 2>/dev/null || {
              fnm install && fnm use;
          }
      fi
  }

  add-zsh-hook chpwd use_fnm_version
fi

if command -v pyenv >/dev/null 2>&1; then
  load_pyenv() {
      eval "$(pyenv init --path)"
      eval "$(pyenv init -)"
      eval "$(pyenv virtualenv-init -)"
  }

  pyenv() {
    unset -f pyenv
    load_pyenv
    pyenv "$@"
  }
fi

# -----------------------------
# aliases
# -----------------------------

alias tree="tree -C"
alias l="eza -lam --icons=auto"
alias ll="eza -lamhUuH --icons=auto --git"
alias t="eza -a -T -L 2 --icons=auto"
alias tt="eza -lamhUuH -T -L 2 --icons auto --git"
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias c='cargo'
alias j='just'
alias jl='just --list --unsorted'
alias nvsql="nvim '+SQLua'"
alias k='kubectl'
alias tv='tidy-viewer'
alias py='python3'
alias y='yazi'

__WT_CACHE="${__WT_CACHE:-$(~/.scripts/xctl theme 2>/dev/null || echo dark)}"
delta() { command delta --$__WT_CACHE "$@" }
bat() { command bat --theme=gruvbox-$__WT_CACHE "$@" }
btm() {
  local theme="gruvbox" # default is dark
  if [[ $__WT_CACHE == "light" ]]; then theme="nord-light"; fi
  command btm --theme="$theme" "$@"
}
watch() { command watch --color "$@" }

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

nv() {
    if [[ -d $1 ]]; then
        cd "$1"
        command nvim
    else
        command nvim "$@"
    fi
}

# -----------------------------
# zstyle
# -----------------------------

# Bindings and Widgets
function clear-screen-and-scrollback() { clear && printf '\e[3J' && zle reset-prompt }
zle -N clear-screen-and-scrollback

# don't go into vim-mode if we're already in vim
if [[ -z "$VIMRUNTIME" ]]; then
    bindkey -v
fi

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
export FZF_DEFAULT_OPTS='--height 100% --layout=reverse --no-mouse'
export FZF_DEFAULT_COMMAND='rg --hidden -l ""'

zstyle ':completion:complete:*:options' sort false

# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# fzf-preview for windowed view with fzf-tab : https://github.com/Aloxaf/fzf-tab/wiki/Preview
# zstyle ':fzf-tab:complete:*:*' fzf-preview \
#     'eza -T -L 1 --icons --color=always $realpath'
zstyle ':fzf-tab:complete:git-(a|add|diff|restore):*' fzf-preview \
    'git diff $word | delta'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview \
  'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:complete:*:*' fzf-preview \
    'if test -f $realpath; then; bat --color=always $realpath; else; eza -a -T -L 1 --icons --color=always $realpath; fi'

command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

eval "$(starship init zsh)"
eval "$(fzf --zsh)"

# zprof

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# [[ -s "/home/nico/.gvm/scripts/gvm" ]] && source "/home/nico/.gvm/scripts/gvm"

# opencode
export PATH=/home/nico/.opencode/bin:$PATH
