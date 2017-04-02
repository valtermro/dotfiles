autoload -Uz compinit
compinit -i -d $XDG_CACHE_HOME/zsh/compdump

setopt EXTENDED_GLOB
unsetopt GLOB_DOTS

# fuzzy completion. taken from https://superuser.com/a/815317
zstyle ':completion:*' matcher-list '' \
  'm:{a-z\-}={A-Z\_}' \
  'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
  'r:|?=** m:{a-z\-}={A-Z\_}'

