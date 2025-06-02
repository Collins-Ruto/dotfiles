#!/bin/bash

# Universal Cheatsheet Program
# Usage: cheat.sh [search_term]

CHEAT_DIR="$HOME/.config/cheatsheets"
TEMP_FILE="/tmp/cheat_search_$$"

export EDITOR=nvim

load_pywal_colors() {
    if [ -f "$HOME/.cache/wal/colors.sh" ]; then
        source "$HOME/.cache/wal/colors.sh"
        # Convert pywal hex colors to ANSI escape sequences
        RED="\033[38;2;$(printf '%d;%d;%d' 0x${color1:1:2} 0x${color1:3:2} 0x${color1:5:2})m"
        GREEN="\033[38;2;$(printf '%d;%d;%d' 0x${color2:1:2} 0x${color2:3:2} 0x${color2:5:2})m"
        BLUE="\033[38;2;$(printf '%d;%d;%d' 0x${color4:1:2} 0x${color4:3:2} 0x${color4:5:2})m"
        YELLOW="\033[38;2;$(printf '%d;%d;%d' 0x${color3:1:2} 0x${color3:3:2} 0x${color3:5:2})m"
        CYAN="\033[38;2;$(printf '%d;%d;%d' 0x${color6:1:2} 0x${color6:3:2} 0x${color6:5:2})m"
        PURPLE="\033[38;2;$(printf '%d;%d;%d' 0x${color5:1:2} 0x${color5:3:2} 0x${color5:5:2})m"
        NC='\033[0m'
        return 0
    else
        # Fallback colors
        RED='\033[0;31m'
        GREEN='\033[0;32m'
        BLUE='\033[0;34m'
        YELLOW='\033[1;33m'
        CYAN='\033[0;36m'
        PURPLE='\033[0;35m'
        NC='\033[0m'
        return 1
    fi
}



# Initial color loading
load_pywal_colors

# Create cheatsheet directory if it doesn't exist
mkdir -p "$CHEAT_DIR"

# Initialize with some example cheatsheets if directory is empty
init_cheatsheets() {
    if [ ! "$(ls -A $CHEAT_DIR)" ]; then
        cat > "$CHEAT_DIR/vim.md" << 'EOF'
# Vim Cheatsheet

## Navigation
- `h j k l` - Left, Down, Up, Right
- `w b` - Next/Previous word
- `0 $` - Beginning/End of line
- `gg G` - Top/Bottom of file
- `Ctrl+f Ctrl+b` - Page down/up

## Editing
- `i a` - Insert before/after cursor
- `I A` - Insert at beginning/end of line
- `o O` - Open line below/above
- `dd` - Delete line
- `yy` - Yank (copy) line
- `p P` - Paste after/before

## Search & Replace
- `/pattern` - Search forward
- `?pattern` - Search backward
- `n N` - Next/Previous match
- `:%s/old/new/g` - Replace all occurrences
EOF

        cat > "$CHEAT_DIR/bash.md" << 'EOF'
# Bash Cheatsheet

## File Operations
- `ls -la` - List files with details
- `cd -` - Go to previous directory
- `cp -r` - Copy recursively
- `mv` - Move/rename files
- `rm -rf` - Remove recursively and forcefully
- `find . -name "*.txt"` - Find files by name

## Text Processing
- `grep -r "pattern" .` - Search in files recursively
- `sed 's/old/new/g'` - Replace text
- `awk '{print $1}'` - Print first column
- `sort | uniq` - Sort and remove duplicates
- `head -n 10` - First 10 lines
- `tail -f` - Follow file changes

## Process Management
- `ps aux` - List all processes
- `kill -9 PID` - Force kill process
- `jobs` - List background jobs
- `Ctrl+Z` then `bg` - Background process
- `nohup command &` - Run in background
EOF

        cat > "$CHEAT_DIR/git.md" << 'EOF'
# Git Cheatsheet

## Basic Commands
- `git status` - Check repository status
- `git add .` - Stage all changes
- `git commit -m "message"` - Commit changes
- `git push` - Push to remote
- `git pull` - Pull from remote
- `git clone <url>` - Clone repository

## Branching
- `git branch` - List branches
- `git checkout -b <branch>` - Create and switch branch
- `git merge <branch>` - Merge branch
- `git branch -d <branch>` - Delete branch

## History
- `git log --oneline` - Compact log
- `git diff` - Show changes
- `git reset --hard HEAD~1` - Reset to previous commit
- `git stash` - Temporarily save changes
EOF
    fi
}

# Function to display help
show_help() {
    echo -e "${BLUE}Universal Cheatsheet Program${NC}"
    echo
    echo -e "${YELLOW}Commands:${NC}"
    echo -e "  ${GREEN}help${NC}           - Show this help"
    echo -e "  ${GREEN}list${NC}           - List available cheatsheets"
    echo -e "  ${GREEN}pick${NC}           - Pick cheatsheet with fzf"
    echo -e "  ${GREEN}browse${NC}         - Browse all cheatsheets with fzf"
    echo -e "  ${GREEN}edit <topic>${NC}   - Edit cheatsheet for topic"
    echo -e "  ${GREEN}new <topic>${NC}    - Create new cheatsheet"
    echo -e "  ${GREEN}man [command]${NC}  - Search man pages (interactive if no command)"
    echo -e "  ${GREEN}wiki <term>${NC}    - Search Arch Wiki"
    echo -e "  ${GREEN}tldr <command>${NC} - Show tldr page"
    echo -e "  ${GREEN}navi${NC}           - Interactive navi cheatsheets"
    echo -e "  ${GREEN}theme [image]${NC}  - Apply pywal theme (interactive if no image)"
    echo -e "  ${GREEN}colors${NC}         - Show current pywal colors"
    echo -e "  ${GREEN}regen${NC}          - Regenerate colors from current wallpaper"
    echo -e "  ${GREEN}reload${NC}         - Reload pywal colors"
    echo -e "  ${GREEN}q${NC} or ${GREEN}quit${NC}      - Exit"
    echo
    echo -e "${YELLOW}Search:${NC}"
    echo -e "  ${CYAN}<term>${NC}         - Search all cheatsheets"
    echo -e "  ${CYAN}<topic>:<term>${NC} - Search specific topic (e.g., vim:search)"
    echo
}

# Function to list available cheatsheets
list_cheatsheets() {
    echo -e "${BLUE}Available Cheatsheets:${NC}"
    for file in "$CHEAT_DIR"/*.md; do
        if [ -f "$file" ]; then
            basename=$(basename "$file" .md)
            echo -e "  ${GREEN}$basename${NC}"
        fi
    done
    echo
}

# Function to search in cheatsheets
search_cheatsheets() {
    local query="$1"
    local topic=""
    
    # Check if query has topic prefix (topic:term)
    if [[ "$query" == *":"* ]]; then
        topic=$(echo "$query" | cut -d':' -f1)
        query=$(echo "$query" | cut -d':' -f2-)
    fi
    
    echo -e "${BLUE}Searching for: ${YELLOW}$query${NC}"
    if [ -n "$topic" ]; then
        echo -e "${BLUE}In topic: ${YELLOW}$topic${NC}"
    fi
    echo
    
    > "$TEMP_FILE"
    
    if [ -n "$topic" ]; then
        # Search in specific topic
        if [ -f "$CHEAT_DIR/$topic.md" ]; then
            echo -e "${PURPLE}=== $topic ===${NC}" >> "$TEMP_FILE"
            rg -i --context=2 "$query" "$CHEAT_DIR/$topic.md" >> "$TEMP_FILE" 2>/dev/null || \
            grep -i -A2 -B2 "$query" "$CHEAT_DIR/$topic.md" >> "$TEMP_FILE" 2>/dev/null
        else
            echo -e "${RED}Topic '$topic' not found${NC}"
            return 1
        fi
    else
        # Search in all cheatsheets
        for file in "$CHEAT_DIR"/*.md; do
            if [ -f "$file" ]; then
                basename=$(basename "$file" .md)
                if command -v rg >/dev/null 2>&1; then
                    matches=$(rg -i -c "$query" "$file" 2>/dev/null || echo "0")
                else
                    matches=$(grep -i -c "$query" "$file" 2>/dev/null || echo "0")
                fi
                if [ "$matches" -gt 0 ]; then
                    echo -e "${PURPLE}=== $basename ===${NC}" >> "$TEMP_FILE"
                    rg -i --context=2 "$query" "$file" >> "$TEMP_FILE" 2>/dev/null || \
                    grep -i -A2 -B2 "$query" "$file" >> "$TEMP_FILE" 2>/dev/null
                    echo >> "$TEMP_FILE"
                fi
            fi
        done
    fi
    
    if [ -s "$TEMP_FILE" ]; then
        if command -v glow >/dev/null 2>&1; then
            glow "$TEMP_FILE"
        elif command -v jless >/dev/null 2>&1; then
            jless "$TEMP_FILE"
        else
            less -R "$TEMP_FILE"
        fi
    else
        echo -e "${RED}No matches found${NC}"
    fi
    
    rm -f "$TEMP_FILE"
}
show_man() {
    local cmd="$1"
    
    if [ -z "$cmd" ]; then
        if command -v fzf >/dev/null 2>&1; then
            cmd=$(find /usr/share/man/man* -type f 2>/dev/null | \
                awk -F/ '{print $NF}' | \
                sed 's/\..*$//' | \
                sort -u | \
                fzf --prompt="Man page: " \
                    --preview="zsh -ic 'man {} 2>/dev/null' | head -50" \
                    --preview-window="right:70%:wrap")
            [ -n "$cmd" ] && show_man "$cmd"
        else
            echo -e "${RED}fzf not found.${NC}"
        fi
    else
        if man "$cmd" >/dev/null 2>&1; then
            zsh -ic "man $cmd"
        else
            echo -e "${RED}Man page for '$cmd' not found${NC}"
        fi
    fi
}


# Function to search Arch Wiki
search_wiki() {
    local term="$1"
    if command -v wikiman >/dev/null 2>&1; then
        wikiman "$term"
    else
        echo -e "${RED}wikiman not found. Install with: pacman -S wikiman${NC}"
    fi
}

# Function to show tldr page
show_tldr() {
    local cmd="$1"
    if command -v tealdeer >/dev/null 2>&1; then
        tldr "$cmd"
    elif command -v tldr >/dev/null 2>&1; then
        tldr "$cmd"
    else
        echo -e "${RED}tldr not found. Install tealdeer with: pacman -S tealdeer${NC}"
    fi
}

# Function to apply pywal theme
apply_pywal_theme() {
    local image="$1"
    
    if ! command -v wal >/dev/null 2>&1; then
        echo -e "${RED}pywal not found. Install with: pip install pywal${NC}"
        return 1
    fi
    
    if [ -z "$image" ]; then
        # Interactive image selection
        if command -v fzf >/dev/null 2>&1; then
            local wallpaper_dirs=("$HOME/Pictures" "$HOME/wallpapers" "$HOME/.config/wallpapers" "/usr/share/pixmaps")
            local image_files="/tmp/wallpapers_$"
            > "$image_files"
            
            for dir in "${wallpaper_dirs[@]}"; do
                if [ -d "$dir" ]; then
                    find "$dir" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) 2>/dev/null >> "$image_files"
                fi
            done
            
            if [ -s "$image_files" ]; then
                image=$(fzf --prompt="Select wallpaper: " --preview="echo 'Image: {}'" < "$image_files")
                rm -f "$image_files"
            else
                echo -e "${RED}No images found in common directories${NC}"
                rm -f "$image_files"
                return 1
            fi
        else
            echo -e "${RED}Please specify an image path or install fzf for interactive selection${NC}"
            return 1
        fi
    fi
    
    if [ -n "$image" ] && [ -f "$image" ]; then
        echo -e "${BLUE}Applying pywal theme from: ${YELLOW}$image${NC}"
        wal -i "$image" -q
        
        # Reload colors
        if load_pywal_colors; then
            echo -e "${GREEN}Theme applied successfully!${NC}"
        fi
    else
        echo -e "${RED}Invalid image file${NC}"
    fi
}

# Function to show current pywal theme
show_pywal_theme() {
    if [ -f "$HOME/.cache/wal/colors.sh" ]; then
        source "$HOME/.cache/wal/colors.sh"
        echo -e "${BLUE}Current pywal color scheme:${NC}"
        echo -e "Wallpaper: ${CYAN}$(cat ~/.cache/wal/wal 2>/dev/null || echo 'Unknown')${NC}"
        echo
        echo -e "${RED}Color 1 (Red)${NC}     ${GREEN}Color 2 (Green)${NC}"
        echo -e "${YELLOW}Color 3 (Yellow)${NC}  ${BLUE}Color 4 (Blue)${NC}"
        echo -e "${PURPLE}Color 5 (Purple)${NC}  ${CYAN}Color 6 (Cyan)${NC}"
        echo
        echo -e "Background: $color0"
        echo -e "Foreground: $color15"
    elif [ -f "$HOME/.cache/wal/wal" ]; then
        local current_wall=$(cat "$HOME/.cache/wal/wal")
        echo -e "${YELLOW}Pywal wallpaper found but colors not generated:${NC}"
        echo -e "Wallpaper: ${CYAN}$current_wall${NC}"
        echo
        echo -e "${BLUE}Run ${GREEN}'regen'${BLUE} to regenerate colors from current wallpaper${NC}"
        echo -e "${BLUE}Or run ${GREEN}'theme <image>'${BLUE} to set a new wallpaper${NC}"
    else
        echo -e "${RED}No pywal theme found. Run 'theme <image>' to generate one.${NC}"
    fi
}

# Function to regenerate pywal colors from current wallpaper
regen_pywal_colors() {
    if ! command -v wal >/dev/null 2>&1; then
        echo -e "${RED}pywal not found. Install with: pip install pywal${NC}"
        return 1
    fi
    
    if [ -f "$HOME/.cache/wal/wal" ]; then
        local current_wall=$(cat "$HOME/.cache/wal/wal")
        if [ -f "$current_wall" ]; then
            echo -e "${BLUE}Regenerating colors from: ${YELLOW}$current_wall${NC}"
            wal -i "$current_wall" -q
            load_pywal_colors
            echo -e "${GREEN}Colors regenerated successfully!${NC}"
        else
            echo -e "${RED}Current wallpaper file not found: $current_wall${NC}"
            echo -e "${BLUE}Use ${GREEN}'theme <image>'${BLUE} to set a new wallpaper${NC}"
        fi
    else
        echo -e "${RED}No current wallpaper found. Use 'theme <image>' to set one.${NC}"
    fi
}

# Function to reload pywal theme
reload_pywal_theme() {
    if load_pywal_colors; then
        echo -e "${GREEN}Colors reloaded from pywal cache${NC}"
    else
        echo -e "${YELLOW}No pywal colors found.${NC}"
        if [ -f "$HOME/.cache/wal/wal" ]; then
            echo -e "${BLUE}Run ${GREEN}'regen'${BLUE} to generate colors from current wallpaper${NC}"
        else
            echo -e "${BLUE}Run ${GREEN}'theme <image>'${BLUE} to set up pywal${NC}"
        fi
    fi
}

clear_screen() {
    # ANSI escape sequence to clear screen and scrollback (like Fish's Ctrl+L)
    printf '\033[2J\033[3J\033[H'
}

open_navi() {
    if command -v navi >/dev/null 2>&1; then
        navi
    else
        echo -e "${RED}navi not found. Install with: pacman -S navi${NC}"
    fi
}

# Function to pick cheatsheet with fzf
fzf_cheatsheet() {
    local preview_cmd
    if command -v bat >/dev/null 2>&1; then
        preview_cmd="bat --color=always --style=plain '$CHEAT_DIR/{}.md'"
    elif command -v highlight >/dev/null 2>&1; then
        preview_cmd="highlight -O ansi '$CHEAT_DIR/{}.md'"
    elif command -v pygmentize >/dev/null 2>&1; then
        preview_cmd="pygmentize -g '$CHEAT_DIR/{}.md'"
    else
        preview_cmd="cat '$CHEAT_DIR/{}.md'"
    fi

    local selected
    selected=$(find "$CHEAT_DIR" -name '*.md' -exec basename {} .md \; | sort | \
        fzf --prompt="Select cheatsheet: " \
            --preview="$preview_cmd" \
            --preview-window="right:70%:wrap")
    [ -n "$selected" ] && show_cheatsheet "$selected"
}

# fzf_cheatsheet() {
#     if ! command -v fzf >/dev/null 2>&1; then
#         echo -e "${RED}fzf not found. Install with: pacman -S fzf${NC}"
#         return 1
#     fi
#     
#     local selected
#     selected=$(find "$CHEAT_DIR" -name '*.md' -exec basename {} .md \; | sort | \
#         fzf --prompt="Select cheatsheet: " \
#             --preview="if command -v glow >/dev/null 2>&1; then glow '$CHEAT_DIR/{}.md'; else cat '$CHEAT_DIR/{}.md'; fi" \
#             --preview-window=right:60%:wrap)
#     
#     if [ -n "$selected" ]; then
#         show_cheatsheet "$selected"
#     fi
# }

# Function to search commands with fzf
fzf_command_search() {
    if ! command -v fzf >/dev/null 2>&1; then
        echo -e "${RED}fzf not found. Install with: pacman -S fzf${NC}"
        return 1
    fi
    
    # Create temporary file with all cheatsheet content
    local temp_search="/tmp/cheat_fzf_$"
    > "$temp_search"
    
    for file in "$CHEAT_DIR"/*.md; do
        if [ -f "$file" ]; then
            local topic=$(basename "$file" .md)
            echo "=== $topic ===" >> "$temp_search"
            cat "$file" >> "$temp_search"
            echo >> "$temp_search"
        fi
    done
    
    if [ -s "$temp_search" ]; then
        if command -v glow >/dev/null 2>&1; then
            glow "$temp_search" | fzf --ansi --prompt="Search cheatsheets: "
        else
            fzf --prompt="Search cheatsheets: " < "$temp_search"
        fi
    fi
    
    rm -f "$temp_search"
}

# Function to edit cheatsheet
edit_cheatsheet() {
    local topic="$1"
    local file="$CHEAT_DIR/$topic.md"
    
    if [ ! -f "$file" ]; then
        echo -e "${YELLOW}Creating new cheatsheet for '$topic'${NC}"
        echo "# $topic Cheatsheet" > "$file"
        echo >> "$file"
        echo "## Commands" >> "$file"
        echo "- \`command\` - Description" >> "$file"
    fi
    
    ${EDITOR:-nvim} "$file"
}

# Function to display a cheatsheet
show_cheatsheet() {
    local topic="$1"
    local file="$CHEAT_DIR/$topic.md"
    
    if [ -f "$file" ]; then
        if command -v glow >/dev/null 2>&1; then
            glow "$file"
        elif command -v jless >/dev/null 2>&1; then
            jless "$file"
        else
            less "$file"
        fi
    else
        echo -e "${RED}Cheatsheet for '$topic' not found${NC}"
        echo -e "Use ${GREEN}new $topic${NC} to create it"
    fi
}

# Interactive mode
interactive_mode() {
    echo -e "${BLUE}Universal Cheatsheet Program${NC}"
    echo -e "Type ${YELLOW}'help'${NC} for commands, ${YELLOW}'q'${NC} to quit"
    echo
    
    while true; do
        echo -ne "${CYAN}cheat> ${NC}"
        read -r input
        
        if [ -z "$input" ]; then
            continue
        fi
        
        # Parse input
        cmd=$(echo "$input" | awk '{print $1}')
        args=$(echo "$input" | cut -d' ' -f2- 2>/dev/null)
        
        case "$cmd" in
            "clear"|"c")
                clear_screen
                ;;
            "help"|"h")
                show_help
                ;;
            "list"|"ls")
                list_cheatsheets
                ;;
            "pick")
                fzf_cheatsheet
                ;;
            "browse")
                fzf_command_search
                ;;
            "edit")
                if [ -n "$args" ] && [ "$args" != "$input" ]; then
                    edit_cheatsheet "$args"
                else
                    echo -e "${RED}Usage: edit <topic>${NC}"
                fi
                ;;
            "new")
                if [ -n "$args" ] && [ "$args" != "$input" ]; then
                    edit_cheatsheet "$args"
                else
                    echo -e "${RED}Usage: new <topic>${NC}"
                fi
                ;;
            "man")
                if [ -n "$args" ] && [ "$args" != "$input" ]; then
                    show_man "$args"
                else
                    show_man  # Interactive mode
                fi
                ;;
            "wiki")
                if [ -n "$args" ] && [ "$args" != "$input" ]; then
                    search_wiki "$args"
                else
                    echo -e "${RED}Usage: wiki <term>${NC}"
                fi
                ;;
            "tldr")
                if [ -n "$args" ] && [ "$args" != "$input" ]; then
                    show_tldr "$args"
                else
                    echo -e "${RED}Usage: tldr <command>${NC}"
                fi
                ;;
            "navi")
                open_navi
                ;;
            "theme")
                if [ -n "$args" ] && [ "$args" != "$input" ]; then
                    apply_pywal_theme "$args"
                else
                    apply_pywal_theme  # Interactive mode
                fi
                ;;
            "colors")
                show_pywal_theme
                ;;
            "regen")
                regen_pywal_colors
                ;;
            "reload")
                reload_pywal_theme
                ;;
            "show")
                if [ -n "$args" ] && [ "$args" != "$input" ]; then
                    show_cheatsheet "$args"
                else
                    echo -e "${RED}Usage: show <topic>${NC}"
                fi
                ;;
            "q"|"quit"|"exit")
                echo -e "${BLUE}Goodbye!${NC}"
                break
                ;;
            *)
                # Treat as search query
                search_cheatsheets "$input"
                ;;
        esac
        echo
    done
}

# Main script logic
init_cheatsheets

if [ $# -eq 0 ]; then
    # No arguments, start interactive mode
    interactive_mode
else
    # Arguments provided, execute command
    case "$1" in
        "help"|"-h"|"--help")
            show_help
            ;;
        "list")
            list_cheatsheets
            ;;
        "edit")
            if [ -n "$2" ]; then
                edit_cheatsheet "$2"
            else
                echo -e "${RED}Usage: $0 edit <topic>${NC}"
            fi
            ;;
        *)
            # Treat as search query
            search_cheatsheets "$*"
            ;;
    esac
fi

# Cleanup
rm -f "$TEMP_FILE"
