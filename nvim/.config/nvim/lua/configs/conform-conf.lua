local options = {
  formatters_by_ft = {
    lua = { "stylua" },

    -- Use Biome for JS/TS
    javascript = { "biome", "biome-organize-imports" },
    typescript = { "biome", "biome-organize-imports" },
    javascriptreact = { "biome", "biome-organize-imports" },
    typescriptreact = { "biome", "biome-organize-imports" },

    -- Optional: keep Prettier fallback
    -- javascript = { "biome", { "prettierd", "prettier", stop_after_first = true } },

    json = { { "prettierd", "prettier", stop_after_first = true } },
    graphql = { { "prettierd", "prettier", stop_after_first = true } },
    markdown = { { "prettierd", "prettier", stop_after_first = true } },
    html = { "htmlbeautifier" },
    bash = { "beautysh" },
    rust = { "rustfmt" },
    css = { { "prettierd", "prettier", stop_after_first = true } },
    scss = { { "prettierd", "prettier", stop_after_first = true } },
    sh = { "shellcheck" },
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

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
