#!/bin/bash
bl_device=$(ls /sys/class/backlight)
bl_device="/sys/class/backlight/${bl_device[0]}/brightness"
if [[ $1 == up ]]; then
  echo $(($(cat $bl_device)+50)) > $bl_device
elif [[ $1 == down ]]; then
  echo $(($(cat $bl_device)-50)) > $bl_device
fi
