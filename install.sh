#!/usr/bin/env bash
# vim: fdm=marker

#= Definitions {{{1
#================================================
ERR_DEP=1
ERR_INNER_DEP=2
ERR_NOOP=3
ERR_RUNTIME=4
SELF_DIR=$(pwd)
DIST_ID=$(lsb_release -si 2>/dev/null)

# Get XDG paths
source $SELF_DIR/zshenv

to_install=()
conflicted=()
#= endsection }}}1

#= Helpers {{{1
#================================================
function should_install {
  local what=$1
  if [[ "${to_install[@]}" =~ "${what}" ]]; then
    return 0
  fi
  return 1
}

function ask {
  local what=$1

  printf "${what}? [y/N] "
  read -e a

  if [[ $a == 'y' || $a == 'Y' || $a == 'yes' || $a == 'YES' ]]; then
    return 0
  fi
  return 1
}

function ask_install {
  local what=$1; shift
  local conf_depend=$1; shift
  local pack_depend=$@

  if ask "Install ${what} configs"; then
    if [[ $conf_depend ]] && ! should_install $conf_depend; then
      echo "Cannot install ${what}'s config without ${conf_depend}'s. Exiting..."
      exit $ERR_INNER_DEP
    fi

    if [[ $pack_depend ]]; then
      missing=()
      for pack in $pack_depend; do
        if ! is_installed $pack; then
          missing+=($pack)
        fi
      done

      if [[ $missing ]]; then
        echo "${what}'s configs depend on the following packages:"
        printf '  %s\n' "${missing[@]}"
        echo 'Exiting...'
        exit $ERR_DEP
      fi
    fi
    to_install+=($what)
  fi
}

function make_dir {
  local dir=$1
  if [[ ! -d $dir ]]; then
    echo "Making directory ${dir}"
    mkdir -p $dir
  fi
}

function git_clone {
  local repo=https://github.com/$1
  local dest=$2/$(basename $repo)

  git clone --depth=1 $repo $dest
}

function backup {
  local fname=$1

  if [[ -L $fname ]]; then
    # it's safe to remove a symlink
    rm $fname
  elif [[ -f $fname || -d $fname ]]; then
    conflicted+=($fname)
    mv $fname $fname.backup.$(date +'%s')
  fi
}

function rm_dir {
  local dir=$1
  local bkp=$2

  if [[ -d $dir ]]; then
    echo "Removing old ${dir}"
    rm -rf $dir
  fi
}

function dot_link {
  local what=$1
  local dest_dir=$2
  local dot=''
  local dir=$SELF_DIR

  if [[ $what =~ '/' ]]; then
    dir="${dir}/$(dirname $what)"
    what=$(basename $what)
  fi

  if [[ $dest_dir == $HOME  ]]; then
    dot='.'
  fi

  local src="${dir}/${what}"
  local dest="${dest_dir}/${dot}${what}"
  backup $dest

  echo "Linking ${dest} to ${src}"
  ln -s $src $dest
}

function is_installed {
  local what=$1

  if [[ $(type -p $what) ]]; then
    return 0
  fi
  return 1
}

function login_shell {
  echo $(grep "^$1" /etc/passwd | grep $(whoami) | cut -d ':' -f 7)
}
#= endsection }}}1

#= Validate dependencies {{{1
#================================================
if ! is_installed 'git'; then
  echo 'Installer depends on git. Please install it and try again.'
  exit $ERR_DEP
fi
#= endsection }}}1

#= Select configs to install {{{1
#================================================
ask_install 'git'
ask_install 'zsh' '' 'zsh' 'setxkbmap'
ask_install 'tmux' 'zsh'
ask_install 'neovim' 'zsh' 'nvim'
ask_install 'mutt' '' 'offlineimap' 'gpg' 'pass' 'msmtp'

# terminal profile should be available only on systems where it has been tested
if is_installed 'dconf' && is_installed 'gsettings'; then
  if [[ $(dconf dump /org/mate/terminal/profiles/) ]]; then
    if [[ $DIST_ID == 'Sabayon' || $DIST_ID == 'LinuxMint' ]]; then
      ask_install 'terminal emulator'
    fi
  fi
fi
#= endsection }}}1

#= Install {{{1
#================================================
if [[ -z $to_install ]]; then
  echo 'Nothing to do. Exiting...'
  exit $ERR_NOOP
fi

echo 'Installing configs'

#- Git {{{2
#------------------------------------------------
if should_install 'git'; then
  backup ~/.gitconfig
  make_dir $XDG_CONFIG_HOME
  dot_link 'git' $XDG_CONFIG_HOME
fi

#- Zsh {{{2
#------------------------------------------------
if should_install 'zsh'; then
  if [[ $(login_shell) != $(which zsh) ]]; then
    echo 'Setting zsh as the default login shell'
    chsh -s $(which zsh) $(whoami)
  fi

  # move old files out of our way
  backup ~/.zshrc
  backup ~/.histfile

  make_dir $XDG_CACHE_HOME/zsh
  make_dir $XDG_CONFIG_HOME
  make_dir $XDG_DATA_HOME

  dot_link 'zshenv' $HOME
  dot_link 'zsh' $XDG_CONFIG_HOME

  echo 'Installing base16 colorschemes'
  rm_dir $XDG_DATA_HOME/base16-shell
  git_clone 'chriskempson/base16-shell' $XDG_DATA_HOME
fi

#- Tmux {{{2
#------------------------------------------------
if should_install 'tmux'; then
  backup ~/.tmux.conf
  echo 'source $XDG_CONFIG_HOME/tmux/init.tmux' > ~/.tmux.conf

  make_dir $X_LIB_HOME
  dot_link 'tmux' $XDG_CONFIG_HOME
  dot_link 'lib/tmux' $X_LIB_HOME
fi

#- Neovim {{{2
#------------------------------------------------
if should_install 'neovim'; then
  dot_link 'nvim' $XDG_CONFIG_HOME

  echo 'Installing dein.vim'
  rm_dir $XDG_DATA_HOME/dein.vim
  make_dir $XDG_DATA_HOME/dein.vim/repos/github.com
  git_clone 'Shougo/dein.vim' $XDG_DATA_HOME/dein.vim/repos/github.com/Shougo

  if is_installed 'tern'; then
    dot_link 'tern-config' $HOME
  fi

  echo 'Starting neovim to install its plugins'
  echo 'The window will freeze for a while, please wait.'
  sleep 5
  nvim -c 'silent! call dein#install()' +qall
  nvim +UpdateRemotePlugins +qall
fi

#- Mutt {{{2
#------------------------------------------------
if should_install 'mutt'; then
  if ask 'Create a new gpg key'; then
    echo 'Generating gpg key'

    gpg_version=$(gpg --version | head -n 1 | sed -r 's/^.*([0-9]+).[0-9]+.[0-9]+$/\1/')
    if [[ $gpg_version < 2 ]]; then
      gpg --gen-key
    else
      gpg --full-gen-key
    fi
  fi

  printf 'A gpg-id to initialize `pass`, please: '
  read -e id
  pass init "${id}"

  echo 'Registering passwords for known email accounts'
  for acc in $SELF_DIR/mutt/accounts/*; do
    pass insert mail/$(basename $acc)
  done

  make_dir $X_LIB_HOME
  make_dir $XDG_CONFIG_HOME

  dot_link 'lib/mutt' $X_LIB_HOME
  dot_link 'lib/offlineimap' $X_LIB_HOME

  dot_link 'offlineimap' $XDG_CONFIG_HOME
  dot_link 'mutt' $XDG_CONFIG_HOME
  dot_link 'msmtp' $XDG_CONFIG_HOME
fi

#- Terminal emulator {{{2
#------------------------------------------------
if should_install 'terminal emulator'; then
  echo 'Installing fonts'
  make_dir $XDG_DATA_HOME/fonts
  rm_dir $XDG_DATA_HOME/fonts/top-programming-fonts
  git_clone 'hbin/top-programming-fonts' $XDG_DATA_HOME/fonts

  term_profile_id=valtermro_dotfiles

  # Mate desktop.
  if [[ $(dconf dump /org/mate/terminal/profiles/) ]]; then
    echo 'Setting up a profile for mate terminal'
    term_profile_schema=org.mate.terminal.global
    term_profile_list=$(gsettings get $term_profile_schema profile-list)
    dconf_profile_path=/org/mate/terminal/profiles/$term_profile_id/
    dconf_dump_file=$SELF_DIR/dconf_dump/org_mate_terminal_profiles_coding

    if [[ ! $term_profile_list =~ $term_profile_id ]]; then
      term_profile_list=${term_profile_list/]/," '${term_profile_id}']"}

      gsettings set $term_profile_schema profile-list "${term_profile_list}"
      gsettings set $term_profile_schema default-profile "${term_profile_id}"
      dconf load $dconf_profile_path < $dconf_dump_file
      term_conf_installed=true
    fi
  fi
fi
#= endsection }}}1

#= Wrap up {{{1
#=================================================
echo

if [[ $conflicted ]]; then
  echo 'The following files were moved to <file>.backup.<timestamp>:'
  printf '  %s\n' "${conflicted[@]}"
  echo 'You might want to check out, and remove, them.'
fi

if should_install 'neovim' && ! is_installed 'tern'; then
  echo 'Neovim could be better at editing javascript if you install ternjs.'
  echo 'If you do install ternjs, be sure to run `:Dein install` from inside neovim,'
  echo 'and link `tern-config` to your home, or create your own.'
  echo
fi

if should_install 'tmux' || should_install 'neovim'; then
  if ! is_installed 'xclip'; then
    echo "xclip is required to interact with the system's clipboard."
  fi
fi

if should_install 'zsh'; then
  if [[ $(login_shell) == $(which zsh) ]]; then
    echo 'Be sure to logout/login to validate the changes.'
  else
    echo 'Could not set zsh as the default login shell!'
    exit $ERR_RUNTIME
  fi
elif should_install 'terminal emulator'; then
  echo 'Please, open a new terminal window.'
fi
#= endsection }}}1
