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

#= Prompt {{{1
#==================================================
setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT

#- Git stuff
#--------------------------------------------------
autoload -Uz vcs_info
branch_color=16
action_color=3
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats '(%F{$branch_color}%b%f) '
zstyle ':vcs_info:git*' actionformats '(%F{$action_color}%a%f|%F{$branch_color}%b%f) '

#- Vi mode
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

#- Jobs
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

#- At least, the prompt
#--------------------------------------------------
function precmd {
  vcs_info
  job_info

  # show the current working directory above the prompt
  print -P '%F{4}%~%f'
}

PROMPT='$vcs_info_msg_0_%F{$vi_mode_color}⇨%f '
RPROMPT='[%F{16}S:$suspended_jobs %F{4}R:$running_jobs%f]'

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

# match neovim's `so` command
alias so='source'

if type nvim >/dev/null; then
  export EDITOR='nvim'
  alias vi='nvim'
fi

#= Colors {{{1
#==================================================
export TERM=xterm-256color

eval "$(${XDG_DATA_HOME}/base16-shell/profile_helper.sh)"
if [[ ! -f ~/.base16_theme ]]; then
  echo "Using oceanicnext colorscheme"
  base16_oceanicnext
fi

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

#= Mappings {{{1
#==================================================
bindkey -v
bindkey '^r' history-incremental-search-backward

# Let capslock be control
setxkbmap -option ctrl:nocaps
