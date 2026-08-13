
#!/usr/bin/env bash

set -Eeuo pipefail

# ============================================================
# Arch Linux setup
# Add packages to PACKAGES and repositories to REPOSITORIES.
# ============================================================

# --- Packages available in official Arch repositories ---
PACKAGES=(
    git
    nvim
    rofi
    mpd
    rmpc
    starship
    fish
    fzf
    eza
    zoxide
    fd
    tmux
    yazi
    stow
    foot
    openssh
    jq
    nodejs
    npm
    libfaketime
)

# --- Git repositories ---
# Format: "repository_url|destination"
REPOSITORIES=(
    "https://github.com/iamsurjog/hyprquickpaper|$HOME/.config/quickshell/hyprquickpaper"
)

# --- Output helpers ---
info() {
    printf '\n\033[1;34m[INFO]\033[0m %s\n' "$1"
}

success() {
    printf '\033[1;32m[ OK ]\033[0m %s\n' "$1"
}

warn() {
    printf '\033[1;33m[SKIP]\033[0m %s\n' "$1"
}

error() {
    printf '\033[1;31m[FAIL]\033[0m %s\n' "$1" >&2
}

# --- Checks ---
if [[ ! -f /etc/arch-release ]]; then
    error "This script is intended for Arch Linux."
    exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
    error "pacman was not found."
    exit 1
fi

# --- Install packages ---
install_packages() {
    info "Updating package databases and installing packages"

    sudo pacman -Syu --needed --noconfirm "${PACKAGES[@]}"

    success "Package installation complete"
}

# --- Clone repositories ---
install_repositories() {
    info "Installing Git repositories"

    if ! command -v git >/dev/null 2>&1; then
        error "Git is required. Add git to PACKAGES."
        return 1
    fi

    local entry url destination

    for entry in "${REPOSITORIES[@]}"; do
        IFS='|' read -r url destination <<< "$entry"

        if [[ -d "$destination/.git" ]]; then
            warn "Repository already exists: $destination"
            continue
        fi

        if [[ -e "$destination" ]]; then
            warn "Destination exists but is not a Git repository: $destination"
            continue
        fi

        mkdir -p "$(dirname "$destination")"

        info "Cloning $url"
        git clone "$url" "$destination"

        success "Cloned into $destination"
    done
}

# --- Main ---
main() {
    install_packages
    install_repositories

    success "Setup finished"
}

main "$@"

