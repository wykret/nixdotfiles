#!/usr/bin/env bash

# 1) Descobre o monitor atual no i3
FOCUSED_OUTPUT=$(i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).output')

# 2) Pega a geometria dele (ex: 1920x1080+1920+0)
GEOMETRY=$(xrandr | awk -v mon="$FOCUSED_OUTPUT" '
$0 ~ mon" connected" {
    match($0, /[0-9]+x[0-9]+\+[0-9]+\+[0-9]+/)
    print substr($0, RSTART, RLENGTH)
}')

# 3) Usa maim com -g GEOMETRY para capturar só a área desse monitor
#    e copia o resultado para o clipboard usando xclip
maim -g "$GEOMETRY" | xclip -selection clipboard -t image/png

