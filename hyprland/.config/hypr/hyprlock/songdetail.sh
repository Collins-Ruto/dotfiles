#!/bin/bash

# Get active player
current_player=$(playerctl -l | grep -E 'spotify|firefox|brave|vlc' | while read player; do
    player_name=$(echo "$player" | sed 's/\..*//')
    status=$(playerctl -p "$player" status 2>/dev/null)
    [[ "$status" == "Playing" ]] && echo "$player_name" && break
done)

# Set player icons
case "$current_player" in
    "spotify") icon="" ;;
    "firefox"|"brave") icon="" ;;
    "vlc") icon="嗢" ;;
    *) icon="" ;;
esac

# Extract metadata based on player
if [[ -n "$current_player" ]]; then
    if [[ "$current_player" == "vlc" ]]; then
        # Handle VLC's messy metadata: use filename if title is empty
        title=$(playerctl -p vlc metadata --format '{{title}}' 2>/dev/null)
        artist=$(playerctl -p vlc metadata --format '{{artist}}' 2>/dev/null)
        
        if [[ -z "$title" || "$title" == " " ]]; then
            # Fallback: extract filename from URL (URI-decoded)
            url=$(playerctl -p vlc metadata --format '{{xesam:url}}' 2>/dev/null)
            title=$(basename "$url" | sed 's/%20/ /g; s/\.mp4$//; s/\.mp3$//; s/\.\w\+$//')
            artist="VLC Media Player"  # Default artist
        fi
        
        song_info="$title${artist:+ - $artist}"
      else
        # Normal players (Spotify/Firefox/Brave)
        song_info=$(playerctl -p "$current_player" metadata --format '{{title}} - {{artist}}' 2>/dev/null)
    fi

    # Trim long output
    max_length=50
    [[ ${#song_info} -gt $max_length ]] && song_info="${song_info:0:$max_length}..."
    echo "$icon $song_info"
else
    # --- Idle Message Options ---
idle_messages=(
    "ﱙ  🪕 Dreaming of beats... ♪"                  # Sleepy
    "ﱙ  ♩ Dreaming of beats... 📻"                  # Sleepy
    "ﱙ  ♭ Silence in space... 🛸"                   # Space
    "ﱙ  🪕 Cricket symphony... ♪"                   # Nature
    "ﱙ  ♩ Game Over... 🔇"                         # Retro
    "ﱙ  🎧 Snail DJ at work... 📻"                  # Funny
    "ﱙ  ❄️ White noise... 🤍"                        # Minimalist
    "🔇 ﱙ The sound of void... ♪"                 # Abstract
    "ﱙ  ♭ Hoot hoot... 🎧"                         # Owl DJ
    "ﱙ  📻 Signal lost... ❌"                        # Retro tech
    "ﱙ  🎧 Ocean of silence... ♩"                  # Beach
)
    echo "${idle_messages[$((RANDOM % ${#idle_messages[@]}))]}"
fi

