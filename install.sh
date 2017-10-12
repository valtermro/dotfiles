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

# git_clone() {{{2
#--------------------------------------------------
function git_clone {
  local repo=https://github.com/$1
  local dest=$2/$(basename $repo)

  git clone --quiet --depth=1 $repo $dest
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
ask_install 'vim' 'zsh'
ask_install 'tmux' 'zsh'
ask_install 'i3wm' 'zsh' 'termite' 'dmenu' 'i3status' 'i3-dmenu-desktop'
ask_install 'feh'
ask_install 'termite'
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

  ln -s $self_dir/zshrc ~/.zshrc
  ln -s $self_dir/zshenv ~/.zshenv
  ln -s $self_dir/zprofile ~/.zprofile

  echo 'Installing base16-shell'
  rm_file $HOME/.base16_theme
  rm_file $HOME/.vimrc_background
  rm_dir $XDG_DATA_HOME/base16-shell
  git_clone 'chriskempson/base16-shell' $XDG_DATA_HOME
fi

#- Vim {{{2
#------------------------------------------------
if should_install 'vim'; then
  echo '- vim'

  backup ~/.vim
  backup ~/.vimrc

  ln -s $self_dir/vim ~/.vim
  ln -s $self_dir/vimrc ~/.vimrc

  echo 'Installing vim plugins'
  bash $self_dir/vim/plugins.sh $self_dir/vim
  vim -c 'helptags ALL' -c 'q'
fi

#- Tmux {{{2
#------------------------------------------------
if should_install 'tmux'; then
  echo '- tmux'

  backup ~/.tmux.conf
  ln -s $self_dir/tmux.conf ~/.tmux.conf
fi

#- i3wm {{{2
#------------------------------------------------
if should_install 'i3wm'; then
  echo '- i3wm'

  backup $XDG_CONFIG_HOME/i3/config
  make_dir $XDG_CONFIG_HOME/i3

  bl_device=$(ls /sys/class/backlight)
  if [[ ${bl_device[0]} ]]; then
    echo
    log 'I need you attention'
    echo "In order to get the brightness control keys to work, you'll need to be able"
    echo "to run '${self_dir}/lib/i3/brightctl.sh' as root without password."
    echo "I can help you here creating a group with that power and adding you to it."
    echo "For that, I'll need your sudo password, just once."
    if ask "Do you want to create the 'brightctl' group"; then
      bl_device="/sys/class/backlight/${bl_device[0]}/brightness"
      sudo groupadd brightctl 2>/dev/null
      sudo usermod -aG brightctl $USER
      echo "%brightctl ALL=(ALL) NOPASSWD: ${self_dir}/lib/i3/brightctl.sh" > /tmp/brightctl.sudoers
      sudo chown root: /tmp/brightctl.sudoers
      sudo mv /tmp/brightctl.sudoers /etc/sudoers.d/99-brightctl
      logout_needed=true
    fi
  fi

  $self_dir/lib/i3/reload-config.sh $self_dir
fi

#- feh {{{2
#------------------------------------------------
if should_install 'feh'; then
  echo '- feh'

  backup $XDG_CONFIG_HOME/feh
  make_dir $XDG_CONFIG_HOME
  ln -s $self_dir/feh $XDG_CONFIG_HOME/feh
fi

#- feh {{{2
#------------------------------------------------
if should_install 'feh'; then
  echo '- feh'

  backup $XDG_CONFIG_HOME/feh
  make_dir $XDG_CONFIG_HOME
  ln -s $self_dir/feh $XDG_CONFIG_HOME/feh
fi

#- Termite {{{2
#------------------------------------------------
if should_install 'termite'; then
  echo '- termite'

  backup $XDG_CONFIG_HOME/termite
  make_dir $XDG_CONFIG_HOME
  make_dir $XDG_DATA_HOME/fonts
  ln -s $self_dir/termite $XDG_CONFIG_HOME/termite

  echo 'Installing Moncaco.ttf'
  rm_dir $XDG_DATA_HOME/fonts/monaco.ttf
  git_clone 'todylu/monaco.ttf' $XDG_DATA_HOME/fonts
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

  if ! is_installed 'pamixer'; then
    notes="${notes} - 'pamixer' is required for volume control (i3wm)\n"
  fi

  if ! is_installed 'udiskie'; then
    notes="${notes} - You might want to install 'udiskie' for usb automonting (i3wm)\n"
  fi
fi

if should_install 'termite'; then
  font_in_use=$(\
    cat $XDG_CONFIG_HOME/termite/config |\
    grep 'font\b' |\
    sed 's/font\s\?=\s\?//' |\
    sed 's/\s[0-9]\+$//')
  notes="${notes} - Make sure the font '${font_in_use}' is installed (termite)\n"
fi

if [[ $logout_needed == true ]]; then
  notes="${notes} - Make sure to logout/login in order to validate the changes (i3wm)\n"
fi

if [[ $notes ]]; then
  log 'A few last notes'
  printf "$notes"
fi
#= endsection }}}1
