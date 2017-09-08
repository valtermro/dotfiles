#!/bin/bash

main_workspace=$1
external_display=$(xrandr | grep '\<connected\>'| cut -d' ' -f1 | grep 'HDMI')

if [[ $external_display ]]; then
  $X_DOTFILES/bin/dlayout eright
  i3-msg "workspace $main_workspace; move workspace to output $external_display"
  i3-msg "restart"
fi
