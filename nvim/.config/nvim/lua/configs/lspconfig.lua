local cmp_nvim_lsp = require "cmp_nvim_lsp"

-- Capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

-- Custom on_attach
local function custom_on_attach(client, bufnr)
  local opts = { buffer = bufnr, silent = true }

  -- Hover
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

  -- Diagnostic float
  vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, opts)

  -- NvChad defaults
  local default_config = require "nvchad.configs.lspconfig"
  if default_config.on_attach then
    default_config.on_attach(client, bufnr)
  end
end

local on_attach = custom_on_attach

-- TypeScript and Biome
local servers = { "ts_ls", "biome" }

for _, server_name in ipairs(servers) do
  vim.lsp.config(server_name, {
    on_attach = on_attach,
    capabilities = capabilities,
  })

  vim.lsp.enable(server_name)
end

-- TailwindCSS
vim.lsp.config("tailwindcss", {
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
})

vim.lsp.enable "tailwindcss"
-- Clangd with formatting disabled
vim.lsp.config("clangd", {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
})

vim.lsp.enable "clangd"
