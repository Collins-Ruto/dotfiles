local options = {
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    lua = { "stylua" },
    json = { "prettier" },

    -- css = { "prettier" },
    -- html = { "prettier" },
  },
  formatters = {
    stylua = {
      command = "stylua",
      args = {
        "--search-parent-directories",
        "--stdin-filepath",
        "$FILENAME",
        "--",
        "-",
      },
    },
  },

  -- format_on_save = {
  --   -- These options will be passed to conform.format()
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}

return options
