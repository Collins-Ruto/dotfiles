require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Normal mode: Move line up/down
-- map("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move line down" })
-- map("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up" })

vim.keymap.set("n", "<A-j>", function()
  local count = vim.v.count > 0 and vim.v.count or 1
  vim.cmd(string.format("move .+%d", count))
  vim.cmd "normal! =="
end, { noremap = true, silent = true, desc = "Move line down with count" })

vim.keymap.set("n", "<A-k>", function()
  local count = vim.v.count > 0 and vim.v.count or 1
  vim.cmd(string.format("move .-%d", count + 1)) -- +1 to avoid invalid range
  vim.cmd "normal! =="
end, { noremap = true, silent = true, desc = "Move line up with count" })

-- Visual mode: Move selection up/down
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up" })

-- Normal & Visual mode select all
vim.keymap.set({ "n", "i" }, "<C-a>", "<Esc>ggVG", { noremap = true, silent = true })

-- Normal mode: Toggle comment on current line
map("n", "<C-/>", function()
  require("Comment.api").toggle.linewise.current()
end, vim.tbl_extend("force", opts, { desc = "Toggle comment (line)" }))

-- Visual mode: Toggle comment on selection
map("v", "<C-/>", function()
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, vim.tbl_extend("force", opts, { desc = "Toggle comment (visual)" }))

-- equalize all windows
vim.keymap.set("n", "<leader>=", "<C-W><C-=>", { noremap = true })

vim.keymap.set("n", "zR", "zR", { desc = "Open all folds" })
vim.keymap.set("n", "zM", "zM", { desc = "Close all folds" })
vim.keymap.set("n", "za", "za", { desc = "Toggle fold at cursor" })
vim.keymap.set("n", "zk", "zk", { desc = "Previous fold" })
vim.keymap.set("n", "zj", "zj", { desc = "Next fold" })

vim.api.nvim_create_autocmd("User", {
  pattern = "VisualMultiLoaded",
  callback = function()
    vim.api.nvim_set_keymap("n", "<F26>", "<Plug>(VM-Select-All)", {})
    vim.api.nvim_set_keymap("x", "<F26>", "<Plug>(VM-Visual-All)", {})
  end,
})

vim.keymap.set("n", "<leader>z", "<cmd>Telescope zoxide list<cr>", { desc = "Zoxide jump (Oil)" })
vim.keymap.set("n", "<leader>nd", "<cmd>NoiceDismiss<CR>", { desc = "Dismiss Noice Message" })

vim.keymap.set("n", "-", function()
  require("oil").open_float()
end, { desc = "[O]il [F]loating window" })

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { timeout = 200 }
  end,
})

-- Make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", {
  silent = true,
  desc = "Make current file executable",
})

-- Copy file name or path
vim.keymap.set("n", "<leader>cf", "<cmd>let @+ = expand('%')<CR>", { desc = "Copy File Name" })
vim.keymap.set("n", "<leader>cp", "<cmd>let @+ = expand('%:p')<CR>", { desc = "Copy File Path" })

-- Visual mode indent and keep selection
vim.keymap.set("v", "<", "<gv", { desc = "Indent left and reselect" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right and reselect" })

vim.keymap.set("v", "/", 'y/\\c<C-R>"', { desc = "Search selected text (ignore case)" })

-- Create key mapping: <leader>mv to start Visual Multi
vim.keymap.set("n", "<leader>mv", ":VMSearch<CR>", { desc = "Start Visual Multi", silent = true })

-- Unmap <C-n> in normal mode (if previously set by something else)
vim.keymap.del("n", "<C-n>")

-- Configure Visual Multi mappings
vim.o.mouse = "a"
vim.g.VM_maps = vim.g.VM_maps or {}
-- Set Visual Multi leader key
vim.g.VM_leader = "\\"

-- Keyboard mappings
vim.g.VM_maps["Find Under"] = "<C-n>"
vim.g.VM_maps["Find Subword Under"] = "<C-n>"

-- Mouse mappings
vim.g.VM_maps["Mouse Cursor"] = "<C-LeftMouse>" -- Toggle VM cursor at click
vim.g.VM_maps["Mouse Word"] = "<C-RightMouse>" -- Select word under mouse
vim.g.VM_maps["Mouse Column"] = "<M-C-RightMouse>" -- Block selection (column mode)

-- Start visual mode and move right/left
vim.keymap.set("n", "<S-Right>", "v<Right>", { noremap = true })
vim.keymap.set("n", "<S-Left>", "v<Left>", { noremap = true })
vim.keymap.set("n", "<S-Up>", "v<Up>", { noremap = true })
vim.keymap.set("n", "<S-Down>", "v<Down>", { noremap = true })
-- in visual mode
vim.keymap.set("v", "<S-Right>", "<Right>", { noremap = true })
vim.keymap.set("v", "<S-Left>", "<Left>", { noremap = true })
vim.keymap.set("v", "<S-Up>", "<Up>", { noremap = true })
vim.keymap.set("v", "<S-Down>", "<Down>", { noremap = true })
-- in insert mode
vim.keymap.set("i", "<S-Right>", "<Esc>v<Right>", { noremap = true })
vim.keymap.set("i", "<S-Left>", "<Esc>v<Left>", { noremap = true })
vim.keymap.set("i", "<S-Up>", "<Esc>v<Up>", { noremap = true })
vim.keymap.set("i", "<S-Down>", "<Esc>v<Down>", { noremap = true })

-- In visual mode, select to beginning/end of line
vim.keymap.set("v", "<S-Home>", "^", { noremap = true })
vim.keymap.set("v", "<S-End>", "$", { noremap = true })

-- From normal mode
vim.keymap.set("n", "<S-Home>", "v^", { noremap = true })
vim.keymap.set("n", "<S-End>", "v$", { noremap = true })

-- From insert mode
vim.keymap.set("i", "<S-Home>", "<Esc>v^", { noremap = true })
vim.keymap.set("i", "<S-End>", "<Esc>v$", { noremap = true })

-- vim.keymap.set("x", "<C-F2>", "<Plug>(VM-Visual-All)", {
--   desc = "Select all occurrences of selection",
--   remap = true,
-- })
--
-- vim.keymap.set("n", "<C-F2>", "<Plug>(VM-Select-All)", {
--   desc = "Select all occurrences",
--   remap = true,
-- })
