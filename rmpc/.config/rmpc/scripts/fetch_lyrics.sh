#!/bin/bash
# 1. Gather exact file and tag information from MPD
RELATIVE_TRACK_PATH=$(mpc current -f "%file%")
ARTIST=$(mpc current -f "%artist%")
TITLE=$(mpc current -f "%title%")
# Exit if MPD tags are empty
if [ -z "$ARTIST" ] || [ -z "$TITLE" ] || [ -z "$RELATIVE_TRACK_PATH" ]; then
    exit 0
fi
# 2. Construct the exact local target path inside your /flows root directory
MUSIC_ROOT="/home/collyArch/Music/flows"
CLEAN_DIR=$(dirname "$RELATIVE_TRACK_PATH")
CLEAN_FILE=$(basename "$RELATIVE_TRACK_PATH" | sed 's/\.[^.]*$//') # Drops trailing extension (.mp3)
TARGET_LRC_PATH="${MUSIC_ROOT}/${CLEAN_DIR}/${CLEAN_FILE}.lrc"
# Exit instantly if the .lrc file already sits on your drive
if [ -f "$TARGET_LRC_PATH" ]; then
    exit 0
fi
# 3. Clean API search queries using a RegEx filter
CLEAN_ARTIST=$(echo "$ARTIST" | sed -E 's/\s*[([].*(Remastered|Deluxe|Live|Studio|Bonus|Edition).*[])]//gI')
CLEAN_TITLE=$(echo "$TITLE" | sed -E 's/\s*[([].*(Remastered|Deluxe|Live|Studio|Bonus|Edition).*[])]//gI')
# Encode the parameters securely for the API request
ENCODED_ARTIST=$(jq -rn --arg str "$CLEAN_ARTIST" '$str | @uri')
ENCODED_TITLE=$(jq -rn --arg str "$CLEAN_TITLE" '$str | @uri')
# Target the correct LRCLIB endpoint
API_URL="https://lrclib.net/api/get?artist_name=${ENCODED_ARTIST}&track_name=${ENCODED_TITLE}"
RESPONSE=$(curl -s "$API_URL")
# 4. Extract and write synchronized timeline properties
SYNCED_LYRICS=$(echo "$RESPONSE" | jq -r '.syncedLyrics // empty')
if [ -n "$SYNCED_LYRICS" ] && [ "$SYNCED_LYRICS" != "null" ]; then
    mkdir -p "$(dirname "$TARGET_LRC_PATH")"
    echo "$SYNCED_LYRICS" > "$TARGET_LRC_PATH"
    exit 0
fi
# 5. Fallback: Save static plaintext words
PLAIN_LYRICS=$(echo "$RESPONSE" | jq -r '.plainLyrics // empty')
if [ -n "$PLAIN_LYRICS" ] && [ "$PLAIN_LYRICS" != "null" ]; then
    mkdir -p "$(dirname "$TARGET_LRC_PATH")"
    echo "$PLAIN_LYRICS" > "$TARGET_LRC_PATH"
    exit 0
fi
