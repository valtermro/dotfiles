set -g default-command /bin/zsh
set -g default-terminal screen-256color
set -g escape-time 1
set -g history-limit 10000
set -g mouse on
set -g mode-keys vi
set -g renumber-windows on
set -g status-keys vi

setw -g base-index 1
setw -g pane-base-index 1
setw -g monitor-activity off
setw -g xterm-keys on

source $XDG_CONFIG_HOME/tmux/mappings.tmux
source $XDG_CONFIG_HOME/tmux/statusline.tmux
