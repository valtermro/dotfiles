[[ -f /etc/profile ]] && emulate sh -c 'source /etc/profile'

if [ -z "$DISPLAY" ] && [ -n "$XDG_VTNR" ] && [ "$XDG_VTNR" -eq 1 ] && [ -f ~/.xinitrc ]; then
  exec startx
fi
