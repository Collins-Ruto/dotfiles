# 🚀 Neovim Keybindings Cheatsheet

> *A comprehensive reference for your NvChad configuration*

## 🔖 Marks & Registers

| Keybinding | Action | Description |
|------------|--------|-------------|
| `ma` | Set Mark | Set mark 'a' at current position |
| `'a` | Go to Mark | Jump to mark 'a' |
| `` `a `` | Go to Mark (exact) | Jump to exact position of mark 'a' |
| `''` | Previous Position | Jump to previous position |
| `"<reg>y` | Yank to Register | Copy to specific register |
| `"<reg>p` | Paste from Register | Paste from specific register |
| `:registers` | Show Registers | Display all register contents |

---

## 🔄 Find & Replace

| Keybinding | Action | Description |
|------------|--------|-------------|
| `:s/old/new/` | Replace First | Replace first occurrence in line |
| `:s/old/new/g` | Replace All Line | Replace all in current line |
| `:%s/old/new/g` | Replace All File | Replace all in entire file |
| `:%s/old/new/gc` | Replace Confirm | Replace with confirmation |
| `:noh` | Clear Highlights | Clear search highlights |

---

## 📊 Macros

| Keybinding | Action | Description |
|------------|--------|-------------|
| `q<letter>` | Record Macro | Start recording macro to register |
| `q` | Stop Recording | Stop macro recording |
| `@<letter>` | Play Macro | Execute recorded macro |
| `@@` | Repeat Macro | Repeat last executed macro |

---

## 🧭 Basic Navigation

| Keybinding | Action | Description |
|------------|--------|-------------|
| `h` / `j` / `k` / `l` | Arrow Movement | Left/Down/Up/Right |
| `w` | Next Word | Move to beginning of next word |
| `b` | Previous Word | Move to beginning of previous word |
| `e` | End of Word | Move to end of current word |
| `0` | Line Start | Move to beginning of line |

---

## 🚀 file wide navigation

| `End` | Line End | Move to end of line |
| `gg` | File Start | Move to beginning of file |
| `G` | File End | Move to end of file |
| `:n` | Go to Line | Jump to line number n |
| `<C-o>` | Jump Back | Previous cursor position |
| `<C-i>` | Jump Forward | Next cursor position |

---

## ✏️ Basic Editing

| Keybinding | Action | Description |
|------------|--------|-------------|
| `i` | Insert Before | Enter insert mode before cursor |
| `a` | Insert After | Enter insert mode after cursor |
| `o` | New Line Below | Create line below and insert |
| `O` | New Line Above | Create line above and insert |
| `r<char>` | Replace Char | Replace character under cursor |
| `R` | Replace Mode | Enter replace mode |
| `x` | Delete Char | Delete character under cursor |
| `X` | Delete Before | Delete character before cursor |
| `dd` | Delete Line | Delete entire line |
| `yy` | Yank Line | Copy entire line |
| `p` | Paste After | Paste after cursor/line |
| `P` | Paste Before | Paste before cursor/line |
| `cw` | Change Word | Delete word and enter insert |
| `cc` | Change Line | Delete line and enter insert |

---

## 📄 File Operations (Basic)

| Keybinding | Action | Description |
|------------|--------|-------------|
| `:w` | Save File | Write current buffer to disk |
| `:q` | Quit | Exit Neovim |
| `:wq` / `:x` | Save & Quit | Write and exit |
| `:q!` | Force Quit | Exit without saving |
| `:e <file>` | Edit File | Open another file |

---

## 📑 Tab Management

| Keybinding | Action | Description |
|------------|--------|-------------|
| `:tabnew` | New Tab | Create new tab |
| `:tabclose` | Close Tab | Close current tab |
| `:tabn` / `:tabnext` | Next Tab | Switch to next tab |
| `:tabp` / `:tabprev` | Previous Tab | Switch to previous tab |

---

## 🎯 Visual Mode Operations

| Keybinding | Action | Description |
|------------|--------|-------------|
| `v` | Visual Mode | Character-wise selection |
| `V` | Visual Line | Line-wise selection |
| `<C-v>` | Visual Block | Block/column selection |
| `y` | Yank Selection | Copy selected text |
| `d` | Delete Selection | Cut selected text |
| `c` | Change Selection | Delete and enter insert |
| `>` | Indent Right | Indent selected lines |
| `<` | Indent Left | Unindent selected lines |

---

## 📁 File Operations

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<Space>ff` | Find Files | Open Telescope file finder |
| `<Space>fa` | Find All Files | Find files including hidden/ignored |
| `<Space>fo` | Find Old Files | Open recently used files |
| `<Space>fb` | Find Buffers | List and switch between open buffers |
| `<Space>e` | File Explorer | Focus NvimTree window |
| `<C-N>` | Toggle Tree | Toggle NvimTree file explorer |
| `<C-S>` | Save File | Save current file |
| `<C-C>` | Copy File | Copy entire file content |

---

## 🔍 Search & Navigation

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<Space>fw` | Live Grep | Search text across project |
| `<Space>fz` | Buffer Search | Find text in current buffer |
| `<Space>fh` | Help Tags | Search help documentation |
| `<Space>ma` | Find Marks | Browse and jump to marks |
| `fw` | Live Grep | Quick search shortcut |
| `fo` | Old Files | Quick recent files access |
| `ff` | Find Files | Quick file finder |
| `/pattern` | Search Forward | Search for pattern in buffer |
| `?pattern` | Search Backward | Search backwards for pattern |
| `n` | Next Match | Go to next search result |
| `N` | Previous Match | Go to previous search result |
| `*` | Search Word Forward | Search word under cursor forward |
| `#` | Search Word Backward | Search word under cursor backward |

---

## 🔧 Buffer Management

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<Space>b` | New Buffer | Create new empty buffer |
| `<Space>x` | Close Buffer | Close current buffer |
| `<Tab>` | Next Buffer | Switch to next buffer |
| `<S-Tab>` | Previous Buffer | Switch to previous buffer |
| `[b` | Previous Buffer | Navigate to previous buffer |
| `]b` | Next Buffer | Navigate to next buffer |
| `[B` | First Buffer | Jump to first buffer |
| `]B` | Last Buffer | Jump to last buffer |

---

## 🖥️ Terminal Operations

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<Space>h` | Horizontal Term | Open horizontal terminal |
| `<Space>v` | Vertical Term | Open vertical terminal |
| `<M-h>` | Toggle H-Term | Toggle horizontal terminal |
| `<M-v>` | Toggle V-Term | Toggle vertical terminal |
| `<M-i>` | Floating Term | Toggle floating terminal |
| `<Space>pt` | Pick Terminal | Select from hidden terminals |

---

## 🎨 Appearance & Themes

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<Space>th` | Theme Selector | Open NvChad theme picker |
| `th` | Themes | Quick theme selector |
| `<Space>n` | Toggle Numbers | Show/hide line numbers |
| `<Space>rn` | Relative Numbers | Toggle relative line numbers |
| `<Esc>` | Clear Highlights | Remove search highlights |

---

## 💬 Comments & Formatting

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<Space>/` | Toggle Comment | Comment/uncomment line |
| `gc` | Toggle Comment | Comment operator |
| `gcc` | Comment Line | Toggle comment on current line |
| `<C-/>` | Comment Line | Alternative comment toggle |
| `<Space>fm` | Format File | Format current file |

---

## 🔄 Git Integration

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<Space>gt` | Git Status | View git status in Telescope |
| `<Space>cm` | Git Commits | Browse git commit history |

---

## 🧭 Window Management

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<C-H>` | Window Left | Move to left window |
| `<C-J>` | Window Down | Move to window below |
| `<C-K>` | Window Up | Move to window above |
| `<C-L>` | Window Right | Move to right window |
| `<Space>=` | Equal Windows | Make all windows equal size |
| `<C-W>d` | Show Diagnostics | Display diagnostics under cursor |

---

## 🔧 LSP & Diagnostics

| Keybinding | Action | Description |
|------------|--------|-------------|
| `gra` | Code Action | Show available code actions |
| `grn` | Rename | Rename symbol under cursor |
| `grr` | References | Find all references |
| `gri` | Implementation | Go to implementation |
| `gO` | Document Symbols | Show document outline |
| `<Space>ds` | Diagnostic List | Open diagnostic location list |
| `[d` | Previous Diagnostic | Jump to previous diagnostic |
| `]d` | Next Diagnostic | Jump to next diagnostic |
| `[D` | First Diagnostic | Jump to first diagnostic |
| `]D` | Last Diagnostic | Jump to last diagnostic |

---

## 📋 Text Manipulation

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<M-j>` | Move Line Down | Move current line down |
| `<M-k>` | Move Line Up | Move current line up |
| `<C-A>` | Select All | Select entire buffer |
| `Y` | Yank to End | Copy from cursor to end of line |
| `[<Space>` | Add Line Above | Insert empty line above |
| `]<Space>` | Add Line Below | Insert empty line below |
| `J` | Join Lines | Join current line with next |
| `>>` | Indent Line | Indent current line |
| `<<` | Unindent Line | Unindent current line |
| `==` | Auto-indent | Auto-indent current line |
| `dw` | Delete Word | Delete word under cursor |
| `D` | Delete to End | Delete from cursor to end of line |
| `C` | Change to End | Change from cursor to end of line |
| `s` | Substitute Char | Delete char and enter insert |
| `S` | Substitute Line | Delete line and enter insert |

---

## 🎯 Navigation Shortcuts

| Keybinding | Action | Description |
|------------|--------|-------------|
| `[q` / `]q` | Quickfix Nav | Navigate quickfix list |
| `[Q` / `]Q` | Quickfix Ends | Jump to quickfix boundaries |
| `[l` / `]l` | Location Nav | Navigate location list |
| `[L` / `]L` | Location Ends | Jump to location boundaries |
| `[t` / `]t` | Tag Nav | Navigate tag stack |
| `[T` / `]T` | Tag Ends | Jump to tag boundaries |
| `gx` | Open URL | Open link under cursor |

---

## 🔀 Folding

| Keybinding | Action | Description |
|------------|--------|-------------|
| `za` | Toggle Fold | Toggle fold at cursor |
| `zR` | Open All Folds | Expand all folds |
| `zM` | Close All Folds | Collapse all folds |
| `zj` | Next Fold | Jump to next fold |
| `zk` | Previous Fold | Jump to previous fold |

---

## ❓ Help & Documentation

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<Space>ch` | Cheatsheet | Open NvChad cheatsheet |
| `ch` | Quick Cheatsheet | Quick cheatsheet access |
| `<Space>wk` | Which Key Query | Search keybinding |
| `<Space>wK` | All Keymaps | Show all available keymaps |

---

## ⚡ Quick Actions

| Keybinding | Action | Description |
|------------|--------|-------------|
| `;` | Command Mode | Enter command mode |
| `&` | Repeat Substitute | Repeat last substitute |
| `#` / `*` | Search Word | Search word under cursor |
| `.` | Repeat Command | Repeat last command |
| `u` | Undo | Undo last change |
| `<C-r>` | Redo | Redo last undone change |

---

## 🎮 Special Modes

### Visual Mode

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<M-j>` | Move Selection Down | Move selected text down |
| `<M-k>` | Move Selection Up | Move selected text up |
| `<Space>/` | Comment Selection | Comment selected lines |

### Insert/Select Mode

| Keybinding | Action | Description |
|------------|--------|-------------|
| `<Tab>` | Snippet Jump | Jump to next snippet position |
| `<S-Tab>` | Snippet Back | Jump to previous snippet position |
| `<C-S>` | Signature Help | Show function signature |

---

# Vim Visual Multi - Key Bindings

## Creating Cursors/Selections

| Key | Action |
|-----|--------|
| `Ctrl+n` | Select word under cursor (normal mode) or selection (visual mode) |
| `Ctrl+Down` | Add cursor vertically down |
| `Ctrl+Up` | Add cursor vertically up |
| `Shift+Arrows` | Start selecting characters |

---

## Navigation & Management

| Key | Action |
|-----|--------|
| `n` | Find next occurrence |
| `N` | Find previous occurrence |
| `]` | Go to next cursor/region |
| `[` | Go to previous cursor/region |
| `q` | Skip current and go to next |
| `Q` | Remove current region |
| `Tab` | Switch between cursor and extend mode |

---

## Fast Navigation

| Key | Action |
|-----|--------|
| `Ctrl+f` | Fast forward (go to first region in next page) |
| `Ctrl+b` | Fast backward (go to first region in previous page) |

---

## Search Options (after selection)

| Key | Action |
|-----|--------|
| `\\w` | Toggle whole word search |
| `\\c` | Cycle case setting (sensitive → ignorecase → smartcase) |

---

## Find Operator (VM must be active)

| Key | Action |
|-----|--------|
| `m{motion}` | Find all occurrences in motion range |
| `mj` | Find occurrences in line below |
| `m8j` | Find occurrences in 8 lines below |
| `mip` | Find occurrences inside paragraph |
| `mas` | Find occurrences around sentence |

---

## Mouse Support (if enabled)

| Key | Action |
|-----|--------|
| `Ctrl+LeftMouse` | Create cursor at clicked position |
| `Ctrl+RightMouse` | Select clicked word |
| `Meta+Ctrl+RightMouse` | Create column of cursors to clicked line |

---

## Notes

- `\\` is the default leader key (configurable with `g:VM_leader`)
- Arrow keys and Ctrl+arrows move around without affecting cursors
- `hjkl` moves all cursors together
- Can replace `Ctrl+n` with `Ctrl+d` via configuration
- Cursors skip shorter lines when adding vertically
- Can add cursors on empty lines when starting at column 1

---

## 💡 Pro Tips

- **Leader Key**: `<Space>` is your main leader key for most operations
- **Telescope**: Most `<Space>f*` commands use Telescope for fuzzy finding
- **Terminal**: Use `<M-*>` (Alt) combinations for quick terminal access
- **Navigation**: Use `[` and `]` for forward/backward navigation
- **Which Key**: Press `<Space>wk` to search for any keybinding you forgot

---

*Generated from NvChad configuration - Keep this handy for quick reference!* ✨
