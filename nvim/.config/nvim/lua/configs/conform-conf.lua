local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    bash = { "beautysh" },
    sh = { "shellcheck" },
    rust = { "rustfmt" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    json = { "prettierd", "prettier" },
    css = { "prettierd", "prettier" },
    scss = { "prettierd", "prettier" },
    graphql = { "prettierd", "prettier" },
    markdown = { "prettierd", "prettier" },
    html = { "htmlbeautifier", "prettier" },
    javascript = { "biome", "biome-organize-imports" },
    typescript = { "biome", "biome-organize-imports" },
    javascriptreact = { "biome", "biome-organize-imports" },
    typescriptreact = { "biome", "biome-organize-imports" },
    -- javascript = { "biome", { "prettierd", "prettier", stop_after_first = true } },
  },

  formatters = {
    json = { stop_after_first = true },
    graphql = { stop_after_first = true },
    markdown = { stop_after_first = true },
    css = { stop_after_first = true },
    scss = { stop_after_first = true },
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
    ["clang-format"] = {
      prepend_args = {
        "-style={ \
                IndentWidth: 4, \
                TabWidth: 4, \
                UseTab: Never, \
                AccessModifierOffset: 0, \
                IndentAccessModifiers: true, \
                PackConstructorInitializers: Never}",
      },
    },
  },

  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

return options
