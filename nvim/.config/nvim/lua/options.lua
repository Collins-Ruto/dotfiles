require "nvchad.options"

-- add yours here!
vim.opt.relativenumber = true
-- local o = vim.o
-- o.cursorlineopt ='both' -- to enable cursorline!
--
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    local ok, ibl = pcall(require, "ibl")
    if ok then
      ibl.setup {}
    end
  end,
})
