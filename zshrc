#= Basic settings {{{1
#==================================================
umask 022
export EDITOR=vim
export TERM=screen-256color
export PATH=$PATH:$X_DOTFILES/bin
#= endsection }}}1

#= Load user-defined scripts {{{1
#==================================================
if [[ -d $X_BIN_HOME ]]; then
  export PATH=$PATH:$X_BIN_HOME
fi

if [[ -d $X_ENV_HOME ]]; then
  for fname in $X_ENV_HOME/**/*.zsh; do
    source $fname
  done
fi

if [[ -d $X_LIB_HOME/zsh ]]; then
  for fname in $X_LIB_HOME/zsh/**/*.zsh; do
    source $fname
  done
fi

unset fname
#= endsection }}}1

#= Prompt {{{1
#==================================================
#- Basic settings {{{2
#--------------------------------------------------
setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT

#- Git {{{2
#--------------------------------------------------
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats '(%F{10}%b%f) '
zstyle ':vcs_info:git*' actionformats '(%F{10}%b%f|%F{11}%a%f) '

#- Vi mode {{{2
#--------------------------------------------------
# KEYTIMEOUT=1
# 
# __prompt_vi_mode_color=23
# function zle-line-init zle-keymap-select {
#   if [[ $KEYMAP == 'vicmd' ]]; then
#     __prompt_vi_mode_color=8
#   elif [[ $KEYMAP == 'main' ]]; then
#     __prompt_vi_mode_color=23
#   else
#     __prompt_vi_mode_color=23
#   fi
# 
#   zle reset-prompt
# }
# zle -N zle-line-init
# zle -N zle-keymap-select

#- Jobs ( {{{2
#--------------------------------------------------
function __prompt_job_info {
  local job_list=$(jobs)

  __prompt_running_jobs=$(echo $job_list | grep 'running' | wc -l)
  __prompt_stopped_jobs=$(echo $job_list | grep 'suspended' | wc -l)
}

# The job info becomes outdated when a running job exits. Forcing the prompt to
# update everytime the screen is cleaned softens this problem.
function __prompt_update_on_clear {
  __prompt_job_info
  clear
  zle reset-prompt
}
zle -N __prompt_update_on_clear
bindkey '^l' __prompt_update_on_clear

#- At last, the prompt {{{2
#--------------------------------------------------
function precmd {
  vcs_info
  __prompt_job_info

  # show the current working directory above the prompt
  print -P '%F{12}%~%f'
}

PROMPT='$vcs_info_msg_0_%F{7}$%f '
RPROMPT='[%F{11}S:$__prompt_stopped_jobs %F{13}R:$__prompt_running_jobs%f]'
#= endsection }}}1

#= Aliases {{{1
#==================================================
alias ls='ls --color=auto'
alias ll='ls -lhF'
alias la='ls -ACF'
alias grep='grep --colour=auto'
alias tree='tree -C'
alias open='xdg-open'

# Fix search highlighting
alias man="LESS_TERMCAP_so=$'\E[7;146m' LESS_TERMCAP_se=$'\E[0m' man"
alias less="LESS_TERMCAP_so=$'\E[7;146m' LESS_TERMCAP_se=$'\E[0m' less"
#= endsection }}}1

#= Functions {{{1
#==================================================
#- mkcd() {{{2
#--------------------------------------------------
# Creates a new directory and `cd` into it.
function mkcd {
  local dir=$1

  if [ ! -d $dir ]; then
    mkdir -p $dir
  fi
  cd $dir
}

#- tm() {{{2
#--------------------------------------------------
# A helper for creating new, and attaching to, tmux sessions.
#
# If a session name is give, it tries attach to that session.
# If a session with the given name doesn't exits, the function tries to create
# it before attach.
#
# When called without arguments, a selection menu, with all existing sessions as
# well as an options to create a new one is displayed.
#
# In any case, when trying to attach to a session while already inside one, the
# option to either switch sessions or abort is given.
function tm {
  local session=$1
  local sess_list=$(tmux list-sessions -F '#{session_name}' 2>/dev/null)

  if [[ $session ]]; then
    if [[ ! "$sess_list" =~ "$session" ]]; then
      __my_tmux_session_create $session
    fi
    __my_tmux_session_attach $session
    return 0
  fi

  local options=($(echo $sess_list) 'New session')
  COLUMNS=20
  PS3='Pick an option: '
  select session in "${options[@]}"; do
    if [[ $session == 'New session' ]]; then
      read 'session?Session name: '
      __my_tmux_session_create $session
    fi

    __my_tmux_session_attach $session
    break
  done
}

#- __my_tmux_session_create() {{{2
#--------------------------------------------------
# Tries to create a new tmux session.
# The session, if created, is created in detached mode.
function __my_tmux_session_create {
  local session=$1

  tmux new -ds $session
}

#- __my_tmux_session_attach() {{{2
#--------------------------------------------------
# Tries to attach to a tmux session.
#
# If already inside a tmux session given the option to switch to the target
# session or abort.
function __my_tmux_session_attach {
  local session=$1

  if [[ $TMUX ]]; then
    read "a?Switch current client to '$session?' [y/N] "

    if [[ $a == 'y' || $a == 'Y' ]]; then
      tmux switch-client -t $session
    fi
    return 0
  fi

  tmux attach -t $session
}

#- add2path() {{{2
#--------------------------------------------------
# Appends the given directory to $PATH.
# The change is valid for the current session only.
function add2path {
  local dir=$(realpath $1)

  if [[ ! -d $dir ]]; then
    echo 'Failed: invalid path'
    return 1
  fi

  if [[ ! "$PATH" =~ "$dir" ]]; then
    PATH=$PATH:$dir
  else
    echo 'Already on $PATH'
  fi
}
#= endsection }}}1

#= History {{{1
#==================================================
setopt APPEND_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_LEX_WORDS
setopt HIST_NO_FUNCTIONS
setopt HIST_NO_STORE
setopt HIST_SAVE_NO_DUPS

HISTFILE=$XDG_CACHE_HOME/zsh/histfile
HISTSIZE=2000
SAVEHIST=2000
#= endsection }}}1

#= Mappings {{{1
#==================================================
bindkey -v
bindkey '^R' history-incremental-search-backward
#= endsection }}}1

#= Completion {{{1
#==================================================
autoload -Uz compinit
compinit -i -d $XDG_CACHE_HOME/zsh/compdump

setopt EXTENDED_GLOB
unsetopt GLOB_DOTS

# fuzzy completion. taken from https://superuser.com/a/815317
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'
#= endsection }}}1
