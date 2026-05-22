function _fzr_all_folder
  # Save starting directory
  set -l starting_dir $PWD

  # Set up colors
  set -l cyan (set_color cyan)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l red (set_color red)
  set -l yellow (set_color yellow)
  set -l magenta (set_color magenta)
  set -l normal (set_color normal)

  # Show beautiful header
  echo -e "$cyan"
  echo -e "┌─────────────────────────────────────────────────────────────────┐"
  echo -e "│🚀$magenta FZF Directory Explorer $cyan- Browse your filesystem in real-time  │"
  echo -e "└─────────────────────────────────────────────────────────────────┘$normal"

  # Directories to exclude
  set -l exclude_dirs node_modules .git venv target dist coverage BraveSoftware lazy mason chromium backup move language Code "Code\ -\ OSS"

  # Build the fd commands with exclude options
  set -l cmd1 "fd --type d --follow --max-depth 4 --base-directory $HOME --no-ignore-vcs"
  set -l cmd2 "fd --type d --max-depth 3 --base-directory $HOME/.config --hidden --no-ignore-vcs"

  for dir in $exclude_dirs
    set cmd1 "$cmd1 --exclude $dir"
    set cmd2 "$cmd2 --exclude $dir"
  end

  # Collect all results with a prefix to track origin


  # Start with current directory
  set -l current_dir $PWD
  set -l dir_history $current_dir
  set -l continue_browsing true

  while test "$continue_browsing" = "true"
    # Create enhanced preview script
    set -l preview_script (mktemp)
    echo '#!/bin/bash
entry="$1"
prefix="${entry%%:*}"
dir="${entry#*:}"

if [[ "$prefix" == "CONFIG" ]]; then
  dir="$HOME/.config/$dir"
else
  dir="$HOME/$dir"
fi

if [[ ! -d "$dir" ]]; then
  printf "❌ Error: Directory does not exist: %s\n" "$dir" >&2
  exit 1
fi

# Git status with color
if [ -d "$dir/.git" ]; then
  echo -e "\033[1;36m🔧 Git Repository:\033[0m"
  git -C "$dir" status -sb 2>/dev/null || echo "(Not a git repo)"
  echo
fi

# Directory info with icons
echo -e "\033[1;36m📦 Directory Info:\033[0m"
echo -e "\033[1;34mPath:\033[0m $dir"

# Single fd pass for both counts
all_items=$(fd --max-depth=1 --hidden --no-ignore . "$dir")
total=$(echo "$all_items" | wc -l)
hidden=$(echo "$all_items" | grep -c '/\.')

echo -e "\033[1;34mContents:\033[0m $total"
echo -e "\033[1;34mHidden:\033[0m $hidden"
echo -e "\033[1;34mSize:\033[0m $(timeout 0.1s du -s --apparent-size -h "$dir" 2>/dev/null | cut -f1 || echo "…")"

# Enhanced directory listing
echo
echo -e "\033[1;36m📂 Contents Preview:\033[0m"
eza --icons --color=always --group-directories-first --git-ignore --header --long \
  --all --classify --no-user --no-time --no-permissions --no-filesize \
  --sort=name --tree --level=1 "$dir" 2>/dev/null | head -n 15

# Image count with emoji
image_count=$(fd --max-depth=1 --type f --extension jpg --extension jpeg --extension png --extension gif . "$dir" | wc -l)
[ "$image_count" -gt 0 ] && echo -e "\n\033[1;35m🖼️ Contains $image_count images\033[0m"' > $preview_script
    chmod +x $preview_script

    cd $HOME

    # Create beautiful ASCII art header
    set -l header_text "
$cyan┌──────────────────────────────────────────────────────────────┐
$cyan $yellow Enter$normal: Open $yellow Tab$normal: Select & Exit $yellow Alt+B$normal: Back $yellow ESC$normal: Cancel       
$cyan└──────────────────────────────────────────────────────────────┘$normal
"

    set -l selected (begin; eval $cmd1 | sed 's/^/HOME:/'; eval $cmd2 | sed 's/^/CONFIG:/'; end | fzf --ansi \
      --layout=reverse \
      --preview "$preview_script {}" \
      --preview-window "right:65%:wrap" \
      --color='bg:-1'\
      --color='fg:#ff9900,bg:-1,hl:#ffaa00'\
      --color='fg+:#ffffff,bg+:#333333,hl+:#ff9999' \
      --color='info:#99cc66,prompt:#ff9966,pointer:#ff6699' \
      --color='marker:#66ccff,spinner:#ffcc66,header:#99ccff' \
      --border rounded \
      --header-first \
      --header "$header_text" \
      --bind "alt-b:abort" \
      --bind "alt-up:preview-up,alt-down:preview-down" \
      --bind "ctrl-c:execute(echo -n {2..} | xclip -selection clipboard)+abort")

    rm $preview_script

    if test -z "$selected"
      if test (count $dir_history) -gt 1
        set dir_history $dir_history[1..-2]
        set current_dir $dir_history[-1]
        cd $current_dir
      else
        cd $starting_dir
        set continue_browsing false
      end
    else
      set prefix (string split ":" $selected)[1]
      set path (string split ":" $selected)[2]

      switch $prefix
        case HOME
          set selected_dir "$HOME/$path"
        case CONFIG
          set selected_dir "$HOME/.config/$path"
      end

      if not test -d "$selected_dir"
        echo -e "$red✖ Error: Directory does not exist: $selected_dir$normal"
        sleep 1.5
        continue
      end

      set current_dir $selected_dir
      set -a dir_history $current_dir
      cd "$current_dir"

      # Enhanced file preview script
      set -l file_preview_script (mktemp)
      echo '#!/bin/bash
file="$1"
[[ "$file" != /* ]] && file="$PWD/$file"

if [ ! -f "$file" ]; then
  echo -e "\033[1;31m❌ Error: Not a valid file\033[0m"
  exit 1
fi

mimetype=$(file --mime-type -b "$file")

# Header with file info
echo -e "\033[1;36m📄 File: \033[1;33m$(basename "$file")\033[0m"
echo -e "\033[1;34mPath: \033[0m$(dirname "$file")"
echo -e "\033[1;34mType: \033[0m$mimetype"
echo -e "\033[1;34mSize: \033[0m$(du -h "$file" | cut -f1)"
echo -e "\033[1;34mModified: \033[0m$(date -r "$file" "+%Y-%m-%d %H:%M:%S")"
echo

# Special handling for different file types
case "$mimetype" in
  image/*)
    if command -v chafa &>/dev/null; then
      chafa --format=sixel \
      --size="${FZF_PREVIEW_COLUMNS}x$((FZF_PREVIEW_LINES - 6))" \
      --fit-width \
      "$file"
    elif command -v img2sixel &>/dev/null; then
      img2sixel -w 600 "$file" 2>/dev/null
    else
      file "$file"
    fi
    ;;
  application/pdf)
    if command -v pdftotext &>/dev/null; then
      pdftotext "$file" - | head -n 30
    else
      echo "PDF content preview requires pdftotext"
    fi
    ;;
  application/json)
    jq . "$file" 2>/dev/null || cat "$file"
    ;;
  text/*|*/xml|application/xml)
    bat --style=numbers --color=always --line-range :500 "$file" 2>/dev/null || 
    highlight -O ansi --force --line-numbers "$file" 2>/dev/null ||
    cat "$file"
    ;;
  audio/*)
    if command -v exiftool &>/dev/null; then
      exiftool "$file" 2>/dev/null
    else
      file "$file"
    fi
    ;;
  *)
    file "$file"
    ;;
esac' > $file_preview_script
      chmod +x $file_preview_script

      # Find files with enhanced display
      set -l file (fd --type f --hidden --color=always --exclude '.git/*' | fzf --ansi \
        --layout=reverse \
        --preview "$file_preview_script {}" \
        --preview-window "right:60%:wrap" \
        --color='bg:-1'\
        --color='fg:#ff9900,bg:-1,hl:#ffaa00'\
        --color='fg+:#ffffff,bg+:#333333,hl+:#ff9999' \
        --color='info:#99cc66,prompt:#ff9966,pointer:#ff6699' \
        --color='marker:#66ccff,spinner:#ffcc66,header:#99ccff' \
        --border rounded \
        --header "📂 $current_dir | ↑↓: Navigate | Enter: Open | Alt+B: Back | ESC: Cancel" \
        --bind "alt-b:abort" \
        --bind "alt-up:preview-up,alt-down:preview-down" \
        --bind "ctrl-c:execute(echo -n {} | xclip -selection clipboard)+abort")

      rm $file_preview_script

      if test -n "$file"
        if not string match -q "/*" $file
          set file "$PWD/$file"
        end

        set -l mimetype (file --mime-type -b "$file")
        if string match -q "image/*" $mimetype
          if command -v sxiv &>/dev/null
            sxiv -a "$file" &
          else
            xdg-open "$file" &
          end
        else if string match -q "audio/*" $mimetype
          if command -v rmpc &>/dev/null
            rmpc add "file://$file" >/dev/null 2>&1
            rmpc play >/dev/null 2>&1
            rmpc  # opens TUI, blocks until you quit, then returns to explorer
          else
            xdg-open "$file" &
            disown
          end
        else if string match -q "application/pdf" $mimetype
          if command -v zathura &>/dev/null
            zathura "$file" &
          else
            xdg-open "$file" &
          end
        else
          $EDITOR "$file"
        end
      end
    end
  end

  # Show beautiful exit message
  echo -e "$cyan"
  echo -e "┌─────────────────────────────────────────┐"
  echo -e "│  🎉 Directory Explorer - Session Ended  │"
  echo -e "└─────────────────────────────────────────┘$normal"

  cd $starting_dir
end



