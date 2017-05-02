LIB=$X_LIB_HOME/tmux

color_default=colour248
color_active=colour4
color_inactive=colour245
color_attention=colour3
color_message=colour9
color_secondary=colour16
color_attention=colour9
color_critical=colour3

set -g status-interval 1

setw -g status-fg $color_inactive
setw -g status-bg default

setw -g window-status-format '#I:#W'
setw -g window-status-fg default
setw -g window-status-bg default

setw -g window-status-current-format '#I:#W'
setw -g window-status-current-attr none
setw -g window-status-current-fg $color_active
setw -g window-status-current-bg default

setw -g window-status-activity-attr none
setw -g window-status-activity-fg $color_attention
setw -g window-status-activity-bg default

setw -g pane-border-fg default
setw -g pane-active-border-fg $color_active
setw -g pane-active-border-bg default

setw -g message-attr none
setw -g message-fg $color_message
setw -g message-bg default

setw -g display-panes-colour $color_inactive
setw -g display-panes-active-colour $color_active

session="#[fg=$color_secondary]#S"
host="#[fg=$color_secondary]#h"
hour="#[fg=$color_secondary]%R"
date="#[fg=$color_default]%d %b (%a)"
mail="#[fg=$color_default]#($LIB/mail_counter.sh)"
battery="#($LIB/battery_status.sh $color_active $color_attention $color_critical)"

set -g status-left-length 50
set -g status-right-length 150
set -g status-left "$session "
set -g status-right "$mail$battery$hour $date $host"
