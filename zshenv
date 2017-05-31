# The root of the dotfile's repo.
# Expect `zshenv` to be linked from the repo's root.
export X_DOTFILES=$(dirname $(realpath ${(%):-%N}))

# Set paths for user-specific data.
#
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
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export X_ENV_HOME=$HOME/.config/env
export X_LIB_HOME=$HOME/.local/lib
export X_BIN_HOME=$HOME/.local/bin
export X_VAR_HOME=$HOME/.local/var
