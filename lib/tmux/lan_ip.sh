#!/usr/bin/env bash

color_ok=$1
color_error=$2

# Find the ip for the first valid connected interface
ifaces=$(ip addr show | cut -d ' ' -f2 | tr -d ':')
for iface in $ifaces; do
  # skip loopback interface
  [[ "$iface" = 'lo' ]] && continue

  # skip virtuabox interfaces
  [[ "$iface" =~ 'vboxnet' ]] && continue

  ip=$(ip addr show $iface | grep '\<inet\>' | tr -s ' ' | cut -d ' ' -f3 | cut -d '/' -f1)
  [[ $ip ]] && break
done

if [[ $ip ]]; then
  echo "#[fg=$color_ok]$ip"
else
  echo "#[fg=$color_error]<No IP>"
fi
