vim.defer_fn(function()
  pcall(require, "impatient")
end, 0)

require "core"
require "core.options"

-- setup packer + plugins
local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/opt/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e222a" })
  print "Cloning packer .."
  fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }

  -- install plugins + compile their configs
  vim.cmd "packadd packer.nvim"
  require "plugins"
  vim.cmd "PackerSync"

  -- install binaries from mason.nvim & tsparsers
  vim.api.nvim_create_autocmd("User", {
    pattern = "PackerComplete",
    callback = function()
      vim.cmd "bw | silent! MasonInstallAll" -- close packer window
      require("packer").loader "nvim-treesitter"
    end,
  })
end


vim.cmd [[
" system clipboard
nmap <c-c> "+y
vmap <c-c> "+y
nmap <c-v> "+p
inoremap <c-v> <c-r>+
cnoremap <c-v> <c-r>+
" use <c-r> to insert original character without triggering things like auto-pairs
inoremap <c-r> <c-v>
]]

vim.api.nvim_set_keymap('n', '<End>', '$', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<End>', '<Esc>$a', { noremap = true, silent = true })

-- Create the custom command
function _G.create_file()
  local filename = vim.fn.input("Enter file name: ")
  if filename ~= "" then
        local path = vim.fn.expand("%:p:h")
      local filepath = path .. "/" .. filename
      vim.cmd("silent! execute 'write !touch " .. filepath .. "'")
      vim.cmd("edit " .. filepath)
    end
end

--[[
require('nvim-tree').setup(
  {
    view = {},
  }
) 
vim.cmd([[
augroup NvimTreeStartup
    autocmd!
    autocmd VimEnter * NvimTreeOpen
augroup END
]] -- ) 
--]]

vim.cmd([[command! CreateFile lua create_file()]])

pcall(require, "custom")

require("core.utils").load_mappings()
