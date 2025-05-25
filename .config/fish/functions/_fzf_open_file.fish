# ~/.config/fish/functions/_fzf_open_file.fish

function _fzf_open_file
  # Define directories to exclude
  set -l exclude_dirs node_modules .git venv target dist coverage BraveSoftware lazy mason chromium backup

  # Additional directories to search (including .config and symlinks)
  set -l search_paths . ' ~/.config'

  # Build fd command with multiple search paths
  set -l fd_cmd fd --type f --follow --absolute-path
  for dir in $exclude_dirs
    set fd_cmd $fd_cmd --exclude $dir
  end

  # Create a temporary preview script
  set -l preview_script (mktemp)
  echo '#!/bin/bash
file_path="$1"
file_ext="${file_path##*.}"
file_ext_lower=$(echo "$file_ext" | tr "[:upper:]" "[:lower:]")
mime_type=$(file --mime-type -b "$file_path")

export TERM=xterm-256color

metadata() {
  echo ""
  echo "--- Metadata ---"
  stat -c "Name: %n" "$file_path"
  stat -c "Size: %s bytes" "$file_path"
  stat -c "Modified: %y" "$file_path"
  if [[ -f "$file_path" ]]; then
    stat -c "Permissions: %a (%A)" "$file_path"
  fi
  file --mime-type "$file_path"
}

if [[ "$mime_type" == image/* ]]; then
  if command -v img2sixel >/dev/null 2>&1; then
    img2sixel -w 600 "$file_path" 2>/dev/null || echo "Image preview unavailable"
    metadata
  elif command -v chafa >/dev/null 2>&1; then
    chafa -s 80x25 --fill=space --symbols=block "$file_path" 2>/dev/null || echo "Image preview unavailable"
    metadata
  else
    echo "No image previewer (img2sixel/chafa) found."
    metadata
  fi
elif [[ "$file_ext_lower" == "md" || "$file_ext_lower" == "markdown" ]]; then
  if command -v glow >/dev/null 2>&1; then
    glow --style=notty "$file_path" 2>/dev/null
    metadata
  else
    bat --style=numbers --color=always --line-range=:500 "$file_path" 2>/dev/null || cat "$file_path"
    metadata
  fi
else
  bat --style=numbers --color=always --line-range=:500 "$file_path" 2>/dev/null || cat "$file_path"
  metadata
fi' > $preview_script

  chmod +x $preview_script

  # Search in all specified paths
  set -l file (for path in $search_paths
    command $fd_cmd $path
  end | fzf --ansi --preview "$preview_script {}" \
    --preview-window=right:60%:wrap \
    --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
    --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 \
    --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 \
    --color=marker:#ff79c6,spinner:#ffb86c,header:#00ffff \
    --bind "ctrl-c:execute(printf '%s' {} | wl-copy)+abort" \
    --bind "esc:abort" \
    --header "Enter: open file | Ctrl+C: copy path | Alt-C: open containing directory")

  rm $preview_script

  if test -n "$file"
    if file --mime-type "$file" | grep -q 'image/'
      if type -q imv
        imv "$file" &
      else if type -q feh
        feh "$file" &
      else
        xdg-open "$file" &
      end
      disown 2>/dev/null
    else
      set -l editor $EDITOR
      if test -z "$editor"
        set editor (command -v micro nvim vim vi | head -1)
      end
      $editor "$file"
    end
  end
end
#
# function _fzf_open_file
#   # Define directories to exclude
#   set -l exclude_dirs node_modules .git venv target dist coverage BraveSoftware lazy mason chromium backup
#
#   # Build fd command
#   set -l fd_cmd fd --type f
#   for dir in $exclude_dirs
#     set fd_cmd $fd_cmd --exclude $dir
#   end
#
#   # Create a temporary preview script
#   set -l preview_script (mktemp)
#   echo '#!/bin/bash
# file_path="$1"
# file_ext="${file_path##*.}"
# file_ext_lower=$(echo "$file_ext" | tr "[:upper:]" "[:lower:]")
# mime_type=$(file --mime-type -b "$file_path")
#
# export TERM=xterm-256color
#
# metadata() {
#   echo ""
#   echo "--- Metadata ---"
#   stat -c "Name: %n" "$file_path"
#   stat -c "Size: %s bytes" "$file_path"
#   stat -c "Modified: %y" "$file_path"
#   if [[ -f "$file_path" ]]; then
#     stat -c "Permissions: %a (%A)" "$file_path"
#   fi
#   file --mime-type "$file_path"
# }
#
# if [[ "$mime_type" == image/* ]]; then
#   if command -v img2sixel >/dev/null 2>&1; then
#     img2sixel -w 600 "$file_path" 2>/dev/null || echo "Image preview unavailable"
#     metadata
#   elif command -v chafa >/dev/null 2>&1; then
#     chafa -s 80x25 --fill=space --symbols=block "$file_path" 2>/dev/null || echo "Image preview unavailable"
#     metadata
#   else
#     echo "No image previewer (img2sixel/chafa) found."
#     metadata
#   fi
# elif [[ "$file_ext_lower" == "md" || "$file_ext_lower" == "markdown" ]]; then
#   if command -v glow >/dev/null 2>&1; then
#     glow --style=notty "$file_path" 2>/dev/null
#     metadata
#   else
#     bat --style=numbers --color=always --line-range=:500 "$file_path" 2>/dev/null || cat "$file_path"
#     metadata
#   fi
# else
#   bat --style=numbers --color=always --line-range=:500 "$file_path" 2>/dev/null || cat "$file_path"
#   metadata
# fi' > $preview_script
#
#   chmod +x $preview_script
#
#   # Use fzf with preview
#   set -l file ($fd_cmd | fzf --ansi --preview "$preview_script {}" \
#     --preview-window=right:60%:wrap \
#     --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
#     --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 \
#     --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 \
#     --color=marker:#ff79c6,spinner:#ffb86c,header:#00ffff \
#     --bind "ctrl-c:execute(printf '%s' {} | wl-copy)+abort" \
#     --bind "esc:abort" \
#     --header "Enter: open file | Ctrl+C: copy path and exit")
#
#   rm $preview_script
#
#   if test -n "$file"
#     if file --mime-type "$file" | grep -q 'image/'
#       if type -q shotwell
#         shotwell "$file" &
#       else if type -q feh
#         feh "$file" &
#       else
#         xdg-open "$file" &
#       end
#       disown 2>/dev/null
#     else
#       $EDITOR "$file"
#     end
#   end
# end

# function _fzf_open_file
#   # Define directories to exclude
#   set -l exclude_dirs node_modules .git venv target dist coverage BraveSoftware lazy mason chromium backup
#
#   # Build fd command
#   set -l fd_cmd fd --type f
#   for dir in $exclude_dirs
#     set fd_cmd $fd_cmd --exclude $dir
#   end
#
#   # Create a temporary preview script
#   set -l preview_script (mktemp)
#   echo '#!/bin/bash
# file_path="$1"
# file_ext="${file_path##*.}"
# file_ext_lower=$(echo "$file_ext" | tr "[:upper:]" "[:lower:]")
# mime_type=$(file --mime-type -b "$file_path")
#
# export TERM=xterm-256color
#
# if [[ "$mime_type" == image/* ]]; then
#   if command -v img2sixel >/dev/null 2>&1; then
#     img2sixel -w 600 "$file_path" 2>/dev/null || echo "Image preview unavailable"
#   elif command -v chafa >/dev/null 2>&1; then
#     chafa -s 80x25 --fill=space --symbols=block "$file_path" 2>/dev/null || echo "Image preview unavailable"
#   else
#     echo "No image previewer (img2sixel/chafa) found."
#   fi
# elif [[ "$file_ext_lower" == "md" || "$file_ext_lower" == "markdown" ]]; then
#   if command -v glow >/dev/null 2>&1; then
#     glow --style=notty "$file_path" 2>/dev/null
#     # script -qfc "glow -s dark -w 80 \"$file_path\"" /dev/null
#   else
#     bat --style=numbers --color=always --line-range=:500 "$file_path" 2>/dev/null || cat "$file_path"
#   fi
# else
#   bat --style=numbers --color=always --line-range=:500 "$file_path" 2>/dev/null || cat "$file_path"
# fi' > $preview_script
#
#   chmod +x $preview_script
#
#   # Use fzf with preview
#   set -l file ($fd_cmd | fzf --ansi --preview "$preview_script {}" \
#     --preview-window=right:60% \
#     --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
#     --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 \
#     --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 \
#     --color=marker:#ff79c6,spinner:#ffb86c,header:#00ffff \
#     --bind "ctrl-c:execute(printf '%s' {} | wl-copy)+abort" \
#     --bind "esc:abort" \
#     --header "Enter: open file | Ctrl+C: copy path and exit")
#
#   rm $preview_script
#
#   if test -n "$file"
#     if file --mime-type "$file" | grep -q 'image/'
#       if type -q shotwell
#         shotwell "$file" &
#       else if type -q feh
#         feh "$file" &
#       else
#         xdg-open "$file" &
#       end
#       disown 2>/dev/null
#     else
#       $EDITOR "$file"
#     end
#   end
# end
#


# function _fzf_open_file
#   # Define directories to exclude
#   set -l exclude_dirs node_modules .git venv target dist coverage BraveSoftware lazy mason chromium backup
#   
#   # Build fd command
#   set -l fd_cmd fd --type f
#   for dir in $exclude_dirs
#     set fd_cmd $fd_cmd --exclude $dir
#   end
#   
#   # Create a temporary preview script
#   set -l preview_script (mktemp)
#   echo '#!/bin/bash
# file_path="$1"
# mime_type=$(file --mime-type -b "$file_path")
#
# export TERM=xterm-256color
#
# if [[ "$mime_type" == image/* ]]; then
#   # Try img2sixel first, fall back to cat if not available
#   if command -v img2sixel >/dev/null 2>&1; then
#     img2sixel -w 600 "$file_path" 2>/dev/null || echo "Image preview unavailable"
#   else
#     echo "img2sixel not installed. Install libsixel-bin for image previews."
#     echo "File: $file_path"
#     echo "Type: $mime_type"
#   fi
# else
#   # Use bat for all non-image files
#   bat --style=numbers --color=always --line-range=:500 "$file_path" 2>/dev/null || cat "$file_path"
# fi
# # Metadata section
# echo
# echo -e "${MAGENTA}───── FILE INFO ─────${RESET}"
# stat --printf="${CYAN}Name:${RESET} %n\n${CYAN}Size:${RESET} %s bytes\n${CYAN}Modified:${RESET} %y\n${CYAN}Type:${RESET} %F\n" "$file_path"
#
# ' > $preview_script
#   
#   chmod +x $preview_script
#   
#   # Use fzf with the preview script and enhanced styling options
#   set -l file ($fd_cmd | fzf --ansi --preview "$preview_script {}" \
#     --preview-window=right:60% \
#     --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
#     --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 \
#     --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 \
#     --color=marker:#ff79c6,spinner:#ffb86c,header:#00ffff \
#     --bind "ctrl-c:execute(printf '%s' {} | wl-copy)+abort" \
#     --bind "esc:abort" \
#     --header "Enter: open file | Ctrl+C: copy path and exit")
#   
#   # Clean up the temporary script
#   rm $preview_script
#   
#   # Open the selected file
#   if test -n "$file"
#     # Check if it's an image based on mime type
#     if file --mime-type "$file" | grep -q 'image/'
#       # Open with appropriate image viewer
#       if type -q shotwell
#         shotwell "$file" &
#       else if type -q feh
#         feh "$file" &
#       else
#         xdg-open "$file" &
#       end
#       disown 2>/dev/null # Disown process to prevent terminal dependency
#     else
#       # Open in text editor
#       $EDITOR "$file"
#     end
#   end
# end

# function _fzf_open_file
#   # Define directories to exclude
#   set -l exclude_dirs node_modules .git venv target dist coverage BraveSoftware lazy mason chromium backup
#   
#   # Build fd command
#   set -l fd_cmd fd --type f
#   for dir in $exclude_dirs
#     set fd_cmd $fd_cmd --exclude $dir
#   end
#   
#   # Use a simpler preview command that works reliably
#   set -l file ($fd_cmd | fzf --preview "if file --mime-type {} | grep -q 'image/'; then chafa {} 2>/dev/null || echo 'Image preview unavailable'; else bat --style=numbers --color=always --line-range=:500 {} 2>/dev/null || cat {}; fi" --preview-window=right:60%)
#   
#   # Open the selected file
#   if test -n "$file"
#     # Check if it's an image based on mime type
#     if file --mime-type "$file" | grep -q 'image/'
#       # Open with appropriate image viewer
#       if type -q shotwell
#         shotwell "$file" &
#       else if type -q feh
#         feh "$file" &
#       else
#         xdg-open "$file" &
#       end
#       disown 2>/dev/null # Disown process to prevent terminal dependency
#     else
#       # Open in text editor
#       $EDITOR "$file"
#     end
#   end
# end
#

