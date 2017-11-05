#= Basic settings {{{1
#==================================================
umask 077
export EDITOR=vim
export TERM=screen-256color
export PATH=$PATH:$X_DOTFILES/bin
setxkbmap -layout br -option ctrl:nocaps
#= endsection }}}1

#= Colors {{{1
#==================================================
# LS_COLORS
#--------------------------------------------------
eval $(dircolors -b $X_DOTFILES/dircolors)

# Terminal colors
#--------------------------------------------------
# The colors defined bellow are kind of a mix of:
# https://github.com/chriskempson/base16-shell/blob/master/scripts/base16-solarized-dark.sh
# and
# https://github.com/chriskempson/base16-shell/blob/master/scripts/base16-solarized-light.sh

if [[ $TMUX ]]; then
  # Tell tmux to pass the escape sequences through
  # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
  printf_template='\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\'
  printf_template_var='\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\'
  printf_template_custom='\033Ptmux;\033\033]%s%s\033\033\\\033\\'
else
  printf_template='\033]4;%d;rgb:%s\033\\'
  printf_template_var='\033]%d;rgb:%s\033\\'
  printf_template_custom='\033]%s%s\033\\'
fi

printf $printf_template_var 10 '93/a1/a1' # foreground
printf $printf_template_var 11 '00/2b/36' # background
printf $printf_template_custom 12 ';7'    # cursor
printf $printf_template  0 '00/2b/36'
printf $printf_template  1 'dd/22/22'
printf $printf_template  2 '33/99/00'
printf $printf_template  3 'cc/99/00'
printf $printf_template  4 '26/8b/d2'
printf $printf_template  5 '6c/71/c4'
printf $printf_template  6 '2a/a1/98'
printf $printf_template  7 'bb/bb/bb'
printf $printf_template  8 '58/6e/75'
printf $printf_template  9 'dc/32/2f'
printf $printf_template 10 '85/99/00'
printf $printf_template 11 'b5/89/00'
printf $printf_template 12 '26/8b/d2'
printf $printf_template 13 '6c/71/c4'
printf $printf_template 14 '2a/a1/98'
printf $printf_template 15 'fd/f6/e3'

# Special colors
printf $printf_template 21 'ee/e8/d5'
printf $printf_template 23 '93/a1/a1'
printf $printf_template 24 '83/94/96'
printf $printf_template 28 '07/36/42'
printf $printf_template 31 'ee/e8/d5'

unset printf_template printf_template_var printf_template_custom
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
zstyle ':vcs_info:git*' formats '(%F{2}%b%f) '
zstyle ':vcs_info:git*' actionformats '(%F{2}%b%f|%F{3}%a%f) '

#- Vi mode {{{2
#--------------------------------------------------
KEYTIMEOUT=1

__prompt_vi_mode_color=23
function zle-line-init zle-keymap-select {
  if [[ $KEYMAP == 'vicmd' ]]; then
    __prompt_vi_mode_color=8
  elif [[ $KEYMAP == 'main' ]]; then
    __prompt_vi_mode_color=23
  else
    __prompt_vi_mode_color=23
  fi

  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

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

#- At least, the prompt {{{2
#--------------------------------------------------
function precmd {
  vcs_info
  __prompt_job_info

  # show the current working directory above the prompt
  print -P '%F{4}%~%f'
}

PROMPT='$vcs_info_msg_0_%F{$__prompt_vi_mode_color}$%f '
RPROMPT='[%F{3}S:$__prompt_stopped_jobs %F{5}R:$__prompt_running_jobs%f]'
#= endsection }}}1

#= Aliases {{{1
#==================================================
alias ls='ls --color=auto'
alias ll='ls -lhF'
alias la='ls -ACF'
alias grep='grep --colour=auto'
alias tree='tree -C'
alias open='xdg-open'
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
