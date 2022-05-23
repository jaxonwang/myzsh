#!/usr/bin/env bash

# this script is modified from https://github.com/wfxr/tmux-power

SDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# $1: option
# $2: default value
tmux_get() {
    local value="$(tmux show -gqv "$1")"
    [ -n "$value" ] && echo "$value" || echo "$2"
}

# $1: option
# $2: value
tmux_set() {
    tmux set-option -gq "$1" "$2"
}

# Options
right_arrow_icon=$(tmux_get '@tmux_power_right_arrow_icon' '')
left_arrow_icon=$(tmux_get '@tmux_power_left_arrow_icon' '')
upload_speed_icon=$(tmux_get '@tmux_power_upload_speed_icon' '')
download_speed_icon=$(tmux_get '@tmux_power_download_speed_icon' '')
session_icon="$(tmux_get '@tmux_power_session_icon' '')"
user_icon="$(tmux_get '@tmux_power_user_icon' '')"
time_icon="$(tmux_get '@tmux_power_time_icon' '')"
date_icon="$(tmux_get '@tmux_power_date_icon' '')"
show_upload_speed="$(tmux_get @tmux_power_show_upload_speed false)"
show_download_speed="$(tmux_get @tmux_power_show_download_speed false)"
show_web_reachable="$(tmux_get @tmux_power_show_web_reachable false)"
prefix_highlight_pos=$(tmux_get @tmux_power_prefix_highlight_pos)
time_format=$(tmux_get @tmux_power_time_format '%T')
date_format=$(tmux_get @tmux_power_date_format '%F')

# short for Theme-Colour
TMUX_HASH_THEME=$(tmux_get @tmux_hash_theme false)
if [[ $TMUX_HASH_THEME = true ]]; then
# set color by hostname hash
TC=$(PYTHONHASHSEED=0 python3 - << EOF
import socket
import random as r
r.seed(socket.gethostname())
pick = ["00", "5f", "87", "af", "d7", "ff"]
p1 = [0, 0, 0]
while sum(p1) <= 6:  # too dark
    p1 = [r.randrange(6), r.randrange(6), r.randrange(6) % 6]
print("#%s%s%s" % (pick[p1[0]], pick[p1[1]], pick[p1[2]]))
EOF
)
else
    TC=$(tmux_get '@tmux_power_theme' 'gold')
fi
case $TC in
    'gold' )
        TC='#ffb86c'
        ;;
    'redwine' )
        TC='#b34a47'
        ;;
    'moon' )
        TC='#00abab'
        ;;
    'forest' )
        TC='#228b22'
        ;;
    'violet' )
        TC='#9370db'
        ;;
    'snow' )
        TC='#fffafa'
        ;;
    'coral' )
        TC='#ff7f50'
        ;;
    'sky' )
        TC='#87ceeb'
        ;;
    'default' ) # Useful when your term changes colour dynamically (e.g. pywal)
        TC='colour3'
        ;;
esac

G01=#080808 #232
G02=#121212 #233
G03=#1c1c1c #234
G04=#262626 #235
G05=#303030 #236
G06=#3a3a3a #237
G07=#444444 #238
G08=#4e4e4e #239
G09=#585858 #240
G10=#626262 #241
G11=#6c6c6c #242
G12=#767676 #243

FG="$G10"
BG="$G04"

# Status options
tmux_set status-interval 1
tmux_set status on

# Basic status bar colors
tmux_set status-fg "$FG"
tmux_set status-bg "$BG"
tmux_set status-attr none

# tmux-prefix-highlight
tmux_set @prefix_highlight_fg "$BG"
tmux_set @prefix_highlight_bg "$FG"
tmux_set @prefix_highlight_show_copy_mode 'on'
tmux_set @prefix_highlight_copy_mode_attr "fg=$TC,bg=$BG,bold"
tmux_set @prefix_highlight_output_prefix "#[fg=$TC]#[bg=$BG]$left_arrow_icon#[bg=$TC]#[fg=$BG]"
tmux_set @prefix_highlight_output_suffix "#[fg=$TC]#[bg=$BG]$right_arrow_icon"

#     
# Left side of status bar
tmux_set status-left-bg "$G04"
tmux_set status-left-fg "G12"
tmux_set status-left-length 150

# User and host
user=$(whoami)
LS="#[fg=$G04,bg=$TC,bold] $user_icon $user@#h #[fg=$TC,bg=$G06,nobold]$right_arrow_icon"
# Session
LS="$LS#[fg=$TC,bg=$G06] $session_icon #S "

# Status indicator
LS="$LS#{tmux_mode_indicator}"
# cpu memory usage
cpu_mem_usage="#($SDIR/tmux-widget/target/release/tmux-widget --cpu --mem --with-icons)"
LS="$LS#[fg=$TC,bg=$G06] $cpu_mem_usage #[fg=$G06,bg=$BG]$right_arrow_icon"

if [[ $prefix_highlight_pos == 'L' || $prefix_highlight_pos == 'LR' ]]; then
    LS="$LS#{prefix_highlight}"
fi
tmux_set status-left "$LS"

# Right side of status bar
tmux_set status-right-bg "$G04"
tmux_set status-right-fg "G12"
tmux_set status-right-length 150
RS="#[fg=$TC,bg=$G06] $time_icon $time_format #[fg=$TC,bg=$G06]$left_arrow_icon#[fg=$G04,bg=$TC] $date_icon $date_format "

# netowork bandwidth
network_speed="#($SDIR/tmux-widget/target/release/tmux-widget --net --with-icons)"
RS="#[fg=$G05,bg=$BG]$left_arrow_icon#[fg=$TC,bg=$G05] $network_speed #[fg=$G06,bg=$G05]$left_arrow_icon$RS"

if "$show_web_reachable"; then
    RS=" #{web_reachable_status} $RS"
fi
if [[ $prefix_highlight_pos == 'R' || $prefix_highlight_pos == 'LR' ]]; then
    RS="#{prefix_highlight}$RS"
fi
tmux_set status-right "$RS"

# Window status
tmux_set window-status-format " #I:#W#F "
tmux_set window-status-current-format "#[fg=$BG,bg=$G06]$right_arrow_icon#[fg=$TC,bold] #I:#W#F #[fg=$G06,bg=$BG,nobold]$right_arrow_icon"

# Window separator
tmux_set window-status-separator ""

# Window status alignment
tmux_set status-justify centre

# Current window status
tmux_set window-status-current-statys "fg=$TC,bg=$BG"

# Pane border
tmux_set pane-border-style "fg=$G07,bg=default"

# Active pane border
tmux_set pane-active-border-style "fg=$TC,bg=$BG"

# Pane number indicator
tmux_set display-panes-colour "$G07"
tmux_set display-panes-active-colour "$TC"

# Clock mode
tmux_set clock-mode-colour "$TC"
tmux_set clock-mode-style 24

# Message
tmux_set message-style "fg=$TC,bg=$BG"

# Command message
tmux_set message-command-style "fg=$TC,bg=$BG"

# Copy mode highlight
tmux_set mode-style "bg=$TC,fg=$FG"

# Set the style of mode indicator
tmux_set @mode_indicator_prefix_prompt "$right_arrow_icon WAIT $left_arrow_icon"
tmux_set @mode_indicator_copy_prompt "$right_arrow_icon COPY $left_arrow_icon"
tmux_set @mode_indicator_sync_prompt "$right_arrow_icon SYNC $left_arrow_icon"
tmux_set @mode_indicator_empty_prompt "$right_arrow_icon TMUX $left_arrow_icon"
tmux_set @mode_indicator_prefix_mode_style "bg=blue,fg=$G06"
tmux_set @mode_indicator_copy_mode_style "bg=yellow,fg=$G06"
tmux_set @mode_indicator_sync_mode_style "bg=red,fg=$G06"
tmux_set @mode_indicator_empty_mode_style "bg=cyan,fg=$G06"
source "$SDIR/tmux-mode-indicator/mode_indicator.tmux"
