export TERM=xterm-256color

eval "$(${XDG_DATA_HOME}/base16-shell/profile_helper.sh)"
if [[ ! -f ~/.base16_theme ]]; then
  echo "Using oceanicnext colorscheme"
  base16_oceanicnext
fi
