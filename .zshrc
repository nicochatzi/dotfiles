# zmodload zsh/zprof

if [[ $TERM == xterm-256color && -n $TMUX ]]; then
  export TERM=tmux-256color
fi

export ZVM_INSTALL="$HOME/.zvm/self"
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"
mkdir -p "$TF_PLUGIN_CACHE_DIR"

typeset -gU PATH fpath
export HOMEBREW_PREFIX=${HOMEBREW_PREFIX:-/opt/homebrew}
if [[ ! -x $HOMEBREW_PREFIX/bin/brew ]]; then
  for p in /opt/homebrew /usr/local; do
    [[ -x $p/bin/brew ]] && HOMEBREW_PREFIX=$p && break
  done
fi

if [[ -x $HOMEBREW_PREFIX/bin/brew ]]; then
  [[ -d $HOMEBREW_PREFIX/share/zsh/site-functions ]] && fpath+="$HOMEBREW_PREFIX/share/zsh/site-functions"
  [[ -d $HOMEBREW_PREFIX/share/zsh/completions ]] && fpath+="$HOMEBREW_PREFIX/share/zsh/completions"
  PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
fi

pathprepend() { [[ -d $1 ]] && PATH="$1:$PATH" }
pathappend()  { [[ -d $1 ]] && PATH="$PATH:$1" }

pathprepend "$HOME/code/me/aud/out"
pathprepend "$HOME/.scripts"
pathprepend "$HOME/.local/bin"
pathprepend "$HOME/.zvm/bin"
pathappend  "$HOME/.local/go/bin"
pathappend  "$HOME/go/bin"
pathappend  "$ZVM_INSTALL"
pathappend  "/home/nico/.opencode/bin"

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

setopt inc_append_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt globdots

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
else
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

[[ -s "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"
[[ -s "$HOME/.snc-env" ]] && . "$HOME/.snc-env"
[[ -s "$HOME/.creds" ]] && . "$HOME/.creds"
[[ -f "$HOME/.deno/env" ]] && . "$HOME/.deno/env"

fpath=( "$HOME/.zfunc" "${fpath[@]}" )

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ -r "$ZINIT_HOME/zinit.zsh" ]] && source "$ZINIT_HOME/zinit.zsh"

if typeset -f zinit >/dev/null 2>&1; then
  zinit ice wait lucid
  zinit light zsh-users/zsh-completions
  zinit light Aloxaf/fzf-tab
  zinit light zdharma-continuum/fast-syntax-highlighting
  zinit light zsh-users/zsh-autosuggestions
  zinit light unixorn/fzf-zsh-plugin
  zinit light romkatv/zsh-defer
fi

autoload -Uz compinit bashcompinit
zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zcompdump"
mkdir -p "${zcompdump:h}"
compinit -C -d "$zcompdump"
bashcompinit
(( $+commands[terraform] )) && complete -o nospace -C /usr/bin/terraform terraform
(( $+commands[aws_completer] )) && complete -C aws_completer aws

autoload -U add-zsh-hook

if command -v pre-commit >/dev/null 2>&1; then
  install_precommit_hooks() {
    if [ -f .pre-commit-config.yaml ] && ! [ -f .git/hooks/pre-commit ]; then
      pre-commit install
    fi
  }

  add-zsh-hook chpwd install_precommit_hooks
fi

if command -v fnm >/dev/null 2>&1; then
  fnm() {
    unset -f fnm;
    eval "$(fnm env --use-on-cd --shell zsh)";
    fnm "$@";
  }

  use_fnm_version() {
    if [ -f .nvmrc ]; then
        fnm use --silent-if-unchanged 2>/dev/null || {
          fnm install && fnm use;
        };
    fi
  }

  add-zsh-hook chpwd use_fnm_version

elif command -v nvm >/dev/null 2>&1; then
  load_nvm() {
    export NVM_DIR="$HOME/.nvm";
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh";
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion";
  }

  nvm() {
    unset -f nvm;
    load_nvm;
    nvm "$@";
  }

  use_nvm_version() {
    if [ -f .nvmrc ]; then
      nvm use 2>/dev/null || {
        nvm install && nvm use;
      };
    fi
  }

  add-zsh-hook chpwd use_nvm_version
fi

alias l="eza -lam --icons=auto"
alias ll="eza -lamhUuH --icons=auto --git"
alias tree="eza -a -T -L 1 --icons=auto"
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
watch() { command watch --color "$@" }

__WT_CACHE=
__theme_get() { __WT_CACHE=${__WT_CACHE:-${$(~/.scripts/xctl theme 2>/dev/null):-dark}} }
delta() { __theme_get; command delta --$__WT_CACHE "$@" }
bat() { __theme_get; command bat --theme=gruvbox-$__WT_CACHE "$@" }
btm() { __theme_get; local t=gruvbox; [[ $__WT_CACHE == light ]] && t=nord-light; command btm --theme="$t" "$@" }

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

clear-screen-and-scrollback() { clear && printf '\e[3J' && zle reset-prompt }
zle -N clear-screen-and-scrollback

if [[ -z "$VIMRUNTIME" ]]; then
  bindkey -v
fi

bindkey '^B' clear-screen-and-scrollback
bindkey '^Z' autosuggest-accept
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey -v
bindkey '^[‘' vi-cmd-mode

zle-keymap-select() {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = block ]]; then
    printf '\e[1 q'
  else
    printf '\e[5 q'
  fi
}
zle -N zle-keymap-select
printf '\e[5 q'

export FZF_DEFAULT_OPTS='--height 100% --layout=reverse --no-mouse'
export FZF_DEFAULT_COMMAND='rg --hidden -l ""'

zstyle ':completion:complete:*:options' sort false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

zstyle ':fzf-tab:complete:git-(a|add|diff|restore):*' fzf-preview 'git diff $word | delta'
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'if test -f $realpath; then; bat --color=always $realpath; else; eza -a -T -L 1 --icons --color=always $realpath; fi'

_just_recipes() {
  local -a recipes
  recipes=(${(ps: :)$(just --summary --unsorted 2>/dev/null)})
  compadd -a recipes
}
compdef _just_recipes just
compdef _just_recipes j
zstyle ':completion:*:*:just:*' menu yes select
zstyle ':completion:*:*:j:*' menu yes select
zstyle ':fzf-tab:complete:just:*' fzf-preview 'just --show $word 2>/dev/null || just --list --unsorted'
zstyle ':fzf-tab:complete:j:*' fzf-preview 'just --show $word 2>/dev/null || just --list --unsorted'

[[ -o interactive ]] && command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

if typeset -f zsh-defer >/dev/null 2>&1; then
  zsh-defer -t 0.05 eval "$(fzf --zsh)"
else
  eval "$(fzf --zsh)"
fi

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# bun completions
[ -s "/home/nico/.bun/_bun" ] && source "/home/nico/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# zprof
