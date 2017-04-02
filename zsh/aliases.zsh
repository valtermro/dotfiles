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

# `vi` should be nvim, but let `vim` be vim
if type nvim >/dev/null; then
  export EDITOR='nvim'
  alias vi='nvim'
fi
