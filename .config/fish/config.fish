set  fish_greeting 
 #oh-my-posh init fish --config ~/Documents/oh-my-posh-config/ompcollinsv1.json | source
function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

starship init fish | source

# source ~/.local/share/icons-in-terminal/icons.fish

set -gx STARSHIP_CONFIG ~/devs/dotfiles/shared/starship/catpuccin/starship.toml 

set -x PATH $PATH $HOME/.npm-packages/bin
# Add NVM to PATH for Fish shell
set -x PATH $HOME/.nvm/bin $PATH

if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
    cat ~/.cache/ags/user/generated/terminal/sequences.txt
end

set -gx BAT_THEME "base16"

# eval (python3.11 -m virtualfish)

export PATH="$PATH:$HOME/bin"

# === [fzf + fuzzy history/file/directory search] ===

# Alt+R: fuzzy command history
bind \er '_fzf_search_history'

# Alt+T: fuzzy file search
bind \et '_fzf_open_file'

# Alt+C: fuzzy directory jump via zoxide
bind \ec '_fzf_cd'

bind \ef '_fzf_open_directory'

bind \eg '_fzf_open_full_search'

bind \eh '_fzr_all_folder'

# Set up the key binding for fzr_folder
# Alt+Shift+f to launch the folder search
bind \eb '_fzr_folder; commandline -f repaint'

bind \cf '_fzf_cd_preview'

# Alt+. and Alt+Right: insert last argument
bind \e. history-token-search-backward
bind \e\[C history-token-search-backward
#
# # === [fzf.fish options (customize as needed)] ===
#
set -U FZF_PREVIEW_COMMAND "bat --style=numbers --color=always {} || cat {}"
set -U FZF_FIND_FILE_COMMAND "fd --type f"
set -U FZF_CD_COMMAND "zoxide query -l"
set -U fzf_preview_file_cmd 'bat --style=numbers,changes --color=always'
set -U fzf_preview_dir_cmd 'exa --all --color=always --tree --level=2'

set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_STATE_HOME "$HOME/.local/state"

#
# set -e fzf_directory_command  # Remove custom command
# set -U fzf_fd_opts "--hidden --no-ignore --type d"  # Just set fd options

set -e fzf_directory_command
#
set -gx EDITOR nvim

# === [command-not-found integration] ===

# Find the Command (ftc)
if test -f /usr/share/doc/find-the-command/ftc.fish
    source /usr/share/doc/find-the-command/ftc.fish noprompt quiet noupdate
end

# Pkgfile fallback
if test -f /usr/share/doc/pkgfile/command-not-found.fish
    source /usr/share/doc/pkgfile/command-not-found.fish
end


# Created by `pipx` on 2023-12-08 22:53:07
# set PATH $PATH /home/collins/.local/bin

# Set ANDROID_HOME
# set -x ANDROID_HOME ~/Library/Android/sdk

# Add Android SDK tools to PATH
# set -x PATH $PATH $ANDROID_HOME/cmdline-tools/latest/bin $ANDROID_HOME/platform-tools $ANDROID_HOME/build-tools/* $ANDROID_HOME/tools
set -U fish_user_paths "$HOME/.config/rofi/scripts" $fish_user_paths

# aliases
alias gitconfunset="git config --unset-all --global user.name && git config --unset-all --global user.email"
alias gitconfset="git config --global user.email \"collinsruto48@gmail.com\" && git config --global user.name \"collins-ruto\""
alias gitconfsetlocal="git config user.email \"collinsruto48@gmail.com\" && git config user.name \"collins-ruto\""
alias deploy201="dfx deploy dfinity_js_backend && dfx generate dfinity_js_backend && dfx deploy dfinity_js_frontend"
alias firstdeploy201="bash deploy-local-ledger.sh && dfx deploy internet_identity && dfx deploy dfinity_js_backend && dfx generate dfinity_js_backend && dfx deploy dfinity_js_frontend"

alias pamcan=pacman
alias v=nvim


# bindings
# bind \cr replay_history
