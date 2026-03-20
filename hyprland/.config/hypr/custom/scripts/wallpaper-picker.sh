#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/hd wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-thumbs"
SWITCHWALL="$HOME/.config/quickshell/ii/scripts/colors/switchwall.sh"
RASI="$HOME/.config/rofi/themes/wallpaper-selector.rasi"

mkdir -p "$CACHE_DIR"

# Generate square cropped thumbnails with ffmpeg
function cacheImg {
    resolution=$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$1")
    width_=$(echo "${resolution}" | awk -F',' '{print $1}')
    height_=$(echo "${resolution}" | awk -F',' '{print $2}')
    if [ "${width_}" -lt "${height_}" ]; then
        ffmpeg -i "$1" -loglevel quiet -vf "scale=600:-1, crop=600:600:0:(ih-600)/2" "$2"
    else
        ffmpeg -i "$1" -loglevel quiet -vf "scale=-1:600, crop=600:600:(iw-600)/2:0" "$2"
    fi
}

declare -A bgresult
declare -A cachedresult
bgnames=()

mapfile -t originPath < <(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \))

for path in "${originPath[@]}"; do
    filename=$(basename "${path%.*}")
    bgresult["$filename"]="$path"
    bgnames+=("$filename")
done

# Generate missing thumbnails
for fName in "${bgnames[@]}"; do
    cached="$CACHE_DIR/${fName}.png"
    if [ ! -f "$cached" ]; then
        cacheImg "${bgresult[$fName]}" "$cached"
        cachedresult["$fName"]="$cached"
    else
        cachedresult["$fName"]="$cached"
    fi
done

# Build rofi input
strrr=""
for fName in "${bgnames[@]}"; do
    strrr+="$(echo -n "${fName:0:20}\0icon\x1f${cachedresult[$fName]}\x1fmeta\x1f${fName}\n")"
  done

selected=$(echo -en "${strrr}" | rofi -dmenu -p "Wallpaper" -config "$RASI")

if [ -n "$selected" ]; then
    "$SWITCHWALL" "${bgresult[$selected]}"
fi
