#= Basics
#==================================================
bind r source-file ~/.tmux.conf \; display 'Config reloaded!'

#= Copy/Paste
#==================================================
bind -t vi-copy 'v' begin-selection
bind -t vi-copy 'y' copy-pipe 'xclip -in -selection clipboard'
bind -t vi-copy 'r' rectangle-toggle

#= Creating windows and panes
#==================================================
bind c new-window -c "#{pane_current_path}"
bind i split-window -h -c "#{pane_current_path}"
bind - split-window -v -c "#{pane_current_path}"

#= Resizing panes
#==================================================
bind k resize-pane -U 5
bind j resize-pane -D 5
bind l resize-pane -R 10
bind h resize-pane -L 10

#= Switching panes
#==================================================
bind ^b last-pane
bind ^h select-pane -L
bind ^j select-pane -D
bind ^k select-pane -U
bind ^l select-pane -R
