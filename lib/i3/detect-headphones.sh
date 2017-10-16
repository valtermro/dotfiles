#!/bin/bash

[[ ! $(type -p pacmd) ]] && exit

headphones_port=$(
  pacmd list-sinks |\
  # get all lines between the beginning of the active sink and the beginning of the next one
  sed -En '/^[^\t]*\* index: [0-9]+$/,/^[^\t]*$/p' |\
  # get only the data about the active sink
  sed $'/^[^\t]/d' |\
  # find the header for the headphones' port
  grep -E '.+-output-headphones:')

if [[ $headphones_port =~ 'available: yes' ]]; then
  sink_idx=$(pacmd list-sinks | grep '\* index: [0-9]\+' | cut -d':' -f2)
  port_name=$(echo $headphones_port | cut -d':' -f1)
  pacmd set-sink-port $sink_idx $port_name
fi
