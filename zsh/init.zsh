# Load default configuration files
source $XDG_CONFIG_HOME/zsh/aliases.zsh
source $XDG_CONFIG_HOME/zsh/colors.zsh
source $XDG_CONFIG_HOME/zsh/completion.zsh
source $XDG_CONFIG_HOME/zsh/history.zsh
source $XDG_CONFIG_HOME/zsh/mappings.zsh
source $XDG_CONFIG_HOME/zsh/prompt.zsh

if [[ -d $X_ENV_HOME && ! $TMUX ]]; then
  for fname in $X_ENV_HOME/**/*.zsh; do
    source $fname
  done
fi

if [[ -d $X_LIB_HOME/zsh ]]; then
  for fname in $X_LIB_HOME/zsh/**/*.zsh; do
    source $fname
  done
fi
