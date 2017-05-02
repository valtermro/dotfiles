#!/usr/bin/env bash

color_charging=$1
color_discharging=$2
color_critical=$3

if [[ ! $(which upower) ]]; then
  exit 0
fi

battery=$(upower --enumerate | grep battery_BAT)
if [[ ! $battery ]]; then
  exit 0
fi

function get_value_of {
  local label=$1
  upower -i $battery | grep "${label}" | sed -r "s/.*${label}:[[:space:]]*(.*).*/\1/"
}

state=$(get_value_of 'state')
if [[ $state == 'fully-charged' ]]; then
  exit 0
fi

time_to_emtpy=''
percentage=$(get_value_of 'percentage' | grep -o '[[:digit:]]*')

if [[ $state = 'charging' ]]; then
  color=$color_charging
else
  time_to_emtpy=" ($(get_value_of 'time to .*'))"

  if [[ $percentage -lt 30 ]]; then
    color=$color_critical
  else
    color=$color_discharging
  fi
fi

echo "#[fg=$color]☈ ${percentage}%${time_to_emtpy} "
