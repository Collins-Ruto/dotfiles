local lspconfig = require "lspconfig"
local cmp_nvim_lsp = require "cmp_nvim_lsp"

-- Capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

-- 🌟 Define custom_on_attach first!
local function custom_on_attach(client, bufnr)
  local opts = { buffer = bufnr, silent = true }

  -- Hover
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

  -- Diagnostic float
  vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, opts)

  -- NvChad default behavior
  local default_config = require "nvchad.configs.lspconfig"
  if default_config.on_attach then
    default_config.on_attach(client, bufnr)
  end
end

-- ✅ Assign AFTER it's defined
local on_attach = custom_on_attach

-- LSP Servers
local servers = { "tsserver", "tailwindcss", "biome" }

for _, server_name in ipairs(servers) do
  server_name = server_name == "tsserver" and "ts_ls" or server_name
  lspconfig[server_name].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- TailwindCSS special case
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
}

-- Clangd with formatting disabled
lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    on_attach(client, bufnr)
  end,
  capabilities = capabilities,
}

-- Diagnostics display config
vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
    spacing = 2,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}
