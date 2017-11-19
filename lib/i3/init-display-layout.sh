#!/bin/bash

main_workspace=$1
external_display=$(xrandr | grep '\<connected\>'| cut -d' ' -f1 | grep 'HDMI')

if [[ $external_display ]]; then
  $X_DOTFILES/bin/dlayout eleft
  i3-msg "workspace $main_workspace; move workspace to output $external_display"
  # start a terminal here to make sure it opens in the main workspace
  i3-msg 'exec --no-startup-id i3-sensible-terminal'
  i3-msg 'restart'
fi
