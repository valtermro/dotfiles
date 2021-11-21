#!/bin/bash

#= Definitions {{{1
#================================================
self_dir=$(pwd)
logout_needed=false
to_install=()
conflicted=()
notes=''

# get XDG_*
source $self_dir/zshenv 2>/dev/null

reset='\033[00;00m'
bold='\033[00;01m'
red='\033[91m'
#= endsection }}}1

#= Helpers {{{1
#================================================
# log() {{{2
#--------------------------------------------------
function log {
  local msg=$1
  printf "\n${bold}${msg}${reset}\n"
}

# die() {{{2
#--------------------------------------------------
function die {
  local msg=$1
  printf "${bold}${msg}${reset}\n"
  exit 1
}

# should_install() {{{2
#--------------------------------------------------
function should_install {
  local what=$1
  if [[ ${to_install[@]} =~ ${what} ]]; then
    return 0
  fi
  return 1
}

# ask() {{{2
#--------------------------------------------------
function ask {
  local what=$1

  read -p "${what}? [y/N] " a
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
  local pack_missing=()
  local pack

  if ask "Install ${what} files"; then
    if [[ $conf_depend ]] && ! should_install $conf_depend; then
      die "Cannot install ${what} files without ${conf_depend}'s."
    fi

    if [[ $pack_depend ]]; then
      for pack in $pack_depend; do
        if ! is_installed $pack; then
          pack_missing+=($pack)
        fi
      done

      if [[ $pack_missing ]]; then
        log "${what}'s files depend on the following packages:"
        printf ' - %s\n' $items ${pack_missing[@]}
        die 'Exiting...'
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

# rm_dir() {{{2
#--------------------------------------------------
function rm_dir {
  local dir=$1

  if [[ -d $dir ]]; then
    echo "Removing old ${dir}"
    rm -rf $dir
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

# is_installed() {{{2
#--------------------------------------------------
function is_installed {
  local what=$1
  if [[ $(type -p $what) ]]; then
    return 0
  fi
  return 1
}
#= endsection }}}1

#= Dependency check {{{1
#================================================
if ! is_installed 'git'; then
  die 'Missing dependency: git'
fi
#= endsection }}}1

#= Select configs to install {{{1
#================================================
ask_install 'git'
ask_install 'zsh' '' 'zsh'
ask_install 'vim'
ask_install 'tmux'
#= endsection }}}1

#= Install {{{1
#================================================
[[ ! $to_install ]] && die 'Nothing to do. Exiting...'

log 'Installing configs'

#- Git {{{2
#------------------------------------------------
if should_install 'git'; then
  echo '- git'
  backup $XDG_CONFIG_HOME/git
  backup ~/.gitconfig

  make_dir $XDG_CONFIG_HOME
  ln -s $self_dir/git $XDG_CONFIG_HOME/git
fi

#- Zsh {{{2
#------------------------------------------------
if should_install 'zsh'; then
  echo '- zsh'

  # HISTFILE is going to be changed...
  backup ~/.histfile
  backup ~/.zprofile
  backup ~/.zshenv
  backup ~/.zshrc

  make_dir $XDG_CACHE_HOME/zsh

  ln -s $self_dir/zshrc ~/.zshrc
  ln -s $self_dir/zshenv ~/.zshenv
  ln -s $self_dir/zprofile ~/.zprofile
fi

#- Vim {{{2
#------------------------------------------------
if should_install 'vim'; then
  echo '- vim'

  backup ~/.vim
  backup ~/.vimrc

  ln -s $self_dir/vim ~/.vim
  ln -s $self_dir/vimrc ~/.vimrc
fi

#- Tmux {{{2
#------------------------------------------------
if should_install 'tmux'; then
  echo '- tmux'

  backup ~/.tmux.conf
  ln -s $self_dir/tmux.conf ~/.tmux.conf
fi
#= endsection }}}1

#= Wrap up {{{1
#=================================================
if [[ $conflicted ]]; then
  log 'The following files were moved to <file>.backup.<timestamp>:'
  printf '  %s\n' "${conflicted[@]}"
fi

if should_install 'tmux' || should_install 'vim'; then
  if ! is_installed 'xclip'; then
    notes="${notes} - xclip is required for interacting with the system's clipboard (vim/tmux)\n"
  fi
fi

if should_install 'i3wm'; then
  notes="${notes} - Make sure you have a terminal emulator installed, any one supported by 'i3-sensible-terminal' should be fine (i3wm)\n"

  if ! is_installed 'twmnd'; then
    notes="${notes} - 'twmn' is required for desktop notifications (i3wm)\n"
  else
    logout_needed=true
  fi

  if ! is_installed 'compton'; then
    notes="${notes} - You might want to install 'compton' for a better experience (i3wm)\n"
  else
    logout_needed=true
  fi

  if ! is_installed 'udiskie'; then
    notes="${notes} - You might want to install 'udiskie' for usb automonting (i3wm)\n"
  fi
fi

if [[ $logout_needed == true ]]; then
  notes="${notes} - Make sure to logout/login in order to validate the changes (i3wm)\n"
fi

if [[ $notes ]]; then
  log 'A few last notes'
  printf "$notes"
fi
#= endsection }}}1
