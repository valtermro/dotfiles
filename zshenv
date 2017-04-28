# Just enforce the default XDG base directories
#
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

# In addition to the directories defined by the XDG specs, I also find it useful
# to be able to mimic other unix directories, such as /bin, /lib and /var in, my
# home directory.
#
# `X_LIB_HOME` is a place to put local libraries. My zsh startup file, for example,
# is configured to load any .zsh inside `$X_LIB_HOME/zsh/`. These files are meant
# to define function that may be useful on a given workstation, but not so much
# on others.
#
# `X_ENV_HOME` is where I would put files that change the environment by exporting
# environment variables that programs, or the system itself, read at runtime.
# A file inside `X_ENV_HOME` should not define any logic by itself.
#
# `X_BIN_HOME` is the place to put user-defined binaries and other executable files.
#
# `X_VAR_HOME` is a `/var` alternative.
#
export X_LIB_HOME=$HOME/.local/lib
export X_ENV_HOME=$HOME/.local/env
export X_BIN_HOME=$HOME/.local/bin
export X_VAR_HOME=$HOME/.local/var

if [[ -d $X_BIN_HOME && ! $TMUX ]]; then
  export PATH=$PATH:$X_BIN_HOME
fi

# I use `init.zsh` rather than `zshrc` for consistency sake: Neovim uses `init.vim`.
#
# I could use `ZDOTDIR` to make zsh search for its startup files in
# `$XDG_CONFIG_HOME/zsh`, but I don't want to have hidden files inside a hidden
# directory. Plus, the consistency stuff is kinda nice, don't you think?
#
# I'm giving up startup/shutdown files for login shells here (.zlogin, .zlogout)
# but, who cares? I've never needed them. I'm not even sure what a login shell is...
#
if [[ -o interactive && -f $XDG_CONFIG_HOME/zsh/init.zsh ]]; then
  source $XDG_CONFIG_HOME/zsh/init.zsh
fi
