
function _fzf_cd_preview
    # ┌──────────────────────────────────────────────────────────┐
    #  │  FZF Directory Navigator (Fish)                        │
    #  │  ↑/↓: Navigate  •  Tab: Select & Exit  •  Enter: Open  │
    #  │  Shift+Tab: Go Up  •  Esc: Cancel                      │
    # └──────────────────────────────────────────────────────────┘
    set -l cyan (set_color cyan)
    set -l normal (set_color normal)
    echo -e "$cyan"
    echo -e "┌────────────────────────────────────────────────────────┐"
    echo -e " │ ↑/↓: Navigate  •  Tab: Select & Exit  •  Enter: Open │"
    echo -e " │ Shift+Tab: Go Up  •  Esc: Cancel                     │"
    echo -e "└────────────────────────────────────────────────────────┘$normal"

    # Get current command state
    set -l cmdline (commandline)
    set -l current_dir (pwd)
    set -l search_term ""
    set -l cmd_prefix ""

    # Parse command line
    if string match -qr '^\s*cd\s+' "$cmdline"
        set cmd_prefix "cd "
        set search_term (string replace -r '^\s*cd\s+' '' -- "$cmdline")
    else if string match -qr '^\s*[^ ]+' "$cmdline"
        set search_term (string trim "$cmdline")
    end

    # Handle search term ending with /
    if string match -q "*/" "$search_term"
        set -l target_dir (string replace -r '/$' '' "$search_term")
        if test -d "$current_dir/$target_dir"
            set current_dir "$current_dir/$target_dir"
            set search_term ""
        end
    end

    set -l initial_query "$search_term"

    while true
        set -l result (
            begin
                fd --type d --follow --max-depth 1 --hidden --no-ignore . "$current_dir" \
                | xargs -I{} basename {} \
                | sort
                echo "z__EMPTY_DIR__"
            end | \
            fzf \
                --layout=reverse \
                --height=60% \
                --prompt "(📂) $current_dir > " \
                --preview "if [ '{}' = 'z__EMPTY_DIR__' ]; then echo 'Empty directory'; else eza --icons --color=always --all --tree --level=1 '$current_dir/{}'; fi" \
                --preview-window=right:50% \
                --expect=tab,enter,btab \
                --query="$initial_query"
        )

        set initial_query ""
        set -l key $result[1]
        set -l selected $result[2]

        if test -z "$selected"
            commandline -r ""
            return
        end

        switch $key
            case btab  # Shift+Tab - Go up
                set current_dir (dirname "$current_dir")

            case tab  # Tab - Select and exit
                if test "$selected" != "z__EMPTY_DIR__"
                    set -l abs_path "$current_dir/$selected"
                    set -l rel_path (string replace "$HOME" "~" "$abs_path")
                    commandline -r ""
                    commandline -f repaint
                    commandline -i "$cmd_prefix$rel_path"
                    return
                end

            case enter  # Enter - Navigate into
                if test "$selected" != "z__EMPTY_DIR__"
                    set current_dir "$current_dir/$selected"
                end
        end
    end

    # Final path processing when exiting loop
    set -l rel_path (string replace "$HOME" "~" "$current_dir")
    commandline -r ""
    commandline -i "$cmd_prefix$rel_path"
    commandline -f execute
end

