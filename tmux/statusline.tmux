color_default=colour248
color_active=colour4
color_inactive=colour245
color_attention=colour3
color_alert=colour5
color_secondary=colour16

set -g status-interval 10

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
setw -g message-fg $color_alert
setw -g message-bg default

setw -g display-panes-colour $color_inactive
setw -g display-panes-active-colour $color_active

session="#[fg=$color_secondary]#S"
host="#[fg=$color_secondary]#h"
hour="#[fg=$color_secondary]%R"
date="#[fg=$color_default]%d %b (%a)"
mail="#[fg=$color_default]#($X_LIB_HOME/tmux/mail_counter.sh)"

set -g status-left-length 50
set -g status-right-length 150
set -g status-left "$session "
set -g status-right "$mail $hour $date $host"
