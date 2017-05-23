#= Basic settings {{{1
#==================================================
umask 077

if type nvim >/dev/null; then
  export EDITOR='nvim'
fi
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
#= endsection }}}1

#= Prompt {{{1
#==================================================
#- Basic settings {{{2
#--------------------------------------------------
setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT

#- Git stuff {{{2
#--------------------------------------------------
autoload -Uz vcs_info
branch_color=16
action_color=3
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats '(%F{$branch_color}%b%f) '
zstyle ':vcs_info:git*' actionformats '(%F{$action_color}%a%f|%F{$branch_color}%b%f) '

#- Vi mode {{{2
#--------------------------------------------------
export KEYTIMEOUT=1

vi_mode_color=2
function zle-line-init zle-keymap-select {
  if [[ $KEYMAP == 'vicmd' ]]; then
    vi_mode_color=4
  elif [[ $KEYMAP == 'main' ]]; then
    vi_mode_color=2
  else
    vi_mode_color=255
  fi

  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

#- Jobs {{{2
#--------------------------------------------------
function job_info {
  local job_list=$(jobs)

  if [[ -z $job_list ]]; then
    running_jobs=0
    suspended_jobs=0
  else
    running_jobs=$(echo $job_list | grep 'running' | wc -l)
    suspended_jobs=$(echo $job_list | grep 'suspended' | wc -l)
  fi
}

# The job info becomes outdated when a running job exits. Forcing the prompt to
# update everytime the screen is cleaned softens this problem.
function update_prompt_on_clear {
  job_info
  clear
  zle reset-prompt
}
zle -N update_prompt_on_clear
bindkey '^l' update_prompt_on_clear

#- At least, the prompt {{{2
#--------------------------------------------------
function precmd {
  vcs_info
  job_info

  # show the current working directory above the prompt
  print -P '%F{4}%~%f'
}

PROMPT='$vcs_info_msg_0_%F{$vi_mode_color}⇨%f '
RPROMPT='[%F{16}S:$suspended_jobs %F{4}R:$running_jobs%f]'
#= endsection }}}1

#= Aliases {{{1
#==================================================
alias ls='ls --color=auto'
alias grep='grep --colour=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -lhF'
alias la='ls -ACF'
alias tree='tree -C'
alias open='xdg-open'

# match [neo]vim's `so` command
alias so='source'
#= endsection }}}1

#= Functions {{{1
#==================================================
# tm() {{{2
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
      printf 'Session name: '
      read session
      __my_tmux_session_create "$session"
    fi

    __my_tmux_session_attach "$session"
    break
  done
}

#- __my_tmux_session_attach() {{{2
#--------------------------------------------------
# Tries to create a new tmux session.
# The session, if created, is created in detached mode.
function __my_tmux_session_create {
  local session=$1

  tmux new -ds "$session"
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
    printf "Switch current client to $session? [y/N] "
    read -E a

    if [[ $a == 'y' || $a == 'Y' ]]; then
      tmux switch-client -t "$session"
    fi
    return 0
  fi

  tmux attach -t "$session"
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
    export PATH=$PATH:$dir
  else
    echo 'Already on $PATH'
  fi
}
#= endsection }}}1

#= Colors {{{1
#==================================================
export TERM=xterm-256color

eval "$(${XDG_DATA_HOME}/base16-shell/profile_helper.sh)"
if [[ ! -f ~/.base16_theme ]]; then
  echo "Using base16_eighties colorscheme"
  base16_eighties
fi
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
HISTSIZE=500
SAVEHIST=1000
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
