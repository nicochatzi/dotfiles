if [[ $TERM == xterm-256color && -n $TMUX ]]; then
    export TERM=tmux-256color
fi

export PATH="$HOME/code/me/aud/out:$PATH"
export PATH="$HOME/.scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"

export RUST_BACKTRACE=1
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=100000
setopt INC_APPEND_HISTORY

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

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx
