#!/bin/bash
MUSIC_ROOT="/home/collyArch/Music"

find "$MUSIC_ROOT" -name "*.mp3" -o -name "*.flac" | while read -r file; do
    CLEAN_FILE="${file%.*}"
    LRC_FILE="${CLEAN_FILE}.lrc"

    # Skip if already exists
    [ -f "$LRC_FILE" ] && continue

    # Extract tags directly from file
    ARTIST=$(ffprobe -v quiet -show_entries format_tags=artist -of default=nw=1:nk=1 "$file")
    TITLE=$(ffprobe -v quiet -show_entries format_tags=title -of default=nw=1:nk=1 "$file")

    [ -z "$ARTIST" ] || [ -z "$TITLE" ] && continue

    ENCODED_ARTIST=$(jq -rn --arg str "$ARTIST" '$str | @uri')
    ENCODED_TITLE=$(jq -rn --arg str "$TITLE" '$str | @uri')

    RESPONSE=$(curl -s "https://lrclib.net/api/get?artist_name=${ENCODED_ARTIST}&track_name=${ENCODED_TITLE}")

    SYNCED=$(echo "$RESPONSE" | jq -r '.syncedLyrics // empty')
    if [ -n "$SYNCED" ]; then
        echo "$SYNCED" > "$LRC_FILE"
        echo "✓ synced: $TITLE"
        continue
    fi

    PLAIN=$(echo "$RESPONSE" | jq -r '.plainLyrics // empty')
    if [ -n "$PLAIN" ]; then
        echo "$PLAIN" > "$LRC_FILE"
        echo "~ plain: $TITLE"
        continue
    fi

    echo "✗ not found: $TITLE"
done
