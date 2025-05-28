-- require("nvchad.configs.lspconfig").defaults()
-- configs/lspconfig.lua

local default_config = require "nvchad.configs.lspconfig"
local on_attach = default_config.on_attach
local capabilities = default_config.capabilities

local lspconfig = require "lspconfig"

-- Enable basic servers via Mason
local servers = { "tsserver", "tailwindcss", "biome" }

for _, server_name in ipairs(servers) do
  server_name = server_name == "tsserver" and "ts_ls" or server_name
  lspconfig[server_name].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Optional: tailwindcss extra setup
lspconfig.tailwindcss.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {
    "html",
    "css",
    "scss",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
  },
  -- init_options = {
  --   userLanguages = {
  --     eelixir = "html", -- Phoenix
  --     eruby = "html", -- Rails
  --   },
  -- },
}

--
-- local servers = { "html", "cssls" }
-- vim.lsp.enable(servers)
--
-- -- read :h vim.lsp.config for changing options of lsp servers
