setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT

#= Git stuff
#==================================================
autoload -Uz vcs_info
branch_color=16
action_color=3
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats '(%F{$branch_color}%b%f) '
zstyle ':vcs_info:git*' actionformats '(%F{$action_color}%a%f|%F{$branch_color}%b%f) '

#= Vi mode
#==================================================
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

#= Jobs
#==================================================
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

#= At least, the prompt
#==================================================
function precmd {
  vcs_info
  job_info

  # show the current working directory above the prompt
  print -P '%F{4}%~%f'
}

PROMPT='$vcs_info_msg_0_%F{$vi_mode_color}⇨%f '
RPROMPT='[%F{16}S:$suspended_jobs %F{4}R:$running_jobs%f]'
