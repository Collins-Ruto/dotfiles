#!/bin/sh
# Kill rofi if the click landed outside its layer surface
pgrep -x rofi >/dev/null || exit 0

cursor=$(hyprctl cursorpos -j | jq -r '"\(.x|floor) \(.y|floor)"')
box=$(hyprctl layers -j | jq -r '[.. | objects | select(.namespace? == "rofi")] | first | "\(.x) \(.y) \(.w) \(.h)"')

[ -z "$box" ] && exit 0
case "$box" in *null*) exit 0 ;; esac

set -- $cursor $box   # $1,$2 = cursor x,y; $3,$4,$5,$6 = box x,y,w,h
if [ "$1" -lt "$3" ] || [ "$1" -gt $(($3 + $5)) ] || [ "$2" -lt "$4" ] || [ "$2" -gt $(($4 + $6)) ]; then
    pkill -x rofi
fi
