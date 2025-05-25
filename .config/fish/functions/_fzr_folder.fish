function _fzr_folder

    # Create temp directory for cache if it doesn't exist
    test -d "$HOME/.cache/fzr" || mkdir -p "$HOME/.cache/fzr"
    
    # Default location to search, start with current directory if not specified
    set search_dir "."
    if test (count $argv) -gt 0
        set search_dir $argv[1]
    end
    
    # Create a direct preview script for fzf to use
    set preview_script "$HOME/.cache/fzr/preview_script.fish"
    
    # Write the preview script to a file that fzf can call directly
    mkdir -p (dirname $preview_script)
    
    echo '#!/usr/bin/env fish

set item $argv[1]

if test -d "$item"
    echo -e "\033[34m\033[1m## Directory: $item\033[0m"
    echo ""
    
    # Check if it\'s a git repository
    if test -d "$item/.git"
        echo -e "\033[33m\033[1m## Git Information\033[0m"
        pushd $item
        echo -e "\033[32mBranch:\033[0m" (git branch --show-current 2>/dev/null)
        echo -e "\033[32mStatus:\033[0m"
        git status -s 2>/dev/null
        echo -e "\033[32mLast commit:\033[0m"
        git log -1 --pretty=format:"%h %s (%ar)" 2>/dev/null
        echo ""
        popd
    end
    
    # Directory listing
    echo -e "\033[33m\033[1m## Directory Contents\033[0m"
    if type -q eza
        eza --tree -L 2 --color=always "$item"
    else if type -q lsd
        lsd --tree --depth 2 --color=always "$item"
    else
        ls -la "$item"
    end
else if test -f "$item"
    echo -e "\033[34m\033[1m## File: $item\033[0m"
    echo ""
    
    # File info
    file --brief "$item"
    echo ""
    
    # Get mime type
    set mime_type (file --brief --mime-type "$item")
    
    # File preview based on type
    switch $mime_type
        case "text/*"
            echo -e "\033[33m\033[1m## File Contents\033[0m"
            if string match -q "*.md" "$item"; and type -q glow
                glow --style=auto "$item"
            else if string match -rq "\\.(html|htm)$" "$item"; and type -q elinks
                elinks -dump "$item"
            else if string match -rq "\\.(html|htm)$" "$item"; and type -q w3m
                w3m -T text/html -dump "$item"
            else
                bat -p --color=always "$item"
            end
        
        case "image/*"
            echo -e "\033[33m\033[1m## Image Information\033[0m"
            if type -q mediainfo
                mediainfo "$item"
            else
                file "$item"
            end
            
            # Display image if terminal supports it and tools exist
            if type -q chafa
                chafa -f sixel -s "95x20" "$item" --animate false
            end
        
        case "application/json"
            if type -q jq
                jq --color-output < "$item"
            else
                bat -p --color=always "$item"
            end
        
        case "application/pdf"
            echo -e "\033[33m\033[1m## PDF Information\033[0m"
            pdfinfo "$item" 2>/dev/null || echo "PDF information not available"
        
        case "video/*"
            echo -e "\033[33m\033[1m## Video Information\033[0m"
            if type -q mediainfo
                mediainfo "$item"
            else
                file "$item"
            end
        
        case "*"
            if string match -q "*.zip" "$item"
                echo -e "\033[33m\033[1m## Archive Contents\033[0m"
                unzip -l "$item"
            else if string match -q "*.tar.gz" "$item"; or string match -q "*.tgz" "$item"
                echo -e "\033[33m\033[1m## Archive Contents\033[0m"
                tar tzf "$item"
            else if string match -q "*.tar" "$item"
                echo -e "\033[33m\033[1m## Archive Contents\033[0m"
                tar tf "$item"
            else if string match -q "*.rar" "$item"
                echo -e "\033[33m\033[1m## Archive Contents\033[0m"
                if type -q unrar
                    unrar l "$item"
                else
                    echo "unrar not installed"
                end
            else if string match -q "*.7z" "$item"
                echo -e "\033[33m\033[1m## Archive Contents\033[0m"
                if type -q 7z
                    7z l "$item"
                else
                    echo "7z not installed"
                end
            else
                bat -p --color=always "$item" 2>/dev/null || hexdump -C "$item" | head -20
            end
    end
else
    echo "Item not found or inaccessible: $item"
end' > $preview_script
    
    # Make the preview script executable
    chmod +x $preview_script
    
    # Define the key bindings - changed to:
    # - Enter: Show files in directory
    # - Alt+c: CD into directory
    set key_bindings "ctrl-o:execute(open_folder {})+abort,ctrl-v:execute(code {}),alt-c:execute(cd {} && fish),ctrl-f:execute(find_in_dir {})+abort,enter:execute(list_files {})"
    
    # Function to list files in a directory
    function list_files
        set dir $argv[1]
        if test -d "$dir"
            clear
            echo "Contents of $dir:"
            echo "------------------------------"
            if type -q eza
                eza -la --color=always "$dir"
            else if type -q lsd
                lsd -la --color=always "$dir"
            else
                ls -la "$dir"
            end
            echo "------------------------------"
            echo "Press any key to continue..."
            read -n 1
        end
    end
    
    # Find directories and present with fzf
    if type -q fd
        # If fd is available, use it
        fd --type directory --hidden --exclude ".git" . $search_dir | fzf \
            --prompt="Folders > " \
            --header="CTRL-O: Open folder, CTRL-V: Open in VSCode, ALT-C: CD into dir, ENTER: List files, CTRL-F: Find in dir" \
            --preview="$preview_script {}" \
            --preview-window="right:60%" \
            --bind=$key_bindings
    else
        # Fallback to find
        find $search_dir -type d -not -path "*/\.*" | fzf \
            --prompt="Folders > " \
            --header="CTRL-O: Open folder, CTRL-V: Open in VSCode, ALT-C: CD into dir, ENTER: List files, CTRL-F: Find in dir" \
            --preview="$preview_script {}" \
            --preview-window="right:60%" \
            --bind=$key_bindings
    end
end

# Helper function to open folder with default application
function open_folder
    set folder $argv[1]
    if test -d "$folder"
        if type -q xdg-open
            xdg-open "$folder"
        else if type -q open # macOS
            open "$folder"
        else
            echo "No suitable opener found"
        end
    end
end

# Helper function to find files in a selected directory
function find_in_dir
    set dir $argv[1]
    if test -d "$dir"
        cd "$dir"
        fzf --preview="bat --style=numbers --color=always {}" --preview-window="right:60%"
    end
end

# Set up the key binding for fzr_folder
# Alt+Shift+f to launch the folder search

# You can change the key binding to whatever you prefer:
# Some common options:
# - Alt+f: bind \ef 'fzr_folder; commandline -f repaint'
# - Ctrl+Alt+f: bind \e\cf 'fzr_folder; commandline -f repaint'
# - F4 key: bind -k f4 'fzr_folder; commandline -f repaint'
