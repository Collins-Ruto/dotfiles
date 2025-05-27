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
  vim.cmd("normal! ==")
end, { noremap = true, silent = true, desc = "Move line down with count" })

vim.keymap.set("n", "<A-k>", function()
  local count = vim.v.count > 0 and vim.v.count or 1
  vim.cmd(string.format("move .-%d", count + 1)) -- +1 to avoid invalid range
  vim.cmd("normal! ==")
end, { noremap = true, silent = true, desc = "Move line up with count" })


-- Visual mode: Move selection up/down
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up" })

-- Normal & Visual mode select all
vim.keymap.set({'n', 'i'}, '<C-a>', '<Esc>ggVG', { noremap = true, silent = true })

-- Normal mode: Toggle comment on current line
map("n", "<C-/>", function ()
  require("Comment.api").toggle.linewise.current()
end, vim.tbl_extend("force", opts, { desc = "Toggle comment (line)" }))

-- Visual mode: Toggle comment on selection
map("v", "<C-/>", function()
  local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
  vim.api.nvim_feedkeys(esc, "nx", false)
  require("Comment.api").toggle.linewise(vim.fn.visualmode())
end, vim.tbl_extend("force", opts, { desc = "Toggle comment (visual)" }))

-- equalize all windows
vim.keymap.set('n', "<leader>=", "<C-W><C-=>", { noremap = true })

vim.keymap.set("n", "zR", "zR", { desc = "Open all folds" })
vim.keymap.set("n", "zM", "zM", { desc = "Close all folds" })
vim.keymap.set("n", "za", "za", { desc = "Toggle fold at cursor" })
vim.keymap.set("n", "zk", "zk", { desc = "Previous fold" })
vim.keymap.set("n", "zj", "zj", { desc = "Next fold" })

