#!/bin/sh

# Requires: playerctl, jq, coreutils
player_name=${1:-$(playerctl -l | head -n 1)}

if [ -z "$player_name" ]; then
    echo "No player"
    exit 0
fi

while true; do
    status=$(playerctl -p "$player_name" status 2>/dev/null)
    if [ "$status" = "Playing" ]; then
        icon="  "
    elif [ "$status" = "Paused" ]; then
        icon="  "
    else
        icon="  "
    fi

    artist=$(playerctl -p "$player_name" metadata artist 2>/dev/null)
    title=$(playerctl -p "$player_name" metadata title 2>/dev/null)

    if [ -n "$title" ]; then
        if [ -n "$artist" ]; then
            text="$icon  $artist - $title"
        else
            text="$icon  $title"
        fi
        # Puts the text in a continuous scroll of 40 characters using GNU coreutils 'tail' and 'seq'
        echo "$text" | awk '{for(i=1;i<=40;i++)printf " ";print}' | fold -w1 | sed -e :a -e '$q;N;s/\n//;ta' | sed -r ':l;s/^(.)(.*)/\2\1/;p;s/.*//;q'
    else
        echo "Stopped"
    fi
    sleep 0.3
done
EOF
