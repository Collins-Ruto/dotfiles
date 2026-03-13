#!/usr/bin/env bash

color_path="$HOME/.cache/ags/user/generated/material_colors.scss"
foot_config="$HOME/.config/foot/colors.ini"

declare -A term

# Read AGS generated colors
while read -r line; do
    if [[ $line == \$term* ]]; then
        name=$(echo "$line" | awk '{print $1}' | sed 's/\$//;s/://')
        value=$(echo "$line" | awk '{print $2}' | sed 's/#//;s/;//')
        term["$name"]="$value"
    fi
done < "$color_path"

mkdir -p "$(dirname "$foot_config")"

{
    echo "[colors]"
    echo "background=${term[term0]}"

    for i in {0..7}; do
        echo "regular$i=${term[term$i]}"
    done

    for i in {0..7}; do
        echo "bright$i=${term[term$((i+8))]}"
    done
} > "$foot_config"
