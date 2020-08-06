#### COLOUR

tm_icon="⚡"
tm_color_active=colour214
tm_color_inactive=colour241
tm_color_inactive_pane=colour95
tm_color_feature=colour209
tm_color_music=colour158

# separators
tm_separator_left_bold="◀"
tm_separator_left_thin="❮"
tm_separator_right_bold="▶"
tm_separator_right_thin="❯"

set -g status-left-length 32
set -g status-right-length 150
set -g status-interval 5

# default statusbar colors
# set-option -g status-bg colour0
#set-option -g status-fg $tm_color_active
#set-option -g status-bg default
set-option -g status-style default,bg=default,fg=$tm_color_active

# default window title colors
set-window-option -g window-status-style fg=$tm_color_inactive,bg=default
#set-window-option -g window-status-bg default
set -g window-status-format "#I‣#W"

# active window title colors
set-window-option -g window-status-current-style fg=$tm_color_active,bg=default
#set-window-option -g window-status-current-bg default
set-window-option -g window-status-current-format "#[bold]#I‣#W"

# pane border
set-option -g pane-border-style fg=$tm_color_inactive_pane
set-option -g pane-active-border-style fg=$tm_color_active

# message text
set-option -g message-style bg=default,fg=$tm_color_active
#set-option -g message-fg $tm_color_active

# pane number display
set-option -g display-panes-active-colour $tm_color_active
set-option -g display-panes-colour $tm_color_inactive

set-window-option -g mode-style bg=$tm_color_feature,fg=black

# clock
set-window-option -g clock-mode-colour $tm_color_active

#tm_spotify="#[fg=$tm_color_music]#(osascript $DOTFILES/applescripts/spotify.scpt)"
#tm_itunes="#[fg=$tm_color_music]#(osascript $DOTFILES/applescripts/itunes.scpt)"
tm_battery="#($DOTFILES/bin/battery_indicator.sh)"

tm_date="#[fg=$tm_color_inactive] %R %d %b"
tm_host="#[fg=$tm_color_feature,bold]#h"
tm_session_name="#[fg=$tm_color_feature,bold]$tm_icon #S"

set -g @prefix_highlight_fg colour232
set -g @prefix_highlight_bg colour209

set -g status-left $tm_session_name' '
set -g status-right "#{prefix_highlight}"' '$tm_date' '$tm_host' '$tm_battery
