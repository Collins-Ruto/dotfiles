function _fzf_open_full_search
  # Save starting directory to return to later
  set -l starting_dir $PWD
  
  # Directories to exclude
  set -l exclude_dirs node_modules .git venv target dist coverage BraveSoftware lazy mason chromium backup move language Code "Code\ -\ OSS"
  
  # Build the fd commands with exclude options - using absolute paths
  # Added --threads=4 for parallel search and --hidden to include hidden files
  set -l cmd1 "fd --type d --hidden --threads=4 --follow --max-depth 4 --base-directory $HOME"
  set -l cmd2 "fd --type d --hidden --threads=4 --max-depth 3 --base-directory $HOME/.config"
  
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
  
  # Create preview script once outside the loop for better performance
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

# Faster directory info gathering
echo "📦 Directory Info:"
echo "Path: $dir"
du -sh "$dir" 2>/dev/null | cut -f1
echo "Items: $(ls -1A "$dir" | wc -l) entries"

# Show some sample contents - faster implementation
echo
echo "📂 Contents (sample):"
ls -la "$dir" 2>/dev/null | head -n 8

# Quick git status if applicable
if [ -d "$dir/.git" ]; then
  echo
  echo "🔧 Git Repository"
  git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "(Not a git repo)"
fi' > $preview_script
  chmod +x $preview_script
  
  # File preview script with img2sixel support - created once outside the loop
  set -l file_preview_script (mktemp)
  echo '#!/bin/bash
file="$1"
# Ensure we have the absolute path
[[ "$file" != /* ]] && file="$PWD/$file"

if [ ! -f "$file" ]; then
  echo "❌ Error: \"$file\" is not a valid file"
  exit 1
fi

# Fast mimetype check
mimetype=$(file --mime-type -b "$file")

# Check file size - don\'t try to preview huge files
size=$(du -k "$file" | cut -f1)
if [ "$size" -gt 1000 ]; then
  echo "📄 Large file: $file"
  echo "Type: $mimetype"
  echo "Size: $(du -h "$file" | cut -f1)"
  echo
  echo "File too large for full preview"
  head -n 20 "$file"
  exit 0
fi

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
  bat --style=numbers --color=always --line-range=:300 "$file" 2>/dev/null || head -n 300 "$file"
fi' > $file_preview_script
  chmod +x $file_preview_script
  
  while test "$continue_browsing" = "true"    
    # Reset to home directory each time we go up a level for directory selection
    cd $HOME
    
    # Cache or use cached results for main directory listing
    if test -z "$main_results_cache"
      # Run commands in parallel for better performance
      set main_results_cache (bash -c "($cmd1 & $cmd2) | sort")
    end
    
    # Display the directories with proper preview and extra keybindings
    set -l selected_dir (printf "%s\n" $main_results_cache | fzf --ansi --preview "$preview_script {}" \
      --preview-window=right:60% \
      --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
      --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 \
      --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 \
      --color=marker:#ff79c6,spinner:#ffb86c,header:#00ffff \
      --header "Enter: explore | Alt+B: back | Alt+C: cd to dir | Alt+Y: copy path | ESC: exit" \
      --bind "alt-b:abort" \
      --bind "alt-c:execute(echo 'CD_TO_DIR:{}')+abort" \
      --bind "alt-y:execute(echo 'COPY_PATH:{}')+abort" \
      --bind "esc:abort")
    
    # Handle special cases for directory action commands
    if string match -q "CD_TO_DIR:*" $selected_dir
      set selected_dir (string replace "CD_TO_DIR:" "" $selected_dir)
      
      # Convert to absolute path
      if string match -q "~*" $selected_dir
        set selected_dir (string replace '~' $HOME $selected_dir)
      else if string match -q ".config/*" $selected_dir
        set selected_dir "$HOME/$selected_dir"
      else if not string match -q "/*" $selected_dir
        set selected_dir "$HOME/$selected_dir"
      end
      
      # CD to directory and exit
      if test -d "$selected_dir"
        cd $starting_dir
        echo "Changing directory to: $selected_dir"
        cd "$selected_dir"
        set continue_browsing false
      else
        echo "Invalid directory: $selected_dir"
        sleep 1
      end
      continue
    end
    
    # Handle copy path command
    if string match -q "COPY_PATH:*" $selected_dir
      set selected_dir (string replace "COPY_PATH:" "" $selected_dir)
      
      # Convert to absolute path
      if string match -q "~*" $selected_dir
        set selected_dir (string replace '~' $HOME $selected_dir)
      else if string match -q ".config/*" $selected_dir
        set selected_dir "$HOME/$selected_dir"
      else if not string match -q "/*" $selected_dir
        set selected_dir "$HOME/$selected_dir"
      end
      
      # Copy the path to clipboard
      if test -d "$selected_dir"
        echo -n "$selected_dir" | xclip -selection clipboard
        echo "Path copied to clipboard: $selected_dir"
        sleep 1
      else
        echo "Invalid directory: $selected_dir"
        sleep 1
      end
      continue
    end
    
    # Handle Alt+B or exit (ESC)
    if test -z "$selected_dir"
      # Immediate exit on ESC
      cd $starting_dir
      set continue_browsing false
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
        sleep 1
        continue
      end
      
      # Selected a valid directory, explore it
      set current_dir $selected_dir
      # Add to history
      set -a dir_history $current_dir
      cd "$current_dir"
      
      # Browse files in the selected directory with enhanced keybindings
      set -l file (fd --type f --threads=4 --max-depth=1 | fzf --ansi \
        --preview "$file_preview_script {}" \
        --preview-window=right:60% \
        --color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
        --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 \
        --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 \
        --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4 \
        --header "Enter: open | Alt+B: back | Alt+Y: copy path | ESC: exit" \
        --bind "alt-b:abort" \
        --bind "alt-y:execute(echo 'COPY_PATH:{}')+abort" \
        --bind "esc:abort")
      
      # Handle copy path for file
      if string match -q "COPY_PATH:*" $file
        set file (string replace "COPY_PATH:" "" $file)
        
        # Make sure we have the absolute path
        if not string match -q "/*" $file
          set file "$PWD/$file"
        end
        
        # Copy path to clipboard and continue browsing
        echo -n "$file" | xclip -selection clipboard
        echo "Path copied to clipboard: $file"
        sleep 1
        continue
      end
      
      # Handle file selection
      if test -n "$file"
        # Make sure we have the absolute path
        if not string match -q "/*" $file
          set file "$PWD/$file"
        end
        
        # Check if file is an image for faster opening
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
        # No file selected, ESC pressed, or Alt+B pressed
        # If ESC was pressed, break out completely
        if string match -q "*esc*" (status last-pipestatus)
          cd $starting_dir
          set continue_browsing false
        end
        # Otherwise loop will continue with directory selection
      end
    end
  end
  
  # Clean up temp files
  rm -f $preview_script $file_preview_script
  
  # Return to the starting directory when done
  cd $starting_dir
end
