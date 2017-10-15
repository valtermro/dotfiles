#!/bin/bash

if [[ $(type -p termite) ]]; then
  i3-msg 'exec termite'
elif [[ $(type -p xfce4-terminal) ]]; then
  i3-msg 'exec xfce4-terminal'
elif [[ $(type -p mate-terminal) ]]; then
  i3-msg 'exec mate-terminal'
elif [[ $(type -p gnome-terminal) ]]; then
  i3-msg 'exec gnome-terminal'
elif [[ $(type -p xterm) ]]; then
  i3-msg 'exec xterm'
fi
