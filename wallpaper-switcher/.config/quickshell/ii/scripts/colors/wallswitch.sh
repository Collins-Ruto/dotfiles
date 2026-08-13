#!/usr/bin/env bash
# wallswitch — portable wallpaper switcher for any Hyprland install.
# Backends (auto-detected): awww/swww, hyprpaper, swaybg, mpvpaper (video).
# Optional: matugen colour theming, rofi/wofi/fuzzel/fzf picker.
#
# Usage:
#   wallswitch.sh /path/to/image.png        set a wallpaper
#   wallswitch.sh /path/to/dir              pick from a directory
#   wallswitch.sh --random [DIR]            random wallpaper from DIR
#   wallswitch.sh --pick [DIR]              choose with a menu (rofi/wofi/fuzzel/fzf)
#   wallswitch.sh --restore                 re-apply last wallpaper (put in exec-once)
#   wallswitch.sh --list-backends           show what's installed
# Options:
#   --backend NAME     force awww|swww|hyprpaper|swaybg|mpvpaper
#   --mode dark|light  passed to matugen / sets GTK colour scheme
#   --theme            run matugen on the wallpaper (if installed)
#   --transition TYPE  swww/awww transition (default: fade)
#   --fit MODE         swaybg/mpvpaper fit: fill|fit|stretch|center (default: fill)
#   -h, --help
#
# Hyprland autostart example (hyprland.conf):
#   exec-once = ~/.local/bin/wallswitch.sh --restore
# Keybind example:
#   bind = SUPER, W, exec, ~/.local/bin/wallswitch.sh --pick ~/Pictures/Wallpapers

set -u

APP="wallswitch"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/$APP"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/$APP"
CURRENT_FILE="$STATE_DIR/current"
DEFAULT_DIR="${WALLSWITCH_DIR:-$HOME/Pictures/Wallpapers}"
IMG_EXT='jpg|jpeg|png|webp|bmp|gif|avif|jxl'
VID_EXT='mp4|webm|mkv|avi|mov'

mkdir -p "$STATE_DIR" "$CACHE_DIR"

# ---------- helpers ----------
have() { command -v "$1" >/dev/null 2>&1; }
log()  { echo "[$APP] $*" >&2; }
notify() { have notify-send && notify-send -a "$APP" "$@" || true; }
die()  { log "error: $*"; notify "Wallpaper error" "$*"; exit 1; }

ext_of() { local e="${1##*.}"; echo "${e,,}"; }
is_video() { [[ "$(ext_of "$1")" =~ ^($VID_EXT)$ ]]; }
is_image() { [[ "$(ext_of "$1")" =~ ^($IMG_EXT)$ ]]; }

list_media() { # list media files in dir
  find -L "$1" -type f 2>/dev/null | grep -iE "\.($IMG_EXT|$VID_EXT)$" | sort
}

monitors() {
  if have hyprctl && have jq; then
    hyprctl monitors -j 2>/dev/null | jq -r '.[].name'
  fi
}

detect_backend() {
  if [[ -n "$BACKEND" ]]; then echo "$BACKEND"; return; fi
  if is_video "$1"; then
    have mpvpaper && { echo mpvpaper; return; }
    die "video wallpaper needs mpvpaper (and ffmpeg for theming)"
  fi
  for b in awww swww hyprpaper swaybg; do
    have "$b" && { echo "$b"; return; }
  done
  die "no backend found. Install one of: awww, swww, hyprpaper, swaybg"
}

stop_others() { # kill daemons of other backends so they don't paint over us
  local keep="$1"
  [[ "$keep" != mpvpaper ]] && pkill -x mpvpaper 2>/dev/null
  [[ "$keep" != swaybg ]]   && pkill -x swaybg 2>/dev/null
  [[ "$keep" != hyprpaper ]] && pkill -x hyprpaper 2>/dev/null
  [[ "$keep" != swww && "$keep" != awww ]] && { pkill -x swww-daemon 2>/dev/null; pkill -x awww-daemon 2>/dev/null; }
  return 0
}

# ---------- backends ----------
apply_swww() { # $1 = binary (swww|awww), $2 = file
  local bin="$1" file="$2" daemon="$1-daemon"
  if ! "$bin" query >/dev/null 2>&1; then
    setsid "$daemon" >/dev/null 2>&1 &
    for _ in $(seq 1 30); do "$bin" query >/dev/null 2>&1 && break; sleep 0.1; done
  fi
  "$bin" img "$file" --transition-type "$TRANSITION" --transition-fps 60 --transition-duration 1.2
}

apply_hyprpaper() {
  local file="$1"
  if ! pgrep -x hyprpaper >/dev/null; then
    setsid hyprpaper >/dev/null 2>&1 &
    for _ in $(seq 1 30); do hyprctl hyprpaper listloaded >/dev/null 2>&1 && break; sleep 0.1; done
  fi
  hyprctl hyprpaper preload "$file" >/dev/null 2>&1 || true   # removed in newer versions; harmless
  local mons; mons="$(monitors)"
  if [[ -z "$mons" ]]; then
    hyprctl hyprpaper wallpaper ",$file" >/dev/null
  else
    while read -r m; do hyprctl hyprpaper wallpaper "$m,$file" >/dev/null; done <<< "$mons"
  fi
  hyprctl hyprpaper unload unused >/dev/null 2>&1 || true
}

apply_swaybg() {
  pkill -x swaybg 2>/dev/null
  setsid swaybg -i "$1" -m "$FIT" >/dev/null 2>&1 &
}

apply_mpvpaper() {
  local file="$1" opts="no-audio loop hwdec=auto panscan=1.0 load-scripts=no"
  pkill -f mpvpaper 2>/dev/null
  local mons; mons="$(monitors)"
  [[ -z "$mons" ]] && mons="ALL"
  while read -r m; do
    setsid mpvpaper -o "$opts" "$m" "$file" >/dev/null 2>&1 &
    sleep 0.1
  done <<< "$mons"
}

set_wallpaper() {
  local file; file="$(realpath "$1")"
  [[ -f "$file" ]] || die "file not found: $1"
  local backend; backend="$(detect_backend "$file")"
  have "$backend" || die "backend '$backend' is not installed"

  stop_others "$backend"
  case "$backend" in
    awww|swww) apply_swww "$backend" "$file" ;;
    hyprpaper) apply_hyprpaper "$file" ;;
    swaybg)    apply_swaybg "$file" ;;
    mpvpaper)  apply_mpvpaper "$file" ;;
    *) die "unknown backend: $backend" ;;
  esac

  echo "$file" > "$CURRENT_FILE"
  echo "$backend" > "$STATE_DIR/backend"
  log "set $file via $backend"

  # image used for colour generation (thumbnail for video)
  local theme_src="$file"
  if is_video "$file"; then
    if have ffmpeg; then
      theme_src="$CACHE_DIR/$(basename "$file").jpg"
      ffmpeg -y -loglevel error -i "$file" -vframes 1 "$theme_src" || theme_src=""
    else
      theme_src=""
    fi
  fi
  [[ "$THEME" == 1 && -n "$theme_src" ]] && run_theme "$theme_src"
  return 0
}

run_theme() {
  local img="$1"
  if [[ -n "$MODE" ]] && have gsettings; then
    if [[ "$MODE" == dark ]]; then
      gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null
    else
      gsettings set org.gnome.desktop.interface color-scheme 'prefer-light' 2>/dev/null
    fi
  fi
  if have matugen; then
    local args=(image "$img")
    [[ -n "$MODE" ]] && args+=(--mode "$MODE")
    matugen "${args[@]}" >/dev/null 2>&1 || log "matugen failed"
  else
    log "--theme requested but matugen isn't installed"
  fi
}

# ---------- selection ----------
menu() { # reads items on stdin, prints choice
  if   have rofi;   then rofi -dmenu -i -p "Wallpaper"
  elif have wofi;   then wofi --dmenu -i -p "Wallpaper"
  elif have fuzzel; then fuzzel --dmenu -p "Wallpaper "
  elif have fzf;    then fzf --prompt="Wallpaper> "
  else die "no menu found (install rofi, wofi, fuzzel or fzf)"; fi
}

pick_from_dir() {
  local dir="$1"
  [[ -d "$dir" ]] || die "directory not found: $dir"
  local choice
  choice="$(list_media "$dir" | sed "s|^$dir/||" | menu)" || exit 0
  [[ -z "$choice" ]] && exit 0
  echo "$dir/$choice"
}

random_from_dir() {
  local dir="$1"
  [[ -d "$dir" ]] || die "directory not found: $dir"
  local cur=""; [[ -f "$CURRENT_FILE" ]] && cur="$(cat "$CURRENT_FILE")"
  local pick
  pick="$(list_media "$dir" | grep -vxF "$cur" | shuf -n1)"
  [[ -z "$pick" ]] && pick="$(list_media "$dir" | shuf -n1)"
  [[ -z "$pick" ]] && die "no media found in $dir"
  echo "$pick"
}

usage() { sed -n '2,28p' "$0" | sed 's/^# \{0,1\}//'; }

list_backends() {
  for b in awww swww hyprpaper swaybg mpvpaper; do
    have "$b" && echo "  [x] $b" || echo "  [ ] $b"
  done
  for t in matugen ffmpeg jq hyprctl rofi wofi fuzzel fzf; do
    have "$t" && echo "  [x] $t" || echo "  [ ] $t"
  done
}

# ---------- main ----------
BACKEND=""; MODE=""; THEME=0; TRANSITION="fade"; FIT="fill"
ACTION="set"; TARGET=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --backend)    BACKEND="$2"; shift 2 ;;
    --mode)       MODE="$2"; shift 2 ;;
    --theme)      THEME=1; shift ;;
    --transition) TRANSITION="$2"; shift 2 ;;
    --fit)        FIT="$2"; shift 2 ;;
    --random)     ACTION="random"; shift ;;
    --pick)       ACTION="pick"; shift ;;
    --restore)    ACTION="restore"; shift ;;
    --list-backends) list_backends; exit 0 ;;
    -h|--help)    usage; exit 0 ;;
    -*)           die "unknown option: $1" ;;
    *)            TARGET="$1"; shift ;;
  esac
done

case "$ACTION" in
  restore)
    [[ -f "$CURRENT_FILE" ]] || die "nothing to restore yet"
    # on login the compositor may not be ready — wait briefly
    for _ in $(seq 1 20); do hyprctl monitors >/dev/null 2>&1 && break; sleep 0.25; done
    [[ -z "$BACKEND" && -f "$STATE_DIR/backend" ]] && BACKEND="$(cat "$STATE_DIR/backend")"
    set_wallpaper "$(cat "$CURRENT_FILE")"
    ;;
  random)
    set_wallpaper "$(random_from_dir "${TARGET:-$DEFAULT_DIR}")"
    ;;
  pick)
    set_wallpaper "$(pick_from_dir "${TARGET:-$DEFAULT_DIR}")"
    ;;
  set)
    if [[ -z "$TARGET" ]]; then
      TARGET="$DEFAULT_DIR"
    fi
    if [[ -d "$TARGET" ]]; then
      set_wallpaper "$(pick_from_dir "$TARGET")"
    else
      set_wallpaper "$TARGET"
    fi
    ;;
esac
