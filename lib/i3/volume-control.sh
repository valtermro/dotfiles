#!/bin/bash

volume=$1
[[ ! $volume ]] && exit

# get the active sink from `pacmd`
# TODO: Can `pactl` be used for both sink detection (headphones) and volume control?
sink_idx=$(pacmd list-sinks | grep '\* index: [0-9]\+' | cut -d':' -f2)

if [[ $volume == 'up' ]]; then
  pactl set-sink-volume $sink_idx +5%
elif [[ $volume == 'down' ]]; then
  pactl set-sink-volume $sink_idx -5%
elif [[ $volume == 'toggle-mute' ]]; then
  pactl set-sink-mute $sink_idx toggle
fi
