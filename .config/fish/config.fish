set fish_greeting ""

if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_vi_key_bindings
fish_add_path /usr/local/bin
fish_add_path /Library/Apple/usr/bin
fish_add_path /System/Cryptexes/App/usr/bin
fish_add_path ~/.cargo/bin
fish_add_path ~/.fzf/bin

bind -M insert \cn down-or-search
bind -M insert \cp up-or-search

alias tree="tree -C"
alias l="exa -la"
alias ll="exa -lamhuU --git"
alias t="exa -a -T -L 2"
alias py="python3"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

source ~/.creds/.fael.fish
