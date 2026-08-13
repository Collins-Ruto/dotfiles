#!/usr/bin/env bash

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/quickshell"
color_path="$STATE_DIR/user/generated/material_colors.scss"

foot_config="$HOME/.config/foot/colors.ini"

declare -A term

while read -r line; do
    if [[ $line == \$term* ]]; then
        name=$(echo "$line" | awk '{print $1}' | sed 's/\$//;s/://')
        value=$(echo "$line" | awk '{print $2}' | sed 's/#//;s/;//')
        term["$name"]="$value"
    fi
done < "$color_path"

mkdir -p "$(dirname "$foot_config")"

{
    echo "[colors-dark]"
    echo "background=${term[term0]}"

    for i in {0..7}; do
        echo "regular$i=${term[term$i]}"
    done

    for i in {0..7}; do
        echo "bright$i=${term[term$((i+8))]}"
    done
} > "$foot_config"

# Reload running foot instances if supported
pkill -SIGUSR1 foot 2>/dev/null || true
