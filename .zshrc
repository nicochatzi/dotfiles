# zmodload zsh/zprof

eval "$(/opt/homebrew/bin/brew shellenv)"
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
#
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
#
###########################################################################
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

###########################################################################
fpath=( ~/.zfunc "${fpath[@]}" )
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/.zvm/bin
export PATH=$PATH:$HOME/toolchains/arm-none-eabi/12.2/bin
# export PATH=$PATH:$HOME/toolchains/ra-multiplex/target/release
export PATH=$PATH:$HOME/.zvm/bin:$HOME/.zvm/zvm
export PATH=$PATH:$HOME/code/me/aud/out

# setup sccache
# export RUSTC_WRAPPER=/usr/local/bin/sccache
# ulimit -n 10240

export RUST_BACKTRACE=1

###########################################################################
# Plugins
zinit ice depth"1"; zinit light zsh-users/zsh-completions

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions

zinit light Aloxaf/fzf-tab
zpcompinit; zpcdreplay

zinit light unixorn/fzf-zsh-plugin
zinit light romkatv/powerlevel10k

source $HOME/code/me/aud/out/aud.zsh

###########################################################################
# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  export VISUAL='vim'
else
  export EDITOR='nvim'
  export VISUAL='nvim'
fi

# disable vim-mode if we're already in vim!
if [[ -z "$VIMRUNTIME" ]]; then
    bindkey -v # Enable vim keybindings
fi

alias tree="tree -C"
alias l="exa -la"
alias ll="exa -lamhuU --git"
alias t="exa -a -T -L 2"
alias py="python3"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias nv='nvim'
alias j='just'
alias f='nvim $(find `pwd` -type f | fzf)'

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


cht() {
  curl "cht.sh/$1"
}

nvim() {
    if [[ -d $1 ]]; then
        cd "$1"
        command nvim
    else
        command nvim "$@"
    fi
}

###########################################################################
# Bindings and Widgets

function clear-screen-and-scrollback() { clear && printf '\e[3J' && zle reset-prompt }
zle -N clear-screen-and-scrollback

# bind the clear to B so that i don't accidentally press it when using a vim motion
bindkey '^B' clear-screen-and-scrollback
bindkey '^Z' autosuggest-accept
# bindkey '^X' autosuggest-execute
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

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

source $HOME/.creds/.faelrc

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# zprof

[ -f "/Users/nico/.ghcup/env" ] && source "/Users/nico/.ghcup/env" # ghcup-env

# bun completions
[ -s "/Users/nico/.bun/_bun" ] && source "/Users/nico/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
