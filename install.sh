#!/usr/bin/env bash

#= Definitions {{{1
#================================================
ERR_DEP=1
ERR_INNER_DEP=2
ERR_NOOP=3
ERR_RUNTIME=4
SELF_DIR=$(pwd)
DIST_ID=$(lsb_release -si 2>/dev/null)

# Get XDG paths
# export X_DOTFILES... in zshenv will raise an error with bash
source $SELF_DIR/zshenv 2>/dev/null

to_install=()
conflicted=()
#= endsection }}}1

#= Helpers {{{1
#================================================
# should_install() {{{2
#--------------------------------------------------
function should_install {
  local what=$1
  if [[ "${to_install[@]}" =~ "${what}" ]]; then
    return 0
  fi
  return 1
}

# ask() {{{2
#--------------------------------------------------
function ask {
  local what=$1

  printf "${what}? [y/N] "
  read -e a

  if [[ $a == 'y' || $a == 'Y' || $a == 'yes' || $a == 'YES' ]]; then
    return 0
  fi
  return 1
}

# ask_install() {{{2
#--------------------------------------------------
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

# make_dir() {{{2
#--------------------------------------------------
function make_dir {
  local dir=$1
  if [[ ! -d $dir ]]; then
    echo "Making directory ${dir}"
    mkdir -p $dir
  fi
}

# git_clone() {{{2
#--------------------------------------------------
function git_clone {
  local repo=https://github.com/$1
  local dest=$2/$(basename $repo)

  git clone --depth=1 $repo $dest
}

# backup() {{{2
#--------------------------------------------------
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

# rm_file() {{{2
#--------------------------------------------------
function rm_file {
  local file=$1

  if [[ -f $file ]]; then
    echo "Removing old ${file}"
    rm -rf $file
  fi
}

# rm_dir() {{{2
#--------------------------------------------------
function rm_dir {
  local dir=$1

  if [[ -d $dir ]]; then
    echo "Removing old ${dir}"
    rm -rf $dir
  fi
}

# dot_link() {{{2
#--------------------------------------------------
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

# is_installed() {{{2
#--------------------------------------------------
function is_installed {
  local what=$1

  if [[ $(type -p $what) ]]; then
    return 0
  fi
  return 1
}

# login_shell() {{{2
#--------------------------------------------------
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
ask_install 'zsh' '' 'zsh'
ask_install 'vim' 'zsh'
ask_install 'tmux' 'zsh'
ask_install 'i3wm' '' 'termite' 'dmenu' 'i3-dmenu-desktop'
ask_install 'termite'
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

#- i3wm {{{2
#------------------------------------------------
if should_install 'i3wm'; then
  make_dir $XDG_CONFIG_HOME/i3

  bl_device=$(ls /sys/class/backlight)
  if [[ "${bl_device[0]}" ]]; then
    echo
    echo "In order to get the brightness control keys to work, you'll need to be able"
    echo "to run '${SELF_DIR}/lib/i3/brightctl.sh' as root without password."
    echo "I can help you here creating a group with that power and adding you to it."
    echo "For that, I'll need your sudo password, just once."
    if ask "Do you want to create the 'brightctl' group"; then
      bl_device="/sys/class/backlight/${bl_device[0]}/brightness"
      sudo groupadd brightctl 2>/dev/null
      sudo usermod -aG brightctl $USER
      echo "%brightctl ALL=(ALL) NOPASSWD: ${SELF_DIR}/lib/i3/brightctl.sh" > /tmp/brightctl.sudoers
      sudo chown root: /tmp/brightctl.sudoers
      sudo mv /tmp/brightctl.sudoers /etc/sudoers.d/99-brightctl
    fi
  fi

  $SELF_DIR/bin/load-i3-config $SELF_DIR
fi

#- Termite {{{2
#------------------------------------------------
if should_install 'termite'; then
  make_dir $XDG_CONFIG_HOME
  make_dir $XDG_DATA_HOME/fonts/MonacoTTF

  dot_link 'termite' $XDG_CONFIG_HOME
  git_clone 'todylu/monaco.ttf' $XDG_DATA_HOME/fonts/MonacoTTF
fi

#- Zsh {{{2
#------------------------------------------------
if should_install 'zsh'; then
  if [[ $(login_shell) != '/bin/zsh' && $(login_shell) != $(which zsh) ]]; then
    echo 'Setting zsh as the default login shell'
    chsh -s $(which zsh) $(whoami)
  fi

  # move old files out of our way
  backup ~/.histfile

  make_dir $XDG_CACHE_HOME/zsh
  make_dir $XDG_CONFIG_HOME
  make_dir $XDG_DATA_HOME

  dot_link 'zshrc' $HOME
  dot_link 'zshenv' $HOME
  dot_link 'zprofile' $HOME

  echo 'Installing base16 colorschemes'
  rm_file $HOME/.base16_theme
  rm_file $HOME/.vimrc_background
  rm_dir $XDG_DATA_HOME/base16-shell
  git_clone 'chriskempson/base16-shell' $XDG_DATA_HOME
fi

#- Tmux {{{2
#------------------------------------------------
if should_install 'tmux'; then
  dot_link 'tmux.conf' $HOME
fi

#- Vim {{{2
#------------------------------------------------
if should_install 'vim'; then
  dot_link 'vim' $HOME
  dot_link 'vimrc' $HOME

  echo 'Installing vim plugins'
  bash $SELF_DIR/vim/plugins.sh $SELF_DIR/vim
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

if should_install 'tmux' || should_install 'vim'; then
  if ! is_installed 'xclip'; then
    echo "xclip is required to interact with the system's clipboard."
  fi
fi

if should_install 'zsh'; then
  if [[ $(login_shell) == '/bin/zsh' || $(login_shell) == $(which zsh) ]]; then
    echo 'Be sure to logout/login to validate the changes.'
  else
    echo 'Could not set zsh as the default login shell!'
    exit $ERR_RUNTIME
  fi
fi
#= endsection }}}1

#= Cleanup {{{1
#================================================
unset ERR_DEP
unset ERR_INNER_DEP
unset ERR_NOOP
unset ERR_RUNTIME
unset SELF_DIR
unset DIST_ID
