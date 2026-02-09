#!/bin/sh

VOLUME_MUTE="🔇"
VOLUME_LOW="🔈"
VOLUME_MID="🔉"
VOLUME_HIGH="🔊"

SINK=$(pactl get-default-sink)

case "$BLOCK_BUTTON" in
    1) pavucontrol & ;;                     # clique esquerdo
    2) pactl set-sink-mute "$SINK" toggle ;;# clique do meio
    4) pactl set-sink-volume "$SINK" +5% ;; # scroll up
    5) pactl set-sink-volume "$SINK" -5% ;; # scroll down
esac

SOUND_LEVEL=$(pactl get-sink-volume "$SINK" | awk -F'/' '/Volume/ {sum+=$2; n++} END{gsub(/%/,"",sum); printf("%d\n", sum/n)}')
MUTED=$(pactl get-sink-mute "$SINK" | awk '{print ($2=="yes" ? 1 : 0)}')

if [ "$MUTED" = "1" ]; then
    ICON="$VOLUME_MUTE"
elif [ "$SOUND_LEVEL" -lt 34 ]; then
    ICON="$VOLUME_LOW"
elif [ "$SOUND_LEVEL" -lt 67 ]; then
    ICON="$VOLUME_MID"
else
    ICON="$VOLUME_HIGH"
fi

echo "$ICON:$SOUND_LEVEL%"

