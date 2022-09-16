setopt auto_menu auto_cd correct auto_name_dirs auto_remove_slash
setopt extended_history hist_ignore_dups hist_ignore_space prompt_subst
setopt pushd_ignore_dups rm_star_silent sun_keyboard_hack
setopt extended_glob list_types no_beep always_last_prompt
setopt cdable_vars sh_word_split auto_param_keys
setopt hist_reduce_blanks share_history auto_pushd
setopt nolistbeep hist_ignore_all_dups
autoload -U compinit; compinit -u

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

source "$HOME/.cargo/env"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias ls='lsd'

alias la="ls -a"
alias lf="ls -F"
alias ll="ls -trAlF"
alias lt='ls --tree'
alias l="ls -lh"

alias du="du -h"
alias df="df -h"

alias su="su -l"
alias screen="env LC_TIME=C screen -D -RR"
alias tmux="env LC_TIME=C tmux -2 a || tmux -2"
alias dstat-full='dstat -Tclmdrn'
alias dstat-mem='dstat -Tclm'
alias dstat-cpu='dstat -Tclr'
alias dstat-net='dstat -Tclnd'
alias dstat-disk='dstat -Tcldr'
