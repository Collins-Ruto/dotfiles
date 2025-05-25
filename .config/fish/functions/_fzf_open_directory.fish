
function _fzf_open_directory
  # Save starting directory to return to later
  set -l starting_dir $PWD
  
  # Directories to exclude
  set -l exclude_dirs node_modules .git venv target dist coverage BraveSoftware lazy mason chromium backup move language Code "Code\ -\ OSS"
  
  # Build the fd commands with exclude options - using absolute paths
  set -l cmd1 "fd --type d --follow --max-depth 5 --base-directory $HOME"
  set -l cmd2 "fd --type d --max-depth 5 --base-directory $HOME/.config"
  
  # Add exclusions to both commands
  for dir in $exclude_dirs
    set cmd1 "$cmd1 --exclude $dir"
    set cmd2 "$cmd2 --exclude $dir"
  end
  
  # Start with the current directory (for the back button functionality)
  set -l current_dir $PWD
  set -l dir_history $current_dir
  set -l continue_browsing true
  set -l main_results_cache ""
  
  while test "$continue_browsing" = "true"
    # Create the preview script for directories
    set -l preview_script (mktemp)
    echo '#!/bin/bash
dir="$1"
# Handle directory path - make sure it is absolute
if [[ "$dir" == ~* ]]; then
  # Expand tilde
  dir="${HOME}${dir:1}"
elif [[ "$dir" == .config/* ]]; then
  # Handle .config directories correctly
  dir="${HOME}/.config/${dir#.config/}"
elif [[ "$dir" != /* ]]; then
  # Regular directories from home
  dir="${HOME}/$dir"
fi

if [ ! -d "$dir" ]; then
  echo "❌ Error: \"$dir\" is not a valid directory"
  exit 1
fi

if [ -d "$dir/.git" ]; then
  echo "🔧 Git Repository:"
  git -C "$dir" status -sb 2>/dev/null || echo "(Not a git repo)"
  echo
fi

echo "📦 Directory Info:"
echo "Path: $dir"
du -sh "$dir" 2>/dev/null
echo "Contents:"
ls -la "$dir" | wc -l
echo "Items:" $(find "$dir" -maxdepth 1 | tail -n +2 | wc -l)

# Show some sample contents
echo
echo "📂 Contents (sample):"
ls -la "$dir" | head -n 10

# Check if directory has images
image_count=$(find "$dir" -maxdepth 1 -type f -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" | wc -l)
if [ "$image_count" -gt 0 ]; then
  echo "🖼️ Contains $image_count images"
fi' > $preview_script
    chmod +x $preview_script
    
    # Reset to home directory each time we go up a level for directory selection
    cd $HOME
    
    # Cache or use cached results for main directory listing
    if test -z "$main_results_cache"
      set main_results_cache (bash -c "$cmd1; $cmd2" | sort)
    end
    
    # Display the directories with proper preview
    set -l selected_dir (printf "%s\n" $main_results_cache | fzf --ansi --preview "$preview_script {}" \
      --preview-window=right:60% \
      --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
      --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 \
      --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 \
      --color=marker:#ff79c6,spinner:#ffb86c,header:#00ffff \
      --header "Enter: explore folder | Alt+B: back | Ctrl+C: copy path | ESC: exit" \
      --bind "alt-b:abort")
      
    rm $preview_script
    
    # Handle Alt+B or exit
    if test -z "$selected_dir"
      # Check if this was Alt+B or ESC
      if test (count $dir_history) -gt 1
        # Go back to previous selection (Alt+B)
        set dir_history $dir_history[1..-2]
        set current_dir $dir_history[-1]
        # Continue browsing
      else
        # No more history or ESC pressed, exit
        cd $starting_dir
        set continue_browsing false
      end
    else
      # Convert selected directory to absolute path
      if string match -q "~*" $selected_dir
        # Expand tilde
        set selected_dir (string replace '~' $HOME $selected_dir)
      else if string match -q ".config/*" $selected_dir
        # Properly handle .config directories
        set selected_dir "$HOME/$selected_dir"
      else if not string match -q "/*" $selected_dir
        # It's a relative path from the FD search, make it absolute
        set selected_dir "$HOME/$selected_dir"
      end
      
      # Make sure the directory exists before we try to use it
      if not test -d "$selected_dir"
        echo "Error: $selected_dir is not a valid directory"
        sleep 2
        continue
      end
      
      # Selected a valid directory, explore it
      set current_dir $selected_dir
      # Add to history
      set -a dir_history $current_dir
      cd "$current_dir"
      
      # File preview script with img2sixel support
      set -l file_preview_script (mktemp)
      echo '#!/bin/bash
file="$1"
# Ensure we have the absolute path
[[ "$file" != /* ]] && file="$PWD/$file"

if [ ! -f "$file" ]; then
  echo "❌ Error: \"$file\" is not a valid file"
  exit 1
fi

mimetype=$(file --mime-type -b "$file")

# Check if the file is an image
if [[ $mimetype == image/* ]]; then
  # If img2sixel is available, use it to display the image
  if command -v img2sixel &> /dev/null; then
    echo "🖼️ Image: $file"
    echo "Type: $mimetype"
    echo "Size: $(du -h "$file" | cut -f1)"
    echo
    img2sixel -w 600 "$file"
  else
    echo "Image file: $mimetype"
    file "$file"
  fi
else
  # Not an image, use bat or cat to display it
  echo "📄 File: $file"
  echo "Type: $mimetype"
  echo "Size: $(du -h "$file" | cut -f1)"
  echo
  bat --style=numbers --color=always --line-range=:500 "$file" 2>/dev/null || cat "$file"
fi' > $file_preview_script
      chmod +x $file_preview_script

      # Browse files in the selected directory
      set -l file (fd --type f | fzf --ansi \
        --preview "$file_preview_script {}" \
        --preview-window=right:60% \
        --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
        --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 \
        --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 \
        --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 \
        --header "File Preview | Enter: open | Alt+B: back | Ctrl+C: copy path | ESC: exit" \
        --bind "alt-b:abort")
      
      rm $file_preview_script
      
      # Handle file selection
      if test -n "$file"
        # Make sure we have the absolute path
        if not string match -q "/*" $file
          set file "$PWD/$file"
        end
        
        # Check if file is an image
        set -l mimetype (file --mime-type -b "$file")
        if string match -q "image/*" $mimetype
          # Open with image viewer
          xdg-open "$file" &
        else
          # Open with editor
          $EDITOR "$file"
        end
        # Continue browsing after opening the file
      else
        # No file selected or Alt+B pressed
        # Loop will continue with directory selection
      end
    end
  end
  
  # Return to the starting directory when done
  cd $starting_dir
end


