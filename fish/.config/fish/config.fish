set fish_greeting 
#oh-my-posh init fish --config ~/Documents/oh-my-posh-config/ompcollinsv1.json | source

function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

starship init fish | source

zoxide init fish | source

# source ~/.local/share/icons-in-terminal/icons.fish

set -gx STARSHIP_CONFIG ~/.config/starship/catpuccin.toml 

# === PATH SETUP ===
# Add paths in order of priority
fish_add_path $HOME/.local/bin
fish_add_path $HOME/bin
fish_add_path $HOME/.npm-packages/bin

# Java setup
set -gx JAVA_HOME "/usr/lib/jvm/java-17-openjdk"
fish_add_path $JAVA_HOME/bin

# Android SDK setup
set -gx ANDROID_HOME "/home/collyArch/Library/Android/sdk"
fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $ANDROID_HOME/emulator

# === NVM SETUP (with error handling) ===
set -gx NVM_DIR "$HOME/.nvm"

# Load nvm from bash into fish with error handling
if test -f "$NVM_DIR/nvm.sh"
    if functions -q bass
        bass source $NVM_DIR/nvm.sh --no-use 2>/dev/null
        if test -f "$NVM_DIR/bash_completion"
            bass source $NVM_DIR/bash_completion 2>/dev/null
        end
    else
        echo "Warning: bass not installed, nvm not loaded"
    end
end

# === OTHER ENVIRONMENT VARIABLES ===
if test -f ~/.cache/ags/user/generated/terminal/sequences.txt
    cat ~/.cache/ags/user/generated/terminal/sequences.txt
end

set -gx BAT_THEME "base16"
set -gx EDITOR nvim

# XDG directories
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_STATE_HOME "$HOME/.local/state"

# === FZF CONFIGURATION ===
# Key bindings
bind \er '_fzf_search_history'        # Alt+R: fuzzy command history
bind \et '_fzf_open_file'             # Alt+T: fuzzy file search
bind \ec '_fzf_cd'                    # Alt+C: fuzzy directory jump via zoxide
bind \ef '_fzf_open_directory'
bind \eg '_fzf_open_full_search'
bind \eh '_fzr_all_folder'
bind \eb '_fzr_folder; commandline -f repaint'  # Alt+Shift+f to launch folder search
bind \cf '_fzf_cd_preview'
bind \e. history-token-search-backward # Alt+. and Alt+Right: insert last argument

# FZF options
set -U FZF_PREVIEW_COMMAND "bat --style=numbers --color=always {} || cat {}"
set -U FZF_FIND_FILE_COMMAND "fd --type f"
set -U FZF_CD_COMMAND "zoxide query -l"
set -U fzf_preview_file_cmd 'bat --style=numbers,changes --color=always'
set -U fzf_preview_dir_cmd 'exa --all --color=always --tree --level=2'
set -e fzf_directory_command

# === COMMAND-NOT-FOUND INTEGRATION ===
if test -f /usr/share/doc/find-the-command/ftc.fish
    source /usr/share/doc/find-the-command/ftc.fish noprompt quiet noupdate
end

if test -f /usr/share/doc/pkgfile/command-not-found.fish
    source /usr/share/doc/pkgfile/command-not-found.fish
end

# === ROFI SCRIPTS (moved to end to lower priority) ===
# Only add if directory exists and contains executable scripts
if test -d "$HOME/.config/rofi/scripts"
    fish_add_path "$HOME/.config/rofi/scripts"
end

# === ALIASES ===
alias gitconfunset="git config --unset-all --global user.name && git config --unset-all --global user.email"
alias gitconfset="git config --global user.email \"collinsruto48@gmail.com\" && git config --global user.name \"collins-ruto\""
alias gitconfsetlocal="git config user.email \"collinsruto48@gmail.com\" && git config user.name \"collins-ruto\""
alias deploy201="dfx deploy dfinity_js_backend && dfx generate dfinity_js_backend && dfx deploy dfinity_js_frontend"
alias firstdeploy201="bash deploy-local-ledger.sh && dfx deploy internet_identity && dfx deploy dfinity_js_backend && dfx generate dfinity_js_backend && dfx deploy dfinity_js_frontend"
alias pamcan=pacman
alias v=nvim
alias cd=z
alias c=clear

# === UNCOMMENTED BINDINGS ===
# bind \cr replay_history
