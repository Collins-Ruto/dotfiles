---

# 🧩 tmux Cheatsheet (Tailored to Your Config)

> _A comprehensive reference for your tmux setup (prefix, keybinds, plugins) + the “standard” tmux commands & power tricks._

---

# 🧩 tmux Cheatsheet (Prefix: `C-a`) — Full + Your Plugins

> **Prefix = `C-a`** (Ctrl+a)
> Notation: `M-` = Alt, `S-` = Shift, `C-` = Ctrl

## ⚙️ Your tmux Defaults (from your `tmux.conf`)

| Setting                  |            Value | What it means                                                     |
| ------------------------ | ---------------: | ----------------------------------------------------------------- |
| **Prefix**               |            `C-a` | Your tmux leader key is **Ctrl+a** (instead of `C-b`)             |
| Mouse                    |             `on` | Click to select panes, resize, scroll (Hyprland/Wayland friendly) |
| Window index             |              `1` | Windows start at **1**                                            |
| Renumber windows         |             `on` | Closing a window renumbers the rest                               |
| Copy to system clipboard | `on` + `wl-copy` | Copy-mode/yank integrates with Wayland clipboard                  |
| Copy-mode keys           |             `vi` | Vi-style copy-mode navigation                                     |
| Default shell            |           `fish` | New panes/windows start in fish                                   |
| Status bar               |            `top` | Status line is at the top                                         |
| History limit            |      `1,000,000` | Massive scrollback                                                |

---

## 🔁 Reloading Config

| Keybinding | Action             | Description                                           |
| ---------- | ------------------ | ----------------------------------------------------- |
| `C-a r`    | Reload tmux config | Sources `~/.config/tmux/tmux.conf` and reloads config |

---

# 🧠 Core Mental Model

- **Server** → Holds everything
- **Session** → Workspace
- **Window** → Tab
- **Pane** → Split

---

# 🪟 Sessions

### Keybindings

| Keybinding | Action                   |
| ---------- | ------------------------ |
| `C-a s`    | Choose session           |
| `C-a d`    | Detach                   |
| `C-a $`    | Rename session           |
| `C-a (`    | Previous client          |
| `C-a )`    | Next client              |
| `C-a L`    | Last client              |
| `C-a D`    | Choose & detach a client |

### CLI [ create / attach / list ]

```bash
tmux new -s dev
tmux new -A -s dev
tmux a -t dev
tmux ls
tmux kill-session -t dev
tmux kill-server
```

---

# 🪟 Windows

| Keybinding | Action                          |
| ---------- | ------------------------------- |
| `C-a c`    | New window                      |
| `C-a ,`    | Rename window                   |
| `C-a .`    | Move window                     |
| `C-a &`    | Kill window                     |
| `C-a q`    | Kill window (custom quick kill) |
| `C-a n`    | Next window                     |
| `C-a p`    | Previous window                 |
| `C-a 0..9` | Jump to window                  |
| `C-a w`    | Choose window                   |
| `C-a '`    | Prompt for window index         |
| `C-a <`    | Window menu                     |
| `C-a i`    | Window info                     |
| `C-a M-n`  | Next window with alert          |
| `C-a M-p`  | Previous window with alert      |

---

# 🧱 Panes

### Split / Create

| Keybinding | Action                        |
| ---------- | ----------------------------- |
| `C-a %`    | Split horizontal (left/right) |
| `C-a "`    | Split vertical (top/bottom)   |
| `C-a !`    | Break pane into new window    |
| `C-a z`    | Zoom pane                     |

### Navigation (Prefix)

| Keybinding               | Action         |
| ------------------------ | -------------- |
| `C-a h`                  | Move left      |
| `C-a j`                  | Move down      |
| `C-a k`                  | Move up        |
| `C-a l`                  | Move right     |
| `C-a Up/Down/Left/Right` | Move by arrows |
| `C-a ;`                  | Previous pane  |

### Navigation (No Prefix — vim-tmux-navigator)

| Keybinding | Action                      |
| ---------- | --------------------------- |
| `C-h`      | Smart left (vim/tmux aware) |
| `C-j`      | Smart down                  |
| `C-k`      | Smart up                    |
| `C-l`      | Smart right                 |
| `C-\`      | Toggle last pane            |

## 🧠 Vim ↔ tmux navigation (christoomey/vim-tmux-navigator)

| Keys        | Action                                                    |
| ----------- | --------------------------------------------------------- |
| `C-h/j/k/l` | Move between tmux panes OR send to (n)vim/fzf when active |
| `C-\`       | Toggle last pane OR send to vim when active               |

> The `if-shell ... grep ... (view|nvim|vim|fzf)` logic is exactly what makes it “smart”.

---

### Swap / Rotate

| Keybinding | Action               |
| ---------- | -------------------- |
| `C-a {`    | Swap with pane above |
| `C-a }`    | Swap with pane below |
| `C-a C-o`  | Rotate panes forward |
| `C-a M-o`  | Rotate panes reverse |

---

# 📐 Layouts

| Keybinding  | Layout                   |
| ----------- | ------------------------ |
| `C-a M-1`   | even-horizontal          |
| `C-a M-2`   | even-vertical            |
| `C-a M-3`   | main-horizontal          |
| `C-a M-4`   | main-vertical            |
| `C-a M-5`   | tiled                    |
| `C-a M-6`   | main-horizontal-mirrored |
| `C-a M-7`   | main-vertical-mirrored   |
| `C-a E`     | Evenly spread panes      |
| `C-a Space` | Cycle layouts            |

---

# 📏 Resizing

| Keybinding                 | Action      |
| -------------------------- | ----------- |
| `C-a C-Up/Down/Left/Right` | Resize by 1 |
| `C-a M-Up/Down/Left/Right` | Resize by 5 |

---

## 🧭 Scrolling the Viewport (not selecting panes)

These move the **visible part** of the window (useful in copy-mode-ish viewing):

| Keys                       | Action        |
| -------------------------- | ------------- |
| `C-a S-Up/Down/Left/Right` | Move viewport |

And:

| Keys     | Action                                     |
| -------- | ------------------------------------------ |
| `C-a DC` | Re-follow cursor (reset viewport tracking) |

---

# 📋 Copy Mode (Vi)

| Keybinding  | Action                |
| ----------- | --------------------- |
| `C-a [`     | Enter copy mode       |
| `C-a PPage` | Copy mode + scroll up |
| `Space`     | Begin selection       |
| `Enter`     | Copy                  |
| `/`         | Search forward        |
| `?`         | Search backward       |
| `n/N`       | Next/previous match   |
| `q`         | Quit                  |

> In copy-mode (vi-style if you set it):
> `Space` start selection → move → `Enter` copy → `q` quit

### Buffers

| Keybinding | Action                    |
| ---------- | ------------------------- |
| `C-a ]`    | Paste                     |
| `C-a #`    | List buffers              |
| `C-a =`    | Choose buffer             |
| `C-a -`    | Delete most recent buffer |

## 🔎 Finding Things / Info / Help

| Keys    | Action                     |
| ------- | -------------------------- |
| `C-a f` | Search for a pane          |
| `C-a i` | Display window information |
| `C-a ?` | List key bindings          |
| `C-a /` | Describe key binding       |
| `C-a ~` | Show messages              |
| `C-a :` | Command prompt             |

---

## 🕰️ Misc

| Keys      | Action                 |
| --------- | ---------------------- |
| `C-a t`   | Clock                  |
| `C-a C-z` | Suspend current client |
| `C-a M`   | Clear marked pane      |
| `C-a m`   | Toggle marked pane     |

---

# 🔌 Plugins (Exact Binds)

## 🧠 SessionX

| Keybinding | Action                     |
| ---------- | -------------------------- |
| `C-a o`    | Open session/window picker |

## 🪟 Floax

| Keybinding | Action                   |
| ---------- | ------------------------ |
| `C-a p`    | Toggle floating terminal |
| `C-a P`    | Floax menu               |

## 🔎 tmux-fzf

| Keybinding | Action          |
| ---------- | --------------- |
| `C-a F`    | Launch fzf menu |

## 🔗 tmux-fzf-url

| Keybinding | Action     |
| ---------- | ---------- |
| `C-a u`    | URL picker |

## 🔤 tmux-thumbs

| Keybinding  | Action                 |
| ----------- | ---------------------- |
| `C-a Space` | Jump/copy visible text |

## 📋 tmux-yank

| Keybinding | Action                      |
| ---------- | --------------------------- |
| `C-a y`    | Copy line                   |
| `C-a Y`    | Copy pane working directory |

## 💾 tmux-resurrect

| Keybinding | Action          |
| ---------- | --------------- |
| `C-a C-s`  | Save session    |
| `C-a C-r`  | Restore session |

## 🔧 TPM

| Keybinding  | Action                 |
| ----------- | ---------------------- |
| `C-a I`     | Install plugins        |
| `C-a U`     | Update plugins         |
| `C-a Alt-u` | Remove missing plugins |

---

# 🧬 Targeting Syntax (Very Important)

```
session:window.pane
```

Examples:

```
dev:2.1
:1
%.3
```

List targets:

```bash
tmux list-sessions
tmux list-windows -a
tmux list-panes -a
```

---

# 🧾 Power CLI Tricks

### Split in current directory

```bash
tmux split-window -h -c "#{pane_current_path}"
tmux split-window -v -c "#{pane_current_path}"
```

### New window in current directory

```bash
tmux neww -c "#{pane_current_path}"
```

## Send keys to a pane

```bash
tmux send-keys -t dev:1.0 "npm run dev" Enter
```

### Send command to pane

```bash
tmux send-keys -t dev:1.0 "npm run dev" Enter
```

### Capture pane output

```bash
tmux capture-pane -pS -2000 > /tmp/output.log
```

## Rename window automatically to current command (manual one-shot)

```bash
tmux rename-window "#{pane_current_command}"
```

---

# 🧨 Debug / Fix Weirdness

| Issue                     | Fix                         |
| ------------------------- | --------------------------- |
| Clipboard not working     | Ensure `wl-copy` exists     |
| Colors wrong              | Confirm `tmux-256color`     |
| Keys delayed              | `escape-time 0` already set |
| Not sure what binds exist | `tmux list-keys`            |

---

# 🧷 Discoverability

| Key              | Description       |
| ---------------- | ----------------- |
| `C-a ?`          | Show all keybinds |
| `C-a /`          | Describe key      |
| `tmux list-keys` | List binds        |
| `tmux show -g`   | Global options    |

---

# ✅ Minimal “Daily Workflow” With Your Setup

1. `tmux new -A -s main`
2. `C-a c` make windows (api/web/ops)
3. Split with `C-a %` / `C-a "`
4. Jump panes fast with **no prefix**: `C-h/j/k/l`
5. Use launchers:

   - `C-a o` (sessionx)
   - `C-a F` (tmux-fzf)
   - `C-a u` (URLs)
   - `C-a Space` (thumbs)
   - `C-a p` (floax)

6. Save/restore:

   - `C-a C-s` / `C-a C-r`

---
